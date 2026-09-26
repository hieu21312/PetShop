# Task Execution Checklist: Staff & Vet Service Dispatch & Assignment

- **Associated Spec**: [staff_assignment_dispatch_spec.md](file:///a:/PetShop/docs/ai/spec/staff_assignment_dispatch_spec.md)
- **Assigned Role**: Implementer / Debugger
- **Status**: Pending Approval / Ready
- **Target Conversation ID**: 5b31e87a-1260-4ebc-9539-109065771194

---

## Task Progress Checklist

- [ ] **Phase 1: Service Layer & Availability Conflict Validation**
  - [ ] Add `countByMaNVAndNgayDatAndGioDatAndTrangThaiNot` method to `BookingRepository.java`
  - [ ] Implement `isStaffAvailable(maNV, date, time)` in `BookingService.java`
  - [ ] Implement smart filtering method `getSuitableStaffForService(maDV)` in `EmployeeService.java`

- [ ] **Phase 2: Controller & Routing Enhancement (`BookingController.java`, `StaffTaskController.java`)**
  - [ ] Enhance `POST /admin/bookings/assignStaff` in `BookingController.java` with conflict checks
  - [ ] Create `StaffTaskController.java` with GET `/staff/my-tasks` and POST `/staff/my-tasks/updateProgress`

- [ ] **Phase 3: Admin Booking UI Enhancement (`admin/bookings.html`)**
  - [ ] Update `admin/bookings.html` to group/filter dropdown choices into Bác sĩ Thú y vs Nhân viên Spa
  - [ ] Display warning badge on UI when a staff member has existing tasks in the same time slot

- [ ] **Phase 4: Staff Task Portal UI (`staff/my-tasks.html`)**
  - [ ] Create `staff/my-tasks.html` for Vets & Care Staff to view assigned daily appointments
  - [ ] Add progress update form (`Đang thực hiện`, `Hoàn thành`) & Medical/Service notes text area

- [ ] **Phase 5: Verification & Zero-Regression Check**
  - [ ] Compile Java application (`.\mvnw.cmd compile`)
  - [ ] Verify end-to-end flow: Service Booking -> Admin Smart Assignment -> Staff Portal Progress Sync
  - [ ] Confirm zero hardcoded mock data remains
