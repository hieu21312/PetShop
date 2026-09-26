# Staff & Vet Service Dispatch & Assignment Spec

- **Author / Active Role**: Planner
- **Target Module(s)**: Backend Spring Boot (`PetShop.demo`), Database SQL Server (`QL_PetShop`), Admin Booking Management & Staff Task Portal
- **Status**: Pending Approval / Ready for Implementation
- **Created Date**: 2026-09-25

---

## 1. Problem Statement & Real Root Need

- **Observed Pain Point / Feature Request**: Admin cần tính năng phân công Bác sĩ Thú y hoặc Nhân viên Chăm sóc thông minh và kiểm soát khối lượng công việc cho từng ca lịch hẹn (`tblDatLich`). Đồng thời, Bác sĩ/Nhân viên cần trang theo dõi lịch phân công cá nhân (`/staff/my-tasks`) để cập nhật tiến độ công việc.
- **Real Problem Statement**: Hiện tại hệ thống đã có trường `MaNV` trong `tblDatLich` và dropdown gán nhân sự cơ bản, nhưng chưa có:
  1. **Lọc thông minh theo loại dịch vụ**: Khám bệnh/Tiêm phòng chỉ cho phép chọn Bác sĩ Thú y; Tắm/Cắt tỉa chỉ cho phép chọn Nhân viên chăm sóc.
  2. **Cảnh báo trùng ca làm việc**: Chưa kiểm tra xem Bác sĩ/Nhân viên đó đã có ca khác trong cùng khung giờ hay chưa.
  3. **Giao diện làm việc cho Nhân sự (`/staff/my-tasks`)**: Bác sĩ/Nhân viên sau khi đăng nhập chưa có trang riêng để xem danh sách lịch phân công của mình trong ngày và bấm hoàn thành dịch vụ kèm ghi chú y khoa/chăm sóc.
- **Impact & Urgency**: Giúp tối ưu vận hành cửa hàng, tránh việc phân công trùng ca cho Bác sĩ, và tăng tính chuyên nghiệp trong giao việc.

---

## 2. Goals & Non-Goals

### Goals
- [ ] **Lọc Nhân Sự Theo Dịch Vụ (Smart Filtering)**:
  - Khi Admin chọn phân công cho lịch đặt dịch vụ Khám/Tiêm -> Dropdown chỉ hiển thị danh sách **Bác sĩ thú y**.
  - Khi Admin chọn phân công cho lịch đặt Spa/Cắt tỉa -> Dropdown chỉ hiển thị danh sách **Nhân viên chăm sóc**.
- [ ] **Kiểm Tra Xung Đột Ca Làm Việc (Schedule Conflict Validation)**:
  - `BookingService` đếm số đơn mà `MaNV` đã nhận trong cùng `NgayDat` & `GioDat`.
  - Nếu `MaNV` đã có 1 ca khác chưa hoàn thành trong mốc giờ đó, hệ thống đưa ra cảnh báo cho Admin.
- [ ] **Giao Diện Phân Công Cá Nhân (`/staff/my-tasks`)**:
  - Bác sĩ/Nhân viên đăng nhập tài khoản nhân sự có thể tra cứu danh sách các ca đặt lịch được giao cho mình theo Ngày.
  - Cho phép cập nhật tiến độ: `Chờ phục vụ` -> `Đang thực hiện` -> `Hoàn thành` (kèm Ghi chú kết quả khám / lưu ý dịch vụ).

### Non-Goals
- [ ] Tự động chấm điểm KPI hoặc chia hoa hồng cho Bác sĩ.
- [ ] Gửi SMS tự động thông báo ca làm việc tới điện thoại Bác sĩ (chỉ thông báo trên Web Portal).

---

## 3. Constraints, Invariants & Data Tracing

- **Business Constraints**: 
  - Chỉ Admin mới có quyền phân công hoặc thay đổi Bác sĩ/Nhân viên phụ trách.
  - Bác sĩ/Nhân viên chỉ được cập nhật trạng thái ca làm việc mà mình được phân công.
- **Data Trace & Models**:
  - `tblDatLich`: `MaDatLich` (PK), `MaDV` (FK -> tblDichVu), `MaKH` (FK -> tblKhachHang), `MaNV` (FK -> tblNhanVien), `NgayDat`, `GioDat`, `TrangThai`, `GhiChu`.
  - `tblNhanVien`: `MaNV` (PK), `TenNV`, `VaiTro` (FK -> tblVaiTro), `ChuyenMon`, `TrangThai`.
  - `tblDichVu`: `MaDV` (PK), `TenDV`, `MoTa`, `GiaDichVu`.
- **API / Web Contracts**:
  - `POST /admin/bookings/assignStaff`: Tiếp nhận `maDatLich` & `maNV`, validate xung đột ca, cập nhật `tblDatLich.MaNV`.
  - `GET /staff/my-tasks`: Trang hiển thị danh sách công việc của Bác sĩ/Nhân viên đang đăng nhập.
  - `POST /staff/my-tasks/updateProgress`: Bác sĩ/Nhân viên cập nhật trạng thái ca (`Đang thực hiện` / `Hoàn thành`) & ghi chú kết quả.

---

## 4. Candidate Options & Trade-offs

### Option A (Primary Proposed Approach - Service Category Auto-Matching & Staff Portal)
- **Description**: Hệ thống tự động nhận biết loại dịch vụ để filter danh sách nhân sự phù hợp (Bác sĩ vs Groomer) trên UI Admin. Bổ sung trang `/staff/my-tasks` để Bác sĩ/Nhân viên tự quản lý tiến độ công việc.
- **Pros**: Phân công chuẩn xác theo chuyên môn, hạn chế tối đa sai sót gán nhầm nhân sự, luồng công việc khép kín từ Đặt lịch -> Phân công -> Thực hiện -> Hoàn thành.
- **Cons & Trade-offs**: Cần thêm 1 Controller nhẹ `StaffTaskController.java` để phục vụ giao diện cá nhân cho Nhân sự.

### Option B (Manual Selection Without Validation Approach)
- **Description**: Admin tự nhìn tên dịch vụ và chọn bất kỳ nhân viên nào trong danh sách tổng không qua lọc hay kiểm tra trùng ca.
- **Why Rejected**: Dễ xảy ra sai sót gán nhân viên Spa đi khám bệnh, hoặc gán 2 ca cùng lúc cho 1 Bác sĩ gây chồng chéo công việc.

---

## 5. Critical Flaw Analysis (Self-Adversarial Check)

> **Mandatory Planner Self-Check:**
> 1. **Strongest Objection**: Bác sĩ có thể cần thực hiện 2 ca khám liên tiếp trong cùng mốc 1 giờ (ví dụ: ca 15 phút).
>    *Giải pháp*: Cho phép Admin xác nhận ghi đè (Override) phân công nếu thực sự cần thiết, nhưng hiển thị badge cảnh báo "Đã có 1 ca trong khung giờ này".
> 2. **Hidden Assumptions**: Giả định rằng dịch vụ trong database đã được phân loại rõ ràng thành Dịch vụ Y Tế (Khám/Tiêm) và Dịch vụ Spa.
>    *Giải pháp*: Tra cứu theo tên dịch vụ (`TenDV` chứa từ "Khám", "Tiêm", "Bệnh", "Thú y" -> Bác sĩ; ngược lại -> Nhân viên chăm sóc).

---

## 6. Target Layering & Affected Components

| Layer | Component / File | Proposed Responsibility |
| :--- | :--- | :--- |
| **Database** | SQL Server `QL_PetShop.sql` (`tblDatLich`, `tblNhanVien`, `tblDichVu`) | Lưu bản ghi phân công `MaNV`, ngày giờ ca và ghi chú kết quả. |
| **Business Service** | `BookingService.java`, `EmployeeService.java` | Validate xung đột ca làm việc, tra cứu danh sách nhân sự phù hợp theo dịch vụ. |
| **Controller** | `BookingController.java`, `StaffTaskController.java` | Endpoint phân công Admin `/admin/bookings/assignStaff` và Endpoint cá nhân `/staff/my-tasks`. |
| **Frontend UI** | `admin/bookings.html`, `staff/my-tasks.html` | UI phân công lọc theo vai trò & giao diện bảng công việc cá nhân của Bác sĩ/Nhân viên. |

---

## 7. Verification & Rollback Strategy

### Verification Plan
- [ ] Test Admin phân công Bác sĩ cho dịch vụ Khám bệnh -> Dropdown ưu tiên hiển thị danh sách Bác sĩ.
- [ ] Test phân công 2 ca cùng mốc giờ cho 1 Bác sĩ -> Hệ thống đưa ra cảnh báo trùng ca.
- [ ] Test Bác sĩ đăng nhập vào `/staff/my-tasks` -> Hiển thị đúng các ca được phân công trong ngày.
- [ ] Test Bác sĩ đổi trạng thái ca sang `Hoàn thành` -> Cập nhật đồng bộ lên trang Admin & Lịch sử khách hàng.
- [ ] Chạy Sanity Build: `.\mvnw.cmd compile`.

### Rollback Strategy
- [ ] Revert mã nguồn trên Git nếu phát sinh lỗi routing.

---

## 8. Open Decisions (If Any)

- [ ] Xác nhận với Khách hàng/User: Bạn có muốn bổ sung nút Bật/Tắt chế độ "Cho phép Bác sĩ nhận tối đa 2 ca/khung giờ" hay cố định 1 ca/Bác sĩ/khung giờ?
