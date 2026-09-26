# [Feature Name] Architecture & Business Logic Spec

- **Author / Active Role**: Planner
- **Target Module(s)**: [e.g., Backend NMQ.API / Services / Customer App / Admin]
- **Status**: Draft / Pending Approval / Approved
- **Created Date**: [YYYY-MM-DD]

---

## 1. Problem Statement & Real Root Need

- **Observed Pain Point / Feature Request**: [State what is actually wrong, missing, or being requested]
- **Real Problem Statement**: [Define the exact technical/business problem to solve]
- **Impact & Urgency**: [Explain why this is necessary and what value it delivers]

---

## 2. Goals & Non-Goals

### Goals
- [ ] [Explicit goal 1]
- [ ] [Explicit goal 2]

### Non-Goals
- [ ] [Out-of-scope item 1 - preventing scope creep]
- [ ] [Out-of-scope item 2]

---

## 3. Constraints, Invariants & Data Tracing

- **Business Constraints**: [e.g., Strict SQL Server only, no hardcoded mock data]
- **Data Trace & Models**: [Exact DB tables, column types, C# Entity properties verified via view_file]
- **API Contracts**: [Endpoints, HTTP Methods, DTO structures]

---

## 4. Candidate Options & Trade-offs

### Option A (Primary Proposed Approach)
- **Description**: [Detailed description of the primary approach]
- **Pros**: [Key benefits]
- **Cons & Trade-offs**: [Performance, complexity, or maintainability trade-offs]

### Option B (Alternative / Rejected Approach)
- **Description**: [Alternative considered]
- **Why Rejected**: [Specific reason why Option A is preferred now]

---

## 5. Critical Flaw Analysis (Self-Adversarial Check)

> **Mandatory Planner Self-Check:**
> 1. **Strongest Objection**: What is the single best argument against this design? How might it fail in production?
> 2. **Hidden Assumptions**: What assumptions does this plan rely on that have NOT been verified from code/DB?
> 3. **Alternative Not Explored**: Is there a simpler or safer approach dismissed too quickly?

---

## 6. Target Layering & Affected Components

| Layer | Component / File | Proposed Responsibility |
| :--- | :--- | :--- |
| **Database** | SQL Server / EF Core Context | [Table schema / query / migration] |
| **Business Service** | NMQ.Services / Domain Helpers | [Core business rules & calculations] |
| **API Entry Point** | NMQ.API Controllers | [Request validation & response mapping] |
| **Frontend** | Flutter Customer App / Admin | [UI state management & API integration] |

---

## 7. Verification & Rollback Strategy

### Verification Plan
- [ ] Unit / Integration Tests: `dotnet test`
- [ ] API Endpoint Testing: Swagger / Postman curl
- [ ] Frontend UI / Flow Verification

### Rollback Strategy
- [ ] Git commit revert / DB migration rollback steps

---

## 8. Open Decisions (If Any)

- [ ] [Unresolved decision requiring user confirmation, if applicable]
