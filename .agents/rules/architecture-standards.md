# Architecture Standards & Clean Code Guardrails

Use this file to enforce strict architectural patterns for any AI Agent writing or modifying code in this repository.

## 1. Core Architectural Principle: N-Tier / Clean Architecture

This repository strictly separates concerns into different layers. **Do NOT mix responsibilities.**

- **Controllers (API Layer):** 
  - ONLY responsible for HTTP routing, request parsing, input validation (DTOs), and returning HTTP responses.
  - **HARD RULE:** NO Business Logic or direct database queries (Entity Framework/Dapper) are allowed inside Controllers.
- **Business Services (BS Layer):**
  - Responsible for ALL business logic, algorithms, and domain rules.
  - Controllers must delegate work to Business Services.
- **Repositories (Data Access Layer):**
  - Responsible for raw database interactions.
  - **HARD RULE:** You MUST use `Dapper` (e.g. `conn.QueryAsync<T>`, `conn.ExecuteAsync`) for all SQL operations. Do NOT use raw ADO.NET (`SqlCommand`, `AddWithValue`, `SqlDataReader`) unless absolutely required for a specific edge case. This keeps the code clean and concise.

## 2. The "Refactor First" Mandate

**CRITICAL INSTRUCTION TO AI AGENT:**
If you are asked to "add a feature", "fix a bug", or "modify logic" in an existing Controller that is currently violating the Clean Architecture rule (e.g., a Fat Controller containing heavy logic), you MUST:

1. **STOP** and refuse to append more bad code into the Controller.
2. **EXTRACT** the existing logic from the Controller into the appropriate Business Service (BS) file.
3. **INJECT** the new feature/logic into the Business Service, not the Controller.
4. **CLEAN** the Controller so it only calls the Business Service.

*Do not follow the "Locality Principle" if the local code is architectural garbage. Be a Software Architect.*

## 3. Frontend Principles

- **Separation of Logic:** Keep complex React state and API calls inside Custom Hooks (e.g., `hooks/api/...`), not directly inside UI components.
- **Styling:** Use the predefined design system/theme variables instead of hardcoded hex colors or inline styles.

## 4. Code Quality Baseline

- **No Duplication:** Do not copy-paste large chunks of logic. Extract to utility methods.
- **Type Safety:** Always use strongly typed models/interfaces. Avoid `any` in TypeScript or `dynamic`/`object` in C# unless strictly necessary.

[RULE_TOKEN: ARC-92B1]
