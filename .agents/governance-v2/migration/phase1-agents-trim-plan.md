# Implementation Plan - Phase 1 AGENTS.md v2-ready trim

Chuẩn bị bản kế hoạch cho bước rút gọn `AGENTS.md` theo migration map của governance v2. Mục tiêu là giữ `AGENTS.md` ở vai trò hiến pháp ngắn của repo, trong khi chuyển workflow, decision matrix, verification/confidence, và role-output detail sang các lớp source of truth trong `governance-v2/`.

## User Review Required

> [!IMPORTANT]
> Bước này chưa sửa `AGENTS.md` thật. Đây là plan để kiểm soát một thay đổi governance có thể ảnh hưởng hành vi mặc định của agent. Cần xem kỹ ranh giới giữa "giữ guardrail" và "giảm lặp rule" trước khi áp dụng lên config active.

## Goals & Non-Goals

### Goals
- [ ] Rút `AGENTS.md` về đúng vai trò luật cấp cao, workflow order rất ngắn, và mission/context cốt lõi của repo.
- [ ] Chỉ rõ các rule nên tiếp tục sống ở `AGENTS.md` vì là guardrail hiến pháp toàn repo.
- [ ] Chỉ rõ các rule nên được delegate sang:
  - `governance-v2/rules/workflow.md`
  - `governance-v2/rules/decision-matrix.md`
  - `governance-v2/rules/verification-confidence.md`
  - `governance-v2/templates/response-contracts.md`
- [ ] Giảm trùng lặp giữa `AGENTS.md` và role/rule files mà không làm mất behavior quan trọng.

### Non-Goals
- [ ] Chưa sửa nội dung active của `.agents/debugger.md`, `.agents/planner.md`, `.agents/implementer.md`, `.agents/reviewer.md`.
- [ ] Chưa xóa hoặc hợp nhất file cũ.
- [ ] Chưa đổi stack-specific rule modules trong `.agents/rules/`.

## Proposed Changes

### [PLAN] Xác định phần giữ lại trong `AGENTS.md`

#### [KEEP] Mission, project context, commands, and top-level principles
- Giữ lại:
  - Mission
  - Repo commands
  - Project context
  - File/folder conventions
  - Các guardrail thật sự cấp hiến pháp như:
    - không bịa facts
    - không refactor unrelated files
    - ưu tiên patch nhỏ, reversible
    - approval-ready / domain-decision discipline ở mức ngắn

#### [KEEP] Workflow order ở mức rất ngắn
- Giữ một version rút gọn của workflow order:
  1. chọn đúng role
  2. tạo artifact khi task non-trivial hoặc project-memory-worthy
  3. đọc context liên quan
  4. implement/verify
- Không để `AGENTS.md` chứa lại checklist debug/planning dài.

### [PLAN] Xác định phần cần delegate khỏi `AGENTS.md`

#### [DELEGATE] Workflow mechanics
- Chuyển source of truth chi tiết về:
  - `.agents/governance-v2/rules/workflow.md`
- `AGENTS.md` chỉ nên dẫn chiếu ngắn thay vì tự lặp toàn bộ workflow detail.

#### [DELEGATE] Role selection and artifact selection
- Chuyển source of truth chi tiết về:
  - `.agents/governance-v2/rules/decision-matrix.md`
- `AGENTS.md` chỉ nên nói rằng role selection và artifact level phải theo governance core.

#### [DELEGATE] Verification strength and confidence rules
- Chuyển source of truth chi tiết về:
  - `.agents/governance-v2/rules/verification-confidence.md`
- `AGENTS.md` chỉ nên giữ 1-2 rule hiến pháp kiểu `No Hypothesis As Fact`, còn phần `Confirmed/Likely/Unverified`, `Missing Proof / Next Check`, `mitigation transparency` để ở v2 rules.

#### [DELEGATE] Output contracts
- Chuyển source of truth chi tiết về:
  - `.agents/governance-v2/templates/response-contracts.md`
- `AGENTS.md` không nên mô tả output contract dài cho từng role.

### [PLAN] Xác định phần cần trim chứ không remove hẳn

#### [TRIM] Guardrail debug/phân tích ở `AGENTS.md`
- Giữ bản ngắn các rule có tính hiến pháp:
  - Analysis-First
  - No Hypothesis As Fact
  - Debugging Claim Discipline
  - Anchoring Prevention
- Bỏ các đoạn checklist vận hành chi tiết nếu governance v2 đã có file chuyên trách.

#### [TRIM] Approval/escalation policy
- Giữ rule ở mức ngắn:
  - chỉ escalate domain / user-visible / financial / security / risk decisions
- Đẩy decision matrix chi tiết và examples xuống governance v2.

## Alternative Designs & Trade-offs

- **Phương án A: Giữ `AGENTS.md` dài như hiện tại, chỉ thêm link sang governance v2**
  - Ưu điểm: ít risk ngắn hạn, ít thay đổi active behavior
  - Nhược điểm: tiếp tục trùng lặp, khó duy trì, governance v2 khó trở thành source of truth thật

- **Phương án B: Trim `AGENTS.md` vừa phải, delegate từng lớp sang governance v2**
  - Ưu điểm: rõ tầng, dễ maintain, dễ migrate dần, ít risk hơn full rewrite
  - Nhược điểm: cần kỷ luật wording để không làm mất các rule đang có hiệu lực mạnh

- **Phương án C: Rewrite `AGENTS.md` mạnh tay ngay trong một bước**
  - Ưu điểm: sạch và nhanh đạt trạng thái mục tiêu
  - Nhược điểm: risk cao, dễ làm lệch behavior active, khó rollback tinh gọn

**Khuyến nghị:** Chọn phương án B.

## Cross-Cutting Concerns

- **Security & Privacy**
  - Không tác động trực tiếp tới bảo mật ứng dụng, nhưng có thể ảnh hưởng cách agent xử lý các task security-sensitive nếu migration làm mờ guardrail.
  - Vì vậy các rule như `do not invent facts`, `approval-ready`, `domain/security escalation` nên vẫn phải còn visible ở `AGENTS.md`.

- **Performance & Scalability**
  - Tác động tích cực tới token cost và maintainability vì bớt lặp rule giữa nhiều file.
  - Tác động tiêu cực nếu trim quá tay khiến agent phải đọc thêm nhiều file cho cả task nhỏ.

- **Backward Compatibility**
  - `AGENTS.md` vẫn phải đủ dùng cho agent chỉ đọc file này trước tiên.
  - Không được biến governance v2 thành dependency bắt buộc cho mọi task nhỏ ngay lập tức.

- **Correctness Invariants**
  - `AGENTS.md` sau khi trim vẫn phải giữ được:
    - phân biệt trivial vs non-trivial
    - artifact discipline ở mức ngắn
    - anti-overclaim ở mức hiến pháp
    - no unrelated refactors / no invented facts
  - Nếu một trong các invariant này mất khỏi `AGENTS.md`, behavior active có thể drift trước khi các role file được migrate.

## Verification & Rollback Plan

### Manual Verification
- So sánh `AGENTS.md` hiện tại với migration map để đánh dấu:
  - rule nào là hiến pháp thật
  - rule nào chỉ là workflow detail
  - rule nào đang trùng với role/rules khác
- Khi sửa thật ở bước sau, đọc lại `AGENTS.md` sau-trim để đảm bảo:
  - ngắn hơn đáng kể
  - nhưng vẫn đủ định hướng cho agent chưa đọc file khác

### Regression Checks
- Sau khi áp dụng trim thật, kiểm tra bằng readback xem:
  - task nhỏ vẫn hiểu internal planning là đủ
  - task non-trivial vẫn hiểu phải có artifact
  - debug vẫn không bị nới quá tay thành đoán mò

### Rollback Plan
- Nếu trim làm mất một guardrail quan trọng, rollback bằng cách:
  1. khôi phục wording cũ của section tương ứng trong `AGENTS.md`
  2. giữ governance v2 như workspace thiết kế
  3. chỉ migrate tiếp sau khi source-of-truth boundaries được làm rõ hơn

## Approval Readiness Summary

Plan này sẵn sàng cho bước sửa thật của `AGENTS.md` vì:

- đã có migration map làm source of truth
- đã chốt phương án B là phương án ít rủi ro nhất
- đã tách rõ phần keep / trim / delegate
- chưa có open decision mang tính domain; đây là thay đổi governance kỹ thuật nội bộ

Nếu triển khai bước tiếp theo, file active cần sửa đầu tiên sẽ là:

- `AGENTS.md`

sau đó mới tới:

- `.agents/debugger.md`
- `.agents/planner.md`
- `.agents/rules/workflow.md`
