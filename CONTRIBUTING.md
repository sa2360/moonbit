# Contributing

Thanks for helping improve `moonbench`.

## Development

Run these commands before opening a change:

```bash
moon check
moon test
moon run cmd/main
```

Keep public APIs small and documented. New behavior should include tests in `moonbench_test.mbt` and a short README or docs update when it changes user-facing usage.

## Commit Style

Prefer focused commits that describe one useful change:

- add a public helper
- cover an edge case
- improve docs
- adjust CI or release metadata

Avoid generated files such as `_build/`.
