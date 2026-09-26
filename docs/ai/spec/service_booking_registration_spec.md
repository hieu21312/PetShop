# Service Registration & Booking Architecture & Business Logic Spec

- **Author / Active Role**: Planner
- **Target Module(s)**: Backend Spring Boot (PetShop.demo), Database SQL Server (QL_PetShop), Web UI (ThymeLeaf templates / controllers)
- **Status**: Pending Approval / Ready for Implementation
- **Created Date**: 2026-09-25

---

## 1. Problem Statement & Real Root Need

- **Observed Pain Point / Feature Request**: Khách hàng cần quy trình 2 bước rõ ràng: 
  - **Bước 1: Đăng ký / Chọn dịch vụ**: Chọn dịch vụ cụ thể cho thú cưng (Tắm gội, Cắt tỉa lông, Vệ sinh, Khám bệnh, Tiêm phòng...).
  - **Bước 2: Đặt lịch dịch vụ**: Sau khi chọn dịch vụ, khách hàng chọn Ngày (`NgayDat`) + Giờ/Khung giờ (`GioDat`) phù hợp để thực hiện dịch vụ tại PetShop.
- **Real Problem Statement**: Giao diện và API hiện tại đã có `DichVu.html` và `BookingController.java`, nhưng chưa thể hiện luồng chuyển tiếp mượt mà từ bước chọn dịch vụ -> chọn ngày giờ slot -> xác nhận lịch hẹn kèm thông tin thú cưng/khách hàng.
- **Impact & Urgency**: Giúp khách hàng đặt dịch vụ dễ dàng, trực quan, giảm tỷ lệ bỏ dở và nâng cao hiệu quả quản lý lịch làm việc của nhân viên thú y.

---

## 2. Goals & Non-Goals

### Goals
- [ ] **Bước 1 - Chọn dịch vụ**: Danh sách dịch vụ hiển thị rõ loại hình dịch vụ (Tắm gội, Cắt tỉa lông, Vệ sinh móng/tai, Khám bệnh, Tiêm phòng...), giá dịch vụ, mô tả và nút "Đặt lịch ngay".
- [ ] **Bước 2 - Chọn ngày & khung giờ**: Form đặt lịch cho phép chọn Ngày + Khung giờ (vd: 08:30, 09:30, 10:30, 14:00, 15:30...), nhập thông tin khách hàng (Tên, SĐT, Email, Ghi chú thú cưng).
- [ ] **Khách đã đăng nhập**: Tự động điền dữ liệu cá nhân, liên kết `MaKH`.
- [ ] **Khách vãng lai**: Điền thông tin trực tiếp, tự động tra cứu SĐT/Email để liên kết tài khoản nếu có.
- [ ] **Quản lý lịch hẹn**: Trang `/LichSuDatLich` cho Khách hàng và `/admin/bookings` cho Admin cập nhật trạng thái (`Chờ xác nhận`, `Đã xác nhận`, `Hoàn thành`, `Đã hủy`).

### Non-Goals
- [ ] Thanh toán trực tuyến tích hợp ngân hàng (Momo/VNPay/VietQR) ngay trong bước đặt lịch (Sẽ thanh toán tại quầy hoặc sau khi hoàn thành dịch vụ).
- [ ] Đặt lịch nâng cao với nhiều địa điểm/chi nhánh (Chỉ áp dụng cho 1 cửa hàng PetShop).

---

## 3. Constraints, Invariants & Data Tracing

- **Business Constraints**: 
  - Khách hàng không thể đặt lịch ở thời điểm trong quá quá khứ (Validation ở cả Frontend & Service layer).
  - Tách bạch logic nghiệp vụ ở Service (`BookingService`, `AuthService`), Controller chỉ thực hiện routing & HTTP contract handling.
  - Không hardcode dữ liệu giả (Mock Data) trong mã nguồn.
- **Data Trace & Models**:
  - Bảng `tblKhachHang`: `MaKH` (INT, PK), `TenKH` (NVARCHAR), `MatKhau` (NVARCHAR), `DienThoai` (NVARCHAR), `Email` (NVARCHAR), `DiaChi` (NVARCHAR).
  - Bảng `tblDichVu`: `MaDV` (INT, PK), `TenDV` (NVARCHAR), `MoTa` (NVARCHAR), `GiaDichVu` (DECIMAL).
  - Bảng `tblDatLich`: `MaDatLich` (INT, PK), `MaDV` (INT, FK), `MaKH` (INT, FK, Nullable), `TenKhachHang` (NVARCHAR), `SoDienThoai` (NVARCHAR), `Email` (NVARCHAR), `NgayDat` (DATE), `GioDat` (TIME), `GhiChu` (NVARCHAR), `TrangThai` (NVARCHAR), `NgayTao` (DATETIME).
- **API / Web Contracts**:
  - `GET /DichVu`: Hiển thị danh sách dịch vụ.
  - `GET /DatLich?maDV={id}`: Trang form đặt lịch cho dịch vụ `maDV`.
  - `POST /DatLich`: Tiếp nhận yêu cầu đặt lịch, validate ngày giờ và tạo record trong `tblDatLich`.
  - `GET /LichSuDatLich`: Danh sách lịch đặt của khách hàng đang đăng nhập.
  - `POST /DatLich/Huy/{id}`: Cho phép khách hàng hủy lịch khi còn ở trạng thái `Chờ xác nhận`.
  - `GET /admin/bookings`: Admin xem danh sách toàn bộ lịch đặt.
  - `POST /admin/bookings/updateStatus`: Admin duyệt/đổi trạng thái lịch đặt.

---

## 4. Candidate Options & Trade-offs

### Option A (Primary Proposed Approach - Integrated Auth & Dynamic Slot Reservation)
- **Description**: Khách hàng chọn dịch vụ -> Hệ thống kiểm tra session đăng nhập. Nếu chưa đăng nhập, hiển thị form Đặt lịch hỗ trợ Đăng ký nhanh (Quick Register) hoặc Đặt dạng Khách (Guest). Dữ liệu được đẩy qua `BookingService` thực hiện validate logic (Slot constraint & Date time) trước khi lưu vào `tblDatLich`.
- **Pros**: Linh hoạt cho cả khách mới lẫn khách cũ, trải nghiệm nhanh chóng, giữ kiến trúc chuẩn Clean Architecture / Spring Boot MVC.
- **Cons & Trade-offs**: Cần thêm bước xử lý Đăng ký tài khoản tự động hoặc liên kết tài khoản nếu Email/SĐT đã tồn tại.

### Option B (Strict Auth First Approach)
- **Description**: Bắt buộc khách hàng phải Đăng ký & Đăng nhập thành công 100% trước khi truy cập vào form Đặt lịch (`/DatLich`).
- **Why Rejected**: Làm tăng rào cản chuyển đổi (friction), khách hàng vãng lai muốn đặt nhanh dịch vụ tắm gội sẽ bị thoát trang nếu bắt buộc đăng ký nhiều bước rườm rà.

---

## 5. Critical Flaw Analysis (Self-Adversarial Check)

> **Mandatory Planner Self-Check:**
> 1. **Strongest Objection**: Khách vãng lai đặt lịch trùng SĐT/Email với khách đã có tài khoản sẽ tạo ra sự bất nhất dữ liệu `MaKH` trong `tblDatLich`.
>    *Giải pháp*: `BookingService` sẽ chủ động tra cứu SĐT/Email trong `tblKhachHang`, nếu tìm thấy sẽ gán tự động `MaKH` tương ứng vào record `Booking`.
> 2. **Hidden Assumptions**: Giả định rằng cửa hàng có thể phục vụ số lượng đặt lịch không giới hạn tại cùng một khung giờ.
>    *Giải pháp*: Cần bổ sung cấu hình giới hạn (Cap) số lượng Slot tối đa cho mỗi khung giờ (ví dụ: tối đa 3 ca/khung giờ) trong `BookingService`.
> 3. **Alternative Not Explored**: Chưa xem xét việc gửi Email / SMS OTP xác nhận lịch hẹn để tránh SPAM đặt lịch ảo.
>    *Giải pháp*: Đánh dấu tính năng gửi Email OTP là bước mở rộng trong Phase 2 sau khi luồng core booking hoạt động ổn định.

---

## 6. Target Layering & Affected Components

| Layer | Component / File | Proposed Responsibility |
| :--- | :--- | :--- |
| **Database** | SQL Server `QL_PetShop.sql` / `tblDatLich` | Lưu trữ thông tin lịch hẹn, trạng thái, liên kết `MaDV` & `MaKH`. |
| **Business Service** | `BookingService.java`, `AuthService.java` | Validate thời gian, check trùng slot, tra cứu/gán `MaKH`, chuyển đổi trạng thái. |
| **API / Controller** | `BookingController.java`, `AuthController.java` | Tiếp nhận request form `/DatLich`, `/DangKy`, `/LichSuDatLich`, mapping Model & view HTML. |
| **Frontend UI** | `DichVu.html`, `booking-form.html`, `my-bookings.html` | Form chọn ngày/giờ, nhập thông tin pet/khách hàng, hiển thị danh sách lịch hẹn. |

---

## 7. Verification & Rollback Strategy

### Verification Plan
- [ ] Test luồng Khách đã đăng nhập đặt lịch -> Kiểm tra `MaKH` lưu đúng vào DB.
- [ ] Test luồng Khách vãng lai đặt lịch -> Kiểm tra thông tin `TenKhachHang`, `SoDienThoai`, `Email` lưu đầy đủ.
- [ ] Test validate chọn ngày/giờ trong quá quá khứ -> Hệ thống báo lỗi FlashAttribute và giữ lại input.
- [ ] Test Admin duyệt thay đổi trạng thái từ `Chờ xác nhận` sang `Đã xác nhận` & `Hoàn thành`.
- [ ] Chạy Sanity Build: `mvn clean package` hoặc `./mvnw compile`.

### Rollback Strategy
- [ ] Revert commit trên Git nếu phát sinh lỗi Controller / View.
- [ ] Rollback dữ liệu test trong bảng `tblDatLich`.

---

## 8. Open Decisions (If Any)

- [ ] Xác nhận với Khách hàng/User: Có cần thêm trường thông tin Chi tiết Thú Cưng (Tên Pet, Giống loài, Cân nặng) vào Form Đặt lịch hay chỉ cần Ghi chú chung?
