# Release Checklist

Use this checklist before publishing or submitting `moonbench` for OSC2026 review.

## Local Verification

- `moon check`
- `moon test`
- `moon run cmd/main`

## Repository

- README explains motivation, API, example, and commands.
- `LICENSE` is present and matches `moon.mod`.
- GitLink repository is public.
- GitHub mirror is synchronized.
- Generated `_build/` files are not committed.

## Package Release

- Confirm `repository` in `moon.mod`.
- Run `moon login`.
- Run `moon publish`.
- Add the Mooncakes package link to the README after publishing.
