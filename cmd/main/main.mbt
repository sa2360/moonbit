///|
/// Runnable example:
///
/// ```bash
/// moon run cmd/main
/// ```
fn main {
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
  println(
    @bench.budget_report(summary, @bench.Budget::{
      max_mean_ns: 30_000_000,
      max_spread_ppm: 1_200_000,
    }),
  )
}
