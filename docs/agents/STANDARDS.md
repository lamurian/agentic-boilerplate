# Standards

## Naming Conventions
| Entity | Convention | Example |
|--------|-----------|---------|
| Files | kebab-case | `user-service.ts` |
| Variables / functions | camelCase | `getUser`, `isActive` |
| Classes / components | PascalCase | `UserProfile` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Types / interfaces | PascalCase | `UserPayload` |
| Enums | PascalCase, singular | `UserRole` |

## File Organization
- One primary export per file — name matches the file
- Tests co-located: `foo.ts` → `foo.test.ts` (or `foo.spec.ts`)
- Group by domain, not by type — feature folders, not `utils/` or `helpers/`
- Maximum 300 lines per file — split when exceeded

## Error Handling
- Use explicit error types — no bare `throw new Error('msg')`
- Handle errors at domain boundaries (API, I/O, external calls)
- Log structured data, not `console.log` — use the project logger
- Return union types in pure functions: `Result<T, E>` pattern

## Testing
- Write tests before or alongside code — test behavior not internals
- Cover: happy path, error cases, edge cases
- Name tests as statements: `returns 404 when user not found`
- No test logic that duplicates implementation logic

## Async Patterns
- `async/await` over raw promises — no `.then()` chains
- Parallel independent calls via `Promise.all`, not sequential await
- Never fire-and-forget — always handle rejection

## Imports Order
1. Standard library / runtime
2. Third-party packages
3. Internal modules (absolute paths preferred)
4. Relative imports (one level deep max)
Blank line between groups.

## Documentation
- Public API: doc comment explaining WHY not what
- Internal code: self-documenting names over comments
- Update comments when code changes — stale comments are worse than none
