# Task Execution Checklist: Quản Lý Nhân Sự 2 Cấp Menu

- **Associated Spec**: [`staff_2level_menu_spec.md`](file:///a:/PetShop/docs/ai/spec/staff_2level_menu_spec.md)
- **Assigned Role**: Planner / Implementer
- **Status**: In Progress
- **Target Conversation ID**: `5b31e87a-1260-4ebc-9539-109065771194`

---

## Task Progress Checklist

- [ ] **Phase 1: Architecture & Controller Layer Filtering**
  - [ ] Add `roleFilter` parameter to `AdminStaffController.java`
  - [ ] Implement filtered queries in `EmployeeService.java`

- [ ] **Phase 2: Admin Sidebar 2-Level Menu Refactoring**
  - [ ] Update `admin-sidebar.html` with collapsible 2-level menu for Staff Management
  - [ ] Style submenu items with distinct icons (🩺 Vet, ✂️ Care, 👥 All)

- [ ] **Phase 3: Staff Management View Enhancement**
  - [ ] Update `admin/staff.html` with active filter tabs
  - [ ] Ensure full alignment with PetShop design system (`table-pink`, `text-gradient`)

- [ ] **Phase 4: Verification & Build Check**
  - [ ] Execute `.\mvnw.cmd compile` to confirm 0 compilation errors
  - [ ] Run workflow validator `scripts/validate-agent-workflow.ps1`
