# Contributing

Contributions should preserve these project boundaries:

- Do not add secrets, real production databases, or private keys.
- Do not implement custom cryptography.
- Prefer upstream Headscale features over custom forks.
- Keep public docs usable for a clean deployment.
- Keep CYINT-specific private values in examples only as placeholders.

Run validation before opening a pull request:

```bash
python scripts/validate_repo.py
```
