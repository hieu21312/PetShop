# Task Execution Checklist: Registration & Service Booking Flow

- **Associated Spec**: [service_booking_registration_spec.md](file:///a:/PetShop/docs/ai/spec/service_booking_registration_spec.md)
- **Assigned Role**: Implementer / Debugger
- **Status**: Pending Approval / Ready
- **Target Conversation ID**: 5b31e87a-1260-4ebc-9539-109065771194

---

## Task Progress Checklist

- [x] **Phase 1: Environment & Database Schema Readiness**
  - [x] Check DB table `tblDatLich` schema against Java `Booking.java` entity annotations
  - [x] Verify foreign keys, indices, and status string values (`Chờ xác nhận`, `Đã xác nhận`, `Hoàn thành`, `Đã hủy`)
  - [x] Added `tblDatLich` table definition script to `QL_PetShop.sql`

- [x] **Phase 2: Business & Service Layer Implementation (`BookingService.java`, `AuthService.java`)**
  - [x] Enhance `BookingService.java` to validate datetime (prevent past booking)
  - [x] Add auto-linking of `MaKH` based on session or phone/email lookup in `tblKhachHang`
  - [x] Implement slot availability check method in `BookingService.java` (max 3 per slot)
  - [x] Add exception logging and validation error handling

- [x] **Phase 3: API Controller & Entry Point Mapping (`BookingController.java`)**
  - [x] **Bước 1 - Đăng ký / Chọn dịch vụ**: Route `/DichVu` hiển thị danh sách tất cả các dịch vụ thú cưng (Tắm gội, Cắt tỉa lông, Vệ sinh, Khám bệnh, Tiêm phòng...) từ `tblDichVu`.
  - [x] **Bước 2 - Đặt lịch dịch vụ**: Route `/DatLich?maDV={id}` tiếp nhận dịch vụ đã chọn, hiển thị form chọn Ngày + Khung giờ.
  - [x] Route `POST /DatLich`: Tiếp nhận dữ liệu ngày/giờ, validate thời gian, check slot khả dụng và lưu `tblDatLich`.
  - [x] Route `GET /LichSuDatLich`: Tra cứu danh sách lịch đặt của khách hàng theo `MaKH`.
  - [x] Route `POST /DatLich/Huy/{id}`: Cho phép khách hàng hủy lịch hẹn `Chờ xác nhận`.
  - [x] Route `POST /admin/bookings/updateStatus`: Duyệt & cập nhật trạng thái lịch hẹn cho Admin.

- [x] **Phase 4: Frontend Integration & State Sync (ThymeLeaf Templates)**
  - [x] **Step 1 UI (`DichVu.html`)**: Thẻ card hiển thị từng dịch vụ kèm nút "Đặt lịch ngay" truyền `maDV`.
  - [x] **Step 2 UI (`booking-form.html`)**:
    - Selectbox/Radio chọn Khung giờ cố định (08:30, 09:30, 10:30, 14:00, 15:00, 16:00, 17:00, 18:00).
    - Datepicker chọn Ngày hẹn (validate ngắt chọn ngày quá khứ bằng JS min date).
    - Ô thông tin Khách hàng & Ghi chú thông tin Thú cưng (Tên bé, Giống loài, Cân nặng, Lưu ý đặc biệt).
  - [x] **Lịch sử & Admin UI (`my-bookings.html`, `admin/bookings.html`)**: Hiển thị bảng lịch hẹn cá nhân & bảng Admin kèm badge trạng thái.

- [x] **Phase 5: Verification & Zero-Regression Check**
  - [x] Compile Java application (`.\mvnw.cmd compile`)
  - [x] Verify flow end-to-end (Registration -> Service Selection -> Booking -> Customer History -> Admin Confirmation)
  - [x] Confirm zero hardcoded mock data remains
