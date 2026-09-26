# Task Execution Checklist: Veterinarian & Care Staff Management

- **Associated Spec**: [staff_vet_management_spec.md](file:///a:/PetShop/docs/ai/spec/staff_vet_management_spec.md)
- **Assigned Role**: Implementer / Debugger
- **Status**: Pending Approval / Ready
- **Target Conversation ID**: 5b31e87a-1260-4ebc-9539-109065771194

---

## Task Progress Checklist

- [x] **Phase 1: Database Schema & Entity Expansion**
  - [x] Add columns `DienThoai`, `Email`, `ChuyenMon`, `AnhDaiDien`, `TrangThai` to `tblNhanVien` in `QL_PetShop.sql`
  - [x] Add nullable column `MaNV` (FK -> tblNhanVien) to `tblDatLich` in `QL_PetShop.sql`
  - [x] Update Java `Employee.java` and `Booking.java` entities with new properties

- [x] **Phase 2: Business & Service Layer Implementation (`EmployeeService.java`)**
  - [x] Create/Enhance `EmployeeService.java` for CRUD operations on Staff & Veterinarians
  - [x] Implement query methods for filtering by Role (`Bác sĩ thú y` vs `Nhân viên chăm sóc`) and Active status
  - [x] Implement password reset and status toggle (`Đang làm việc` / `Tạm nghỉ`)
  - [x] Implement staff workload check and active employee filtering

- [x] **Phase 3: Controller Layer & Routing (`AdminStaffController.java`, `BookingController.java`)**
  - [x] Create `AdminStaffController.java` with GET `/admin/staff`, GET `/admin/staff/add`, POST `/admin/staff/save`, POST `/admin/staff/toggleStatus`, POST `/admin/staff/resetPassword`
  - [x] Enhance `BookingController.java` with POST `/admin/bookings/assignStaff`

- [x] **Phase 4: Admin UI Integration (ThymeLeaf Templates)**
  - [x] Create `admin/staff.html` for listing staff & vets with role badges and action buttons
  - [x] Create `admin/staff-form.html` for adding/editing staff profile, role, and specialization
  - [x] Update `admin/bookings.html` to include staff assignment dropdown for each booking
  - [x] Update `admin/admin-sidebar.html` navigation link

- [x] **Phase 5: Verification & Zero-Regression Check**
  - [x] Compile Java application (`.\mvnw.cmd compile`)
  - [x] Verify complete CRUD flow for Vets & Staff in Admin Portal
  - [x] Confirm assignment of Staff/Vet to Bookings works cleanly with zero mock data
