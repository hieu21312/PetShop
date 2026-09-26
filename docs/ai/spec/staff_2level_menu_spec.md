# Technical Spec: Quản Lý Nhân Sự Chung & Menu 2 Cấp Phân Loại Bác Sĩ / Staff

- **Status**: Proposed
- **Author**: AI Agent (Planner)
- **Target Module**: `Sumix/PetShop Admin System` (`AdminStaffController`, `admin-sidebar.html`, `admin/staff.html`)

---

## 1. Context & Business Goal

Hệ thống PetShop yêu cầu quản lý thông tin Bác sĩ thú y và Nhân viên chăm sóc trên một cơ sở dữ liệu chung (`tblNhanVien`), đồng thời hiển thị điều hướng dạng **Menu 2 Cấp** trong trang Quản trị Admin để người dùng có thể mở nhanh danh sách theo từng nhóm chức danh:
- **Menu Cấp 1 (Menu Cha)**: `👨‍⚕️ Quản lý Nhân sự`
- **Menu Cấp 2 (Menu Con)**:
  1. 🩺 **Danh sách Bác sĩ thú y** (`/admin/staff?role=vet`)
  2. ✂️ **Danh sách Nhân viên Spa / Chăm sóc** (`/admin/staff?role=care`)
  3. 👥 **Tất cả Nhân sự** (`/admin/staff`)

---

## 2. Technical Architecture & Changes

### 2.1 Backend (`AdminStaffController.java`)
- Thêm tham số `@RequestParam(required = false) String roleFilter` vào endpoint `GET /admin/staff`:
  - `roleFilter = "vet"`: Lọc danh sách nhân viên có `role.tenVaiTro == 'Bác sĩ thú y'`.
  - `roleFilter = "care"`: Lọc danh sách nhân viên có `role.tenVaiTro != 'Bác sĩ thú y'` (Kỹ thuật viên / Staff Spa).
  - Trống / `"all"`: Hiển thị toàn bộ danh sách.

### 2.2 Navigation UI (`admin-sidebar.html`)
- Thay thế thẻ link đơn bằng cấu trúc Menu 2 cấp (Accordion / Submenu Bootstrap):
  ```html
  <div class="admin-menu-group">
      <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" 
         data-bs-toggle="collapse" href="#staffSubmenu">
          <span><i class="fas fa-user-md me-2"></i> Quản lý Nhân sự</span>
          <i class="fas fa-chevron-down small"></i>
      </a>
      <div class="collapse ps-3" id="staffSubmenu">
          <a th:href="@{/admin/staff?roleFilter=vet}" class="list-group-item list-group-item-action border-0 py-2">🩺 Bác sĩ thú y</a>
          <a th:href="@{/admin/staff?roleFilter=care}" class="list-group-item list-group-item-action border-0 py-2">✂️ Nhân viên Spa / Care</a>
          <a th:href="@{/admin/staff}" class="list-group-item list-group-item-action border-0 py-2">👥 Tất cả Nhân sự</a>
      </div>
  </div>
  ```

### 2.3 View Enhancement (`admin/staff.html`)
- Bổ sung bộ lọc Tab chuyển đổi nhanh ở phía trên bảng dữ liệu để Admin lọc trực tiếp danh sách theo 3 tab (Tất cả, Bác sĩ thú y, Staff Spa).

---

## 3. Execution Checklist

- [ ] Update `AdminStaffController.java` to support `roleFilter` parameter
- [ ] Refactor `admin-sidebar.html` with 2-level collapsible dropdown menu
- [ ] Add Tab Filter Navigation in `admin/staff.html`
- [ ] Verify Maven compilation with `.\mvnw.cmd compile`
