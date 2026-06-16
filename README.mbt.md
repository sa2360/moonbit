# moonbench

`moonbench` is a small MoonBit benchmark statistics toolkit for stopwatch-style measurements.

It is designed for the MoonBit OSC2026 ecosystem package track: clear API boundary, runnable tests, a minimal CLI example, CI configuration, and an OSI-approved open-source license.

## Why

MoonBit projects often need lightweight timing summaries while developing parsers, algorithms, CLI tools, and examples. `moonbench` does not own the clock source. It accepts elapsed nanoseconds from your runtime, then provides stable aggregate calculations and compact report strings.

For quick demos and lightweight tooling, `benchmark` can also run a function repeatedly and measure it with the standard environment clock.

## API

- `empty() -> Summary`
- `singleton(elapsed_ns : Int) -> Summary`
- `measure(run : () -> Unit) -> Int`
- `benchmark(iterations : Int, run : () -> Unit) -> Summary`
- `has_samples(summary : Summary) -> Bool`
- `Summary::add_sample(summary : Summary, elapsed_ns : Int) -> Summary`
- `merge(left : Summary, right : Summary) -> Summary`
- `spread_ns(summary : Summary) -> Int`
- `samples_per_second(summary : Summary) -> Int`
- `is_stable(summary : Summary, tolerance_ppm : Int) -> Bool`
- `format_ns(ns : Int) -> String`
- `describe(summary : Summary) -> String`

## Example

```moonbit nocheck
let summary = @bench.benchmark(5, () => {
  let mut total = 0
  for i in 0..<20_000_000 {
    total = total + i % 17
  }
  ignore(total)
})

println(@bench.describe(summary))
println("spread=\{@bench.format_ns(@bench.spread_ns(summary))}")
println("stable(5%)=\{@bench.is_stable(summary, 50_000)}")
```

Example output, values depend on the machine:

```text
count=5, mean=13 ms, min=11 ms, max=23 ms, throughput=72/s
spread=12 ms
stable(5%)=false
```

## Run

```bash
moon check
moon test
moon run cmd/main
```

## OSC2026 Checklist

- Public repository: <https://github.com/sa2360/moonbit>.
- MoonBit as main language: source is in `.mbt` files.
- README: this file explains motivation, API, example, and commands.
- Runnable example: `cmd/main`.
- Tests: `moonbench_test.mbt`.
- CI: `.github/workflows/ci.yml`.
- License: MIT.
- Mooncakes release: run `moon login`, then `moon publish`.

## Roadmap

- Add percentile helpers once the public API for collection handling is finalized.
- Add optional JSON report formatting for tool integration.
- Add a small guide showing how to wrap platform clocks around this pure statistics layer.
