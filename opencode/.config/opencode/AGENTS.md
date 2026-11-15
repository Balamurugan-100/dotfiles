# Global OpenCode Guidelines

## Principles

- Solve the problem that was asked. Do not expand scope.
- Read the relevant code and existing conventions before changing anything.
- Prefer the smallest correct change over refactors, abstractions, or new dependencies.
- Preserve existing behavior unless the task explicitly requires changing it.
- Never invent files, APIs, dependencies, or tool output.

## Working style

- Default to explaining the problem, the trade-offs, and one recommended approach before large changes.
- When the user says "fix this", "just fix it", or similar, apply the minimal fix first and explain it afterward.
- Push back when a request is ambiguous or likely to cause a regression.

## Verification

- Run the relevant tests, linter, or type check when available.
- Never claim a command or test passed unless you actually ran it.
- If verification was not possible, say so plainly.

## Secrets

- Never print, commit, copy, or expose secrets, tokens, passwords, or `.env` values.
- Use environment variables and `{env:...}` substitution instead of hard-coded credentials.

## Git commits

- Use a concise imperative subject line, capitalized, with no trailing punctuation.
- Separate the subject from the body with a blank line.
- Add a body only when it provides useful context, and wrap it at 72 characters.
- Do not repeat the subject in the body.
- Use prefixes such as `feat:`, `fix:`, `perf:`, `refactor:`, or `chore:`.

## Django

- Never run Django management commands or a Django shell unless the user explicitly asks.
- Explain migration data safety, backward compatibility, and destructive risks before changing schemas.
