///|
/// Aggregated timing statistics for stopwatch-style benchmark samples.
///
/// The package keeps the data model intentionally small: callers can feed
/// elapsed nanoseconds from any clock source and use the derived summary in CLI
/// tools, test reports, CI logs, or documentation examples.
pub(all) struct Summary {
  count : Int
  total_ns : Int
  min_ns : Int
  max_ns : Int
  mean_ns : Int
} derive(Debug, Eq)

///|
/// Simple performance budget for CI or documentation smoke checks.
pub(all) struct Budget {
  max_mean_ns : Int
  max_spread_ppm : Int
} derive(Debug, Eq)

///|
/// Return an empty summary.
pub fn empty() -> Summary {
  { count: 0, total_ns: 0, min_ns: 0, max_ns: 0, mean_ns: 0 }
}

///|
/// Start a summary with one elapsed sample in nanoseconds.
pub fn singleton(elapsed_ns : Int) -> Summary {
  {
    count: 1,
    total_ns: elapsed_ns,
    min_ns: elapsed_ns,
    max_ns: elapsed_ns,
    mean_ns: elapsed_ns,
  }
}

///|
/// Measure one execution of `run` and return elapsed nanoseconds.
///
/// This helper uses the standard environment clock, so it is portable and
/// intended for lightweight tool output rather than laboratory-grade timing.
pub fn measure(run : () -> Unit) -> Int {
  let start = @env.now()
  run()
  let finish = @env.now()
  let elapsed_ms = if finish > start { finish - start } else { 0UL }
  elapsed_ms.to_int() * 1_000_000
}

///|
/// Execute `run` repeatedly and aggregate the measured elapsed times.
pub fn benchmark(iterations : Int, run : () -> Unit) -> Summary {
  let mut summary = empty()
  let count = if iterations < 0 { 0 } else { iterations }
  for _ in 0..<count {
    summary = summary.add_sample(measure(run))
  }
  summary
}

///|
/// Return true when the summary contains at least one sample.
pub fn has_samples(summary : Summary) -> Bool {
  summary.count > 0
}

///|
/// Add one elapsed sample to an existing summary.
pub fn Summary::add_sample(summary : Self, elapsed_ns : Int) -> Summary {
  if summary.count == 0 {
    singleton(elapsed_ns)
  } else {
    let count = summary.count + 1
    let total_ns = summary.total_ns + elapsed_ns
    let min_ns = if elapsed_ns < summary.min_ns {
      elapsed_ns
    } else {
      summary.min_ns
    }
    let max_ns = if elapsed_ns > summary.max_ns {
      elapsed_ns
    } else {
      summary.max_ns
    }
    { count, total_ns, min_ns, max_ns, mean_ns: total_ns / count }
  }
}

///|
/// Merge two summaries. Empty summaries are identity values.
pub fn merge(left : Summary, right : Summary) -> Summary {
  if left.count == 0 {
    right
  } else if right.count == 0 {
    left
  } else {
    let count = left.count + right.count
    let total_ns = left.total_ns + right.total_ns
    let min_ns = if left.min_ns < right.min_ns {
      left.min_ns
    } else {
      right.min_ns
    }
    let max_ns = if left.max_ns > right.max_ns {
      left.max_ns
    } else {
      right.max_ns
    }
    { count, total_ns, min_ns, max_ns, mean_ns: total_ns / count }
  }
}

///|
/// Difference between the slowest and fastest samples in nanoseconds.
pub fn spread_ns(summary : Summary) -> Int {
  if summary.count < 2 {
    0
  } else {
    summary.max_ns - summary.min_ns
  }
}

///|
/// Integer operations per second, using nanoseconds as the time base.
pub fn samples_per_second(summary : Summary) -> Int {
  if summary.count == 0 || summary.total_ns <= 0 {
    0
  } else {
    let whole = 1_000_000_000 / summary.total_ns
    let remain = 1_000_000_000 % summary.total_ns
    whole * summary.count + remain * summary.count / summary.total_ns
  }
}

///|
/// Return true when the min/max spread is inside a parts-per-million tolerance.
///
/// A tolerance of `100_000` means 10 percent.
pub fn is_stable(summary : Summary, tolerance_ppm : Int) -> Bool {
  if summary.count < 2 || summary.mean_ns <= 0 {
    false
  } else {
    let spread = spread_ns(summary)
    let whole = summary.mean_ns / 1_000_000
    let remain = summary.mean_ns % 1_000_000
    let allowed = whole * tolerance_ppm +
      remain / 1_000 * tolerance_ppm / 1_000 +
      remain % 1_000 * tolerance_ppm / 1_000_000
    spread <= allowed
  }
}

///|
/// Return true when a summary is non-empty and fits the given performance
/// budget.
pub fn meets_budget(summary : Summary, budget : Budget) -> Bool {
  has_samples(summary) &&
  summary.mean_ns <= budget.max_mean_ns &&
  is_stable(summary, budget.max_spread_ppm)
}

///|
/// Produce a compact pass/fail budget report for CI logs.
pub fn budget_report(summary : Summary, budget : Budget) -> String {
  let status = if meets_budget(summary, budget) { "pass" } else { "fail" }
  "\{status}: mean<=\{format_ns(budget.max_mean_ns)}, spread<=\{budget.max_spread_ppm}ppm, \{describe(summary)}"
}

///|
/// Format a nanosecond duration into a compact human-readable unit.
pub fn format_ns(ns : Int) -> String {
  if ns >= 1_000_000 {
    "\{ns / 1_000_000} ms"
  } else if ns >= 1_000 {
    "\{ns / 1_000} us"
  } else {
    "\{ns} ns"
  }
}

///|
/// Produce a one-line report suitable for CLI output and CI logs.
pub fn describe(summary : Summary) -> String {
  if summary.count == 0 {
    "count=0"
  } else {
    "count=\{summary.count}, mean=\{format_ns(summary.mean_ns)}, min=\{format_ns(summary.min_ns)}, max=\{format_ns(summary.max_ns)}, throughput=\{samples_per_second(summary)}/s"
  }
}
