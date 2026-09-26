# Veterinarian & Care Staff Management Architecture & Business Logic Spec

- **Author / Active Role**: Planner
- **Target Module(s)**: Backend Spring Boot (`PetShop.demo`), Database SQL Server (`QL_PetShop`), Admin UI (`admin/staff.html`) & Customer Booking Flow
- **Status**: Pending Approval / Ready for Implementation
- **Created Date**: 2026-09-25

---

## 1. Problem Statement & Real Root Need

- **Observed Pain Point / Feature Request**: PetShop cần quản lý đội ngũ Bác sĩ thú y (Veterinarians) và Nhân viên chăm sóc (Care Staff/Groomers). Hệ thống cần hỗ trợ:
  1. Admin quản lý hồ sơ nhân sự (Danh sách, Thêm mới, Sửa chuyên môn/bằng cấp, Đổi vai trò, Khóa/Kích hoạt tài khoản nhân viên).
  2. Phân loại rõ ràng chuyên môn: Bác sĩ thú y (Khám bệnh, Tiêm phòng, Phẫu thuật) vs. Nhân viên Spa/Groomer (Tắm gội, Cắt tỉa lông, Vệ sinh).
  3. Gán Bác sĩ/Nhân viên phụ trách trực tiếp vào từng đơn Đặt lịch dịch vụ (`tblDatLich.MaNV`).
- **Real Problem Statement**: Bảng `tblNhanVien` hiện tại mới có thông tin cơ bản (`MaNV`, `MatKhau`, `TenNV`, `GioiTinh`, `NamSinh`, `VaiTro`), chưa có SĐT, Email, Chuyên môn (Specialization), Ảnh đại diện, và chưa có giao diện Quản lý Nhân sự (Staff Management) đầy đủ trong Admin Portal.
- **Impact & Urgency**: Giúp chủ cửa hàng điều phối nhân sự minh bạch, phân công công việc chính xác cho từng Bác sĩ/Nhân viên, đồng thời nâng cao mức độ tin tưởng của khách hàng khi đặt dịch vụ.

---

## 2. Goals & Non-Goals

### Goals
- [ ] **Mở rộng Schema Database**: Bổ sung các trường `DienThoai`, `Email`, `ChuyenMon`, `AnhDaiDien`, `TrangThai` vào `tblNhanVien`.
- [ ] **Giao diện Quản lý Nhân sự Admin (`/admin/staff`)**:
  - Trang danh sách hiển thị phân loại theo Vai trò (Bác sĩ thú y vs. Nhân viên chăm sóc).
  - Modal/Trang Thêm mới & Cập nhật thông tin nhân viên (Họ tên, SĐT, Email, Vai trò, Chuyên môn).
  - Kích hoạt / Tạm dừng trạng thái làm việc (`Đang làm việc` / `Tạm nghỉ`).
- [ ] **Phân công Nhân viên vào Lịch đặt (`/admin/bookings`)**:
  - Cho phép Admin chọn Bác sĩ/Nhân viên phụ trách (`MaNV`) cho từng lịch hẹn `tblDatLich`.
- [ ] **Hiển thị thông tin Bác sĩ/Nhân viên công khai (Tuỳ chọn trên Web)**: Trang `/Doctors` hoặc Section Đội ngũ Bác sĩ chuyên khoa tại trang Dịch vụ.

### Non-Goals
- [ ] Hệ thống tính lương / hoa hồng tự động theo ca (Sẽ quản lý ở phần mềm kế toán riêng).
- [ ] Chấm công bằng vân tay / khuôn mặt.

---

## 3. Constraints, Invariants & Data Tracing

- **Business Constraints**: 
  - Khách hàng đặt dịch vụ "Khám bệnh / Tiêm phòng" chỉ được phân công cho Bác sĩ thú y (`IDVaiTro` = Bác sĩ).
  - Tách bạch logic phân quyền ở `AuthService` và logic quản lý ở `EmployeeService`.
- **Data Trace & Models**:
  - Bảng `tblVaiTro`: `IDVaiTro` (INT, PK), `TenVaiTro` (NVARCHAR - 'Admin', 'Nhân viên chăm sóc', 'Bác sĩ thú y'), `MoTa` (NVARCHAR).
  - Bảng `tblNhanVien`: `MaNV` (INT, PK), `TenNV` (NVARCHAR), `MatKhau` (NVARCHAR), `GioiTinh` (NVARCHAR), `NamSinh` (INT), `VaiTro` (INT, FK -> tblVaiTro), `DienThoai` (NVARCHAR), `Email` (NVARCHAR), `ChuyenMon` (NVARCHAR), `AnhDaiDien` (NVARCHAR), `TrangThai` (NVARCHAR - 'Đang làm việc', 'Tạm nghỉ').
  - Bảng `tblDatLich`: Bổ sung khóa ngoại `MaNV` (INT, FK -> tblNhanVien, Nullable) để lưu Bác sĩ/Nhân viên được phân công.
- **API / Web Contracts**:
  - `GET /admin/staff`: Trang quản lý danh sách Bác sĩ & Nhân viên.
  - `GET /admin/staff/add`: Form thêm mới nhân sự.
  - `POST /admin/staff/save`: Tiếp nhận thông tin, mã hóa mật khẩu & lưu nhân sự.
  - `POST /admin/staff/updateStatus`: Đổi trạng thái làm việc.
  - `POST /admin/bookings/assignStaff`: Gán Bác sĩ/Nhân viên phụ trách đơn đặt lịch.

---

## 4. Candidate Options & Trade-offs

### Option A (Primary Proposed Approach - Integrated Role & Assignment Management)
- **Description**: Sử dụng bảng `tblNhanVien` mở rộng + liên kết `tblVaiTro`. Admin quản lý tập trung toàn bộ nhân sự tại `/admin/staff` và chọn gán `MaNV` trực tiếp khi duyệt đơn tại `/admin/bookings`.
- **Pros**: Tận dụng tối đa schema hiện tại, kiến trúc gọn nhẹ, linh hoạt mở rộng thêm vai trò mới sau này.
- **Cons & Trade-offs**: Cần cập nhật nhẹ bảng `tblDatLich` để chứa trường `MaNV`.

### Option B (Separate Vet & Care Staff Tables Approach)
- **Description**: Tách riêng thành 2 bảng `tblBacSiThuy` và `tblNhanVienChamSoc`.
- **Why Rejected**: Gây trùng lặp cấu trúc dữ liệu nhân sự, rườm rà trong quản lý tài khoản đăng nhập Admin/Staff.

---

## 5. Critical Flaw Analysis (Self-Adversarial Check)

> **Mandatory Planner Self-Check:**
> 1. **Strongest Objection**: Nếu phân công 1 Bác sĩ trùng 2 ca khám cùng 1 khung giờ sẽ gây quá tải cho Bác sĩ đó.
>    *Giải pháp*: Khi Admin bấm phân công `MaNV` cho ca đặt lịch, `EmployeeService` sẽ đếm số lượng ca mà Bác sĩ/Nhân viên đó đã nhận trong khung giờ đó, nếu > 1 ca sẽ cảnh báo Admin.
> 2. **Hidden Assumptions**: Giả định rằng mật khẩu nhân viên khởi tạo ban đầu có thể đổi được.
>    *Giải pháp*: Cung cấp tính năng "Reset Mật Khẩu" mặc định (ví dụ: `123456`) trong trang Quản lý Admin.
> 3. **Alternative Not Explored**: Cho phép khách hàng tự chọn Bác sĩ yêu thích ngay ở Bước 2 khi đặt lịch trực tuyến.
>    *Giải pháp*: Trong Phase 1, Admin sẽ tự phân công dựa trên lịch làm việc. Phase 2 có thể mở rộng chọn Bác sĩ ở form Đặt lịch nếu có yêu cầu.

---

## 6. Target Layering & Affected Components

| Layer | Component / File | Proposed Responsibility |
| :--- | :--- | :--- |
| **Database** | SQL Server `QL_PetShop.sql` (`tblNhanVien`, `tblDatLich`) | Cập nhật các cột mới cho `tblNhanVien` và bổ sung FK `MaNV` vào `tblDatLich`. |
| **Entity & Repo** | `Employee.java`, `EmployeeRepository.java` | Khai báo các thuộc tính mới & phương thức truy vấn theo Vai trò, Trạng thái. |
| **Business Service** | `EmployeeService.java`, `BookingService.java` | Quản lý CRUD nhân viên, mã hóa mật khẩu, kiểm tra trùng ca làm việc của Bác sĩ. |
| **Controller** | `AdminStaffController.java`, `BookingController.java` | Handling các route `/admin/staff`, `/admin/bookings/assignStaff`. |
| **Frontend UI** | `admin/staff.html`, `admin/staff-form.html`, `admin/bookings.html` | Bảng quản lý nhân sự, form thêm/sửa, dropdown chọn Bác sĩ/Nhân viên phân công. |

---

## 7. Verification & Rollback Strategy

### Verification Plan
- [ ] Chạy script ALTER TABLE bổ sung cột vào `QL_PetShop.sql`.
- [ ] Test tạo mới Bác sĩ thú y & Nhân viên chăm sóc tại `/admin/staff/add`.
- [ ] Test cập nhật chuyên môn & đổi trạng thái làm việc tại `/admin/staff`.
- [ ] Test gán Bác sĩ/Nhân viên phụ trách đơn đặt lịch tại `/admin/bookings`.
- [ ] Chạy Sanity Build: `.\mvnw.cmd compile`.

### Rollback Strategy
- [ ] Revert mã nguồn trên Git.
- [ ] Rollback cột SQL nếu cần.

---

## 8. Open Decisions (If Any)

- [ ] Xác nhận với Khách hàng/User: Có cần hiển thị danh sách Đội ngũ Bác sĩ Thú Y lên giao diện khách hàng (trang Web công khai) không, hay chỉ dùng nội bộ Admin?
