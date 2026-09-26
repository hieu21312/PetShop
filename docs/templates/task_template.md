# Task Execution Checklist: [Feature / Task Name]

- **Associated Spec**: [Link to spec file under `docs/ai/spec/`]
- **Assigned Role**: Implementer / Debugger
- **Status**: In Progress / Verification Pending / Completed
- **Target Conversation ID**: [Conversation ID]

---

## Task Progress Checklist

- [ ] **Phase 1: Environment & Database Schema Readiness**
  - [ ] Check DB table columns against C# Entity annotations
  - [ ] Verify foreign keys, indices, and constraints

- [ ] **Phase 2: Business & Service Layer Implementation**
  - [ ] Implement core logic in Service layer (strictly no logic in Controllers)
  - [ ] Add exception context logging and null checks

- [ ] **Phase 3: API Controller & Entry Point Mapping**
  - [ ] Map request DTOs to business parameters
  - [ ] Ensure proper HTTP status codes & standard response envelope

- [ ] **Phase 4: Frontend Integration & State Sync**
  - [ ] Connect API endpoints to Flutter/React service layer
  - [ ] Handle loading states, timeouts, and error handling

- [ ] **Phase 5: Verification & Zero-Regression Check**
  - [ ] Run backend tests (`dotnet test`)
  - [ ] Run frontend lint & build sanity checks
  - [ ] Confirm zero hardcoded mock data remains
