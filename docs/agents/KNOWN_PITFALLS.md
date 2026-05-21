# Known Pitfalls

## Anti-Patterns to Avoid

| Pitfall | Why It's Wrong | Correct Approach |
|---------|---------------|------------------|
| Silent catch blocks | Hides bugs, makes debugging impossible | Log with context or re-throw typed errors |
| God functions (>100 lines) | Unreadable, untestable, impossible to reason about | Split into focused functions (≤50 lines) |
| Magic strings/numbers | Brittle, refactoring-proof, no discoverability | Named constants or enums |
| Deeply nested conditionals | Impossible to follow, mutation hiding | Early returns, guard clauses, pattern matching |
| Premature abstraction | Wrong boundaries, hard to change later | Three-strikes rule: abstract on third repetition |
| Mixed concerns in one module | Violates SRP, hard to test in isolation | One responsibility per module |
| Type casting / `any` | Bypasses type safety, runtime surprises | Proper typing or branded types |
| Guesswork over reading | LLMs invent plausible-sounding APIs | Check actual source code with grep/read |

## Golden Rules
- If you're about to write a comment explaining WHAT the code does, refactor instead
- If you're copying code from another file, extract a shared function
- If you don't know exactly what a function returns, READ the function
- If a test requires mocking 5+ dependencies, the design is wrong
