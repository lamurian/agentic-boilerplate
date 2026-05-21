# Architecture

## Tech Stack

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Runtime | [...] | [...] |
| Language | [...] | [...] |
| Framework | [...] | [...] |
| Database | [...] | [...] |
| Testing | [...] | [...] |
| CI/CD | [...] | [...] |

## Data Flow
<!-- Describe the request/response lifecycle through the system -->

```
[Client] → [API Gateway] → [Service] → [Database]
                                    ↘ [Queue] → [Worker]
```

## Key Patterns
<!-- Document the project's recurring design patterns -->

- **Pattern 1**: Description and where it applies
- **Pattern 2**: Description and where it applies

## Architecture Decisions
<!-- Index of ADRs — add new entries as @docs/ADR/NNN-title.md -->

- @docs/ADR/0000-template.md: Template for creating new ADRs
