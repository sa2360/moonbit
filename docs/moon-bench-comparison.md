# Difference from official `moon bench`

`moonbench` is not intended to replace the official `moon bench` command or the standard `moonbitlang/core/bench` package.

## Official `moon bench`

The official tool is the right choice for rigorous MoonBit benchmark runs:

- it is integrated with the MoonBit build system;
- it can select packages, files, indexes, targets, and release/debug modes;
- it uses benchmark-specific timing, batching, statistical summaries, and machine-readable reports;
- it is suitable for serious performance analysis of MoonBit code.

## What `moonbench` Adds

`moonbench` focuses on a smaller integration layer for project tooling:

- aggregate elapsed samples that come from external test runners, CI scripts, logs, or host-specific clocks;
- produce compact one-line summaries for README examples, command output, and CI logs;
- provide simple pass/fail performance budget checks with `Budget`, `meets_budget`, and `budget_report`;
- keep the API small enough to embed in examples, demos, and lightweight developer tools;
- support manual samples and quick `benchmark(iterations, fn)` smoke checks without requiring a full benchmark workflow.

## Positioning

Use official `moon bench` when you need accurate benchmark methodology.

Use `moonbench` when you need to collect already-measured durations, summarize them, and turn them into lightweight reports or CI guardrails.
