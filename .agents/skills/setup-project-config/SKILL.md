---
name: setup-project-config
description: Automate baseline agent configuration when starting on a new project. Use this when the agent first runs in a new codebase to initialize AGENTS.md.
---

# Setup Project Config Skill

This skill automates the configuration setup when copying the `config-anti` baseline files to a new repository.
This skill is specialized bootstrap support, not the primary source of repo-critical policy. Final always-on rules must live in `AGENTS.md` and the relevant role files.

## When to use this skill
- Use this IMMEDIATELY upon starting work on a new repository that contains a copied `AGENTS.md` and `.agents/` structure.
- Do not use this if the repository's `AGENTS.md` is already customized with real project commands and metadata.

## Procedure

### 1. Auto-Detect Tech Stack & Environment
Scan the root directory of the new project to detect configuration files:
- **Node.js/Frontend**: Look for `package.json`, `vite.config.ts`, `tsconfig.json`.
- **Python**: Look for `requirements.txt`, `pyproject.toml`, `setup.py`, `environment.yml`.
- **Go**: Look for `go.mod`.
- **C# / .NET**: Look for `.sln` or `.csproj` files.
- **PHP**: Look for `composer.json`.
- **Docker**: Look for `Dockerfile` or `docker-compose.yml`.

### 2. Auto-Detect Project Commands
Read the project configuration files (e.g. `package.json` scripts) to identify shell commands for:
- `install`
- `dev`
- `lint`
- `test`
- `build`

### 3. Update AGENTS.md
Modify the copied `AGENTS.md` file in the target repository:
- **Repo Commands (Section 6)**: Fill in the placeholders with the detected commands (e.g., replace `# dev: none` with `npm run dev`).
- **Project Context (Section 7)**: Update `Product name`, `Tech Stack`, and `Architecture` entry points with the detected findings.

### 4. Create Directory Skeleton
Verify and create the following directories if they do not exist:
- `docs/ai/rules/` (for long-term business and architecture rules)
- `docs/ai/spec/` (for task specifications and acceptance criteria)

### 5. Confirm with User
Present a summary of the auto-detected configuration changes to the user for confirmation and final verification.
