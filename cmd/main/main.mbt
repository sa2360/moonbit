///|
/// Runnable example:
///
/// ```bash
/// moon run cmd/main
/// ```
fn main {
  let summary = @bench.empty()
    .add_sample(980_000)
    .add_sample(1_020_000)
    .add_sample(1_000_000)
  println(@bench.describe(summary))
  println("spread=\{@bench.format_ns(@bench.spread_ns(summary))}")
  println("stable(5%)=\{@bench.is_stable(summary, 50_000)}")
}
