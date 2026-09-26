# Governance V2 Workspace

## Mục đích

- Chuẩn hóa workflow, decision matrix, verification/confidence, và response contracts theo một kiến trúc rõ tầng hơn.
- Làm source of truth được kích hoạt bằng delegation từ `AGENTS.md`, role files, hoặc `.agents/rules/*`.
- Giữ phần migration/history riêng để quá trình thay đổi governance vẫn audit được.

## Trạng thái hiện tại

- Các file dưới `rules/` và `templates/` là active-by-delegation khi được `AGENTS.md`, role files, hoặc `.agents/rules/*` dẫn chiếu.
- Các file dưới `migration/` là lịch sử/ghi chú migration, không phải runtime policy trừ khi một active file dẫn chiếu trực tiếp.
- Các file dưới `roles/` vẫn là proposal layer cho role contracts thế hệ sau, trừ khi được adopt rõ ràng.

## Hướng cấu trúc đề xuất

- `README.md`
  Mô tả mục tiêu, nguyên tắc, và phạm vi của governance v2.
- `roles/`
  Chứa version mới của `debugger`, `planner`, `implementer`, `reviewer`.
- `rules/`
  Chứa workflow chung, verification rules, confidence rules, escalation rules.
- `templates/`
  Chứa output contracts và reusable prompt templates.
- `migration/`
  Ghi lại mapping giữa config hiện tại và config v2 khi bắt đầu migrate.

## Nguyên tắc sử dụng

- Không đặt policy quan trọng chỉ trong migration notes.
- Mỗi thay đổi lớn nên đi kèm spec hoặc note ngắn để giữ được project memory.
- Khi một rule v2 đã được active files delegate tới, giữ wording của active files và v2 nhất quán để tránh source-of-truth drift.
