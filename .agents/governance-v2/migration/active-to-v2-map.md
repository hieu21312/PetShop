# Active Config to Governance V2 Map

Tài liệu này map từ config active hiện tại của repo sang các lớp trong governance v2.

## Legend

- `keep`
  Giữ nguyên về vai trò, chỉ cần tham chiếu lại trong v2.
- `trim`
  Giữ file nhưng rút bớt nội dung để bớt trùng.
- `merge`
  Hợp nhất nội dung sang ít file hơn trong v2.
- `replace`
  Về lâu dài sẽ bị thay thế bởi file v2 tương ứng.
- `delegate`
  File active vẫn tồn tại nhưng nên dẫn chiếu sang source of truth khác thay vì tự lặp rule.

## Source-of-Truth Layers in V2

- `AGENTS.md`
  Chỉ giữ luật cấp hiến pháp, guardrail toàn repo, và workflow order rất ngắn.
- `governance-v2/roles/`
  Ranh giới trách nhiệm và output contract theo role.
- `governance-v2/rules/`
  Workflow, decision matrix, verification/confidence, escalation.
- `governance-v2/templates/`
  Prompt templates và response contracts dùng lại.
- `docs/ai/spec/`
  Artifact task cụ thể, không phải nơi chứa policy dài hạn.

## File-by-File Mapping

| Active file | Current role | V2 target layer | Action | Notes |
| --- | --- | --- | --- | --- |
| `AGENTS.md` | Global constitution + workflow + guardrails | `AGENTS.md` + `governance-v2/rules/*` | `trim` + `delegate` | Giữ luật cấp cao, đẩy workflow chi tiết và confidence/verification xuống v2 rules. |
| `.agents/README.md` | Giải thích vai trò `.agents` | `governance-v2/roles/README.md` | `keep` + `delegate` | Nên giữ bản active ngắn và dẫn chiếu sang role architecture v2 khi ổn định. |
| `.agents/planner.md` | Role plan | `governance-v2/roles/` + `rules/decision-matrix.md` + `templates/response-contracts.md` | `replace` | Nội dung dài hiện tại nên tách thành role boundary, plan contract, decision matrix. |
| `.agents/debugger.md` | Role debug + anti-overclaim | `governance-v2/roles/` + `rules/verification-confidence.md` + `templates/debug-prompt-template.md` | `replace` | Đây là role nên migrate sớm vì đang mang nhiều epistemic guardrails quan trọng. |
| `.agents/implementer.md` | Role implement | `governance-v2/roles/` + `templates/response-contracts.md` | `replace` | Nên giữ local code-safety checklist nhưng tách workflow/policy chung ra rules. |
| `.agents/reviewer.md` | Role review | `governance-v2/roles/` + `templates/response-contracts.md` | `replace` | Nên chuẩn hóa findings-first contract và confidence labels. |
| `.agents/rules/workflow.md` | Workflow chung | `governance-v2/rules/workflow.md` | `replace` | Đây là ứng viên rõ nhất để trở thành source of truth workflow. |
| `.agents/rules/api.md` | Stack/module rule | `governance-v2/rules/` hoặc giữ active | `keep` | Không nên migrate sớm; chỉ đánh giá sau khi xong global governance. |
| `.agents/rules/backend.md` | Stack/module rule | `governance-v2/rules/` hoặc giữ active | `keep` | Giữ nguyên tạm thời. |
| `.agents/rules/database.md` | Stack/module rule | `governance-v2/rules/` hoặc giữ active | `keep` | Giữ nguyên tạm thời. |
| `.agents/rules/frontend.md` | Stack/module rule | `governance-v2/rules/` hoặc giữ active | `keep` | Giữ nguyên tạm thời. |
| `.agents/rules/security.md` | Cross-cutting concern rule | `governance-v2/rules/` | `merge` later | Có thể về sau tách lớp `cross-cutting` nếu v2 trưởng thành hơn. |
| `.agents/rules/testing.md` | Verification rule | `governance-v2/rules/verification-confidence.md` + stack-specific testing rules | `merge` | Nên tách “verification strength” khỏi testing mechanics. |
| `.agents/rules/taste-skill.md` | Style/taste guidance | undecided | `keep` | Chưa thuộc critical governance path; không migrate sớm. |
| `.agents/skills/docs-spec-workflow/SKILL.md` | Skill for persistent planning docs | `governance-v2/rules/workflow.md` + templates | `delegate` | Skill nên bám workflow v2, không tự mang policy riêng dài hạn. |
| `.agents/skills/frontend-testing/SKILL.md` | Specialized execution skill | keep in skills | `keep` | Không phải governance core. |
| `.agents/skills/setup-project-config/SKILL.md` | Project bootstrap skill | keep in skills | `keep` | Không phải governance core. |
| `docs/templates/implementation_plan_template.md` | Plan artifact template | `governance-v2/templates/` or keep shared | `keep` + `delegate` | Chưa cần di chuyển; chỉ cần role contracts dẫn chiếu đúng. |
| `docs/templates/task_template.md` | Task tracking template | `docs/templates/` | `keep` | Đây là shared artifact template, không nhất thiết migrate. |
| `docs/templates/walkthrough_template.md` | Delivery report template | `docs/templates/` | `keep` | Shared artifact, giữ nguyên. |
| `docs/templates/tech-design-template.md` | Technical design template | `docs/templates/` | `keep` | Shared artifact, giữ nguyên. |
| `docs/templates/srs-template.md` | SRS template | `docs/templates/` | `keep` | Shared artifact, giữ nguyên. |
| `docs/templates/debug_prompt_template.md` | Reusable debug prompt | `governance-v2/templates/` | `merge` | Về lâu dài nên còn một source of truth prompt template. |
| `docs/ai/rules/antigravity-hard-task-playbook.md` | Role-selection and task-family playbook | `governance-v2/rules/decision-matrix.md` | `delegate` | Nên giữ file này như user-facing playbook, nhưng source of truth role selection nên về v2 matrix. |
| `docs/ai/rules/architecture-guide.md` | Project context | keep in docs/ai/rules | `keep` | Không phải governance policy core. |
| `docs/ai/rules/business-rules.md` | Domain context | keep in docs/ai/rules | `keep` | Không phải governance policy core. |
| `docs/ai/rules/examples.md` | Examples | keep in docs/ai/rules | `keep` | Không phải governance policy core. |
| `docs/ai/spec/*` | Task memory | `docs/ai/spec/*` | `keep` | Artifact layer, không migrate thành policy layer. |

## Grouped Migration Plan

## Phase 1: Establish governance core

Priority:

1. `AGENTS.md`
2. `.agents/debugger.md`
3. `.agents/planner.md`
4. `.agents/rules/workflow.md`

Reason:

- Đây là nhóm file đang quyết định hành vi mặc định mạnh nhất.
- Đây cũng là nơi dễ có rule trùng và mâu thuẫn nhất.

## Phase 2: Normalize response and verification behavior

Priority:

1. `.agents/implementer.md`
2. `.agents/reviewer.md`
3. `.agents/rules/testing.md`
4. `docs/templates/debug_prompt_template.md`

Reason:

- Sau khi workflow core ổn định, cần chuẩn hóa output contract và verification strength để giảm biến thiên giữa các turn.

## Phase 3: Reconcile skills and playbooks

Priority:

1. `.agents/skills/docs-spec-workflow/SKILL.md`
2. `docs/ai/rules/antigravity-hard-task-playbook.md`

Reason:

- Hai file này không nên tự định nghĩa policy khác với governance core.
- Chúng nên trở thành lớp hướng dẫn và dẫn chiếu.

## Phase 4: Review stack-specific rule modules

Priority:

1. `.agents/rules/api.md`
2. `.agents/rules/backend.md`
3. `.agents/rules/database.md`
4. `.agents/rules/frontend.md`
5. `.agents/rules/security.md`
6. `.agents/rules/taste-skill.md`

Reason:

- Các file này không phải blocker lớn cho governance consistency bằng workflow core.
- Chỉ nên đụng tới sau khi source of truth lớp trên đã ổn.

## Current Recommendations

- Treat `governance-v2/rules/workflow.md` as the delegated source of truth for workflow when referenced by active config.
- Treat `governance-v2/rules/decision-matrix.md` as the delegated source of truth for role selection when referenced by active config.
- Treat `governance-v2/rules/verification-confidence.md` as the delegated source of truth for anti-overclaim and verification strength when referenced by active config.
- Treat `governance-v2/templates/response-contracts.md` as the delegated source of truth for role outputs when referenced by active config.

## Open Questions for Later Migration

- Should stack-specific rule modules eventually stay under active `.agents/rules/` or be folded into `governance-v2/rules/` by concern?
- Should `docs/templates/debug_prompt_template.md` remain a shared docs template, or be replaced by the v2 template copy?
- Should `AGENTS.md` keep a short decision matrix summary, or only delegate to governance core once v2 is adopted?
