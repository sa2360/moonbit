# moonbench

`moonbench` is a small MoonBit benchmark statistics toolkit for stopwatch-style measurements.

It is designed for the MoonBit OSC2026 ecosystem package track: clear API boundary, runnable tests, a minimal CLI example, CI configuration, and an OSI-approved open-source license.

## Why

MoonBit projects often need lightweight timing summaries while developing parsers, algorithms, CLI tools, and examples. `moonbench` does not own the clock source. It accepts elapsed nanoseconds from your runtime, then provides stable aggregate calculations and compact report strings.

## API

- `empty() -> Summary`
- `singleton(elapsed_ns : Int) -> Summary`
- `Summary::add_sample(summary : Summary, elapsed_ns : Int) -> Summary`
- `merge(left : Summary, right : Summary) -> Summary`
- `samples_per_second(summary : Summary) -> Int`
- `is_stable(summary : Summary, tolerance_ppm : Int) -> Bool`
- `format_ns(ns : Int) -> String`
- `describe(summary : Summary) -> String`

## Example

```moonbit nocheck
let summary = @bench.empty()
  .add_sample(980_000)
  .add_sample(1_020_000)
  .add_sample(1_000_000)

println(@bench.describe(summary))
println("stable(5%)=\{@bench.is_stable(summary, 50_000)}")
```

Output:

```text
count=3, mean=1 ms, min=980 us, max=1 ms, throughput=1000/s
stable(5%)=true
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
