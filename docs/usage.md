# Usage Guide

`moonbench` keeps timing collection separate from timing statistics. A caller measures elapsed time with the runtime or host environment it already uses, then feeds elapsed nanoseconds into `Summary`.

## Basic Flow

```moonbit
let summary = @bench.empty()
  .add_sample(980_000)
  .add_sample(1_020_000)
  .add_sample(1_000_000)

println(@bench.describe(summary))
```

## Interpreting Fields

- `count`: number of recorded samples
- `total_ns`: total elapsed nanoseconds
- `min_ns`: fastest sample
- `max_ns`: slowest sample
- `mean_ns`: integer average elapsed nanoseconds

## Stability

`is_stable(summary, tolerance_ppm)` compares the min/max spread with the mean. `50_000` means 5 percent, and `100_000` means 10 percent.

Use it as a lightweight guardrail for examples and CI logs, not as a replacement for full statistical benchmarking.
