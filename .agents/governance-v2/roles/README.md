# Roles in Governance V2

Mục tiêu của thư mục này là định nghĩa lại ranh giới trách nhiệm cho từng role sao cho:

- ít chồng chéo hơn
- ít mâu thuẫn hơn
- output ổn định hơn
- dễ kiểm tra hơn

## Vai trò dự kiến

- `debugger`
  Dùng cho bug có root cause chưa rõ, output phải ưu tiên evidence, hypothesis, missing proof, next check.
- `planner`
  Dùng cho task non-trivial, nhiều module, workflow/business semantics, hoặc cần approval-ready plan.
- `implementer`
  Dùng khi scope đã rõ và đã có direction đủ mạnh để code.
- `reviewer`
  Dùng để tìm blocker, regression risk, missing verification, hoặc semantic drift.

## Ranh giới trách nhiệm

- `debugger` không được ngầm chuyển sang implementer chỉ vì nghi phạm trông hợp lý.
- `planner` không được biến thành spec writer thuần túy; phải quyết định design, trade-off, verification.
- `implementer` không được tự mở rộng scope khi plan còn hở.
- `reviewer` không được viết lại plan hay fix hộ trừ khi được yêu cầu rõ.

## Output contract cấp cao

- `debugger`
  Reproduction, Evidence, Hypotheses, Best-Supported Cause, Missing Proof, Next Check, Fix/Verification Plan.
- `planner`
  Goals/Non-Goals, Affected Areas, Alternatives, Risks, Verification, Rollback, Open Decisions nếu cần.
- `implementer`
  What Changed, Validation Run, Remaining Risk.
- `reviewer`
  Findings First, Open Questions/Assumptions, Summary Second.

## Ghi chú

Tài liệu này là source of truth ở mức role boundary. Chi tiết workflow và decision matrix nằm trong `../rules/`.
