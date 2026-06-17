# Usage Guide

`moonbench` can either aggregate elapsed samples supplied by a caller, or run a small function repeatedly and measure it with `benchmark`.

The built-in measurement helper uses the standard environment clock. It is convenient for demos, CI smoke checks, and lightweight comparisons. For high-precision research benchmarks, feed samples from a dedicated clock or benchmark runner into `add_sample`.

## Basic Flow

```moonbit
let summary = @bench.benchmark(5, () => {
  let mut total = 0
  for i in 0..<20_000_000 {
    total = total + i % 17
  }
  ignore(total)
})

println(@bench.describe(summary))
```

## CI Budget Report

Use a `Budget` when you want a quick pass/fail line in CI logs:

```moonbit
let budget = @bench.Budget::{
  max_mean_ns: 30_000_000,
  max_spread_ppm: 1_200_000,
}

println(@bench.budget_report(summary, budget))
```

## Manual Samples

If you already have elapsed nanoseconds from another clock or test runner, feed them directly:

```moonbit
let summary = @bench.empty()
  .add_sample(980_000)
  .add_sample(1_020_000)
  .add_sample(1_000_000)
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
