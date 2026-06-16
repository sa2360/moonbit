///|
test "add samples updates all aggregate fields" {
  let summary = empty().add_sample(100).add_sample(140).add_sample(160)
  assert_eq(has_samples(summary), true)
  assert_eq(summary.count, 3)
  assert_eq(summary.total_ns, 400)
  assert_eq(summary.min_ns, 100)
  assert_eq(summary.max_ns, 160)
  assert_eq(summary.mean_ns, 133)
  assert_eq(spread_ns(summary), 60)
}

///|
test "empty summaries have no samples or spread" {
  let summary = empty()
  assert_eq(has_samples(summary), false)
  assert_eq(spread_ns(summary), 0)
  assert_eq(samples_per_second(summary), 0)
  assert_eq(describe(summary), "count=0")
}

///|
test "benchmark records one sample per iteration" {
  let summary = benchmark(3, () => {
    let mut total = 0
    for i in 0..<100 {
      total = total + i
    }
    ignore(total)
  })
  assert_eq(summary.count, 3)
  assert_eq(has_samples(summary), true)
}

///|
test "benchmark ignores negative iteration counts" {
  let summary = benchmark(-1, () => ignore(1 + 1))
  assert_eq(summary.count, 0)
  assert_eq(has_samples(summary), false)
}

///|
test "merge keeps empty as identity" {
  let left = singleton(200).add_sample(300)
  let from_left = merge(empty(), left)
  let from_right = merge(left, empty())
  assert_eq(from_left.count, left.count)
  assert_eq(from_left.total_ns, left.total_ns)
  assert_eq(from_right.count, left.count)
  assert_eq(from_right.total_ns, left.total_ns)
}

///|
test "merge combines min max and mean" {
  let left = singleton(100).add_sample(200)
  let right = singleton(400).add_sample(500)
  let actual = merge(left, right)
  assert_eq(actual.count, 4)
  assert_eq(actual.total_ns, 1200)
  assert_eq(actual.min_ns, 100)
  assert_eq(actual.max_ns, 500)
  assert_eq(actual.mean_ns, 300)
}

///|
test "throughput uses nanosecond time base" {
  let summary = singleton(1_000_000).add_sample(1_000_000)
  assert_eq(samples_per_second(summary), 1000)
}

///|
test "stability uses ppm tolerance" {
  let stable = singleton(1_000).add_sample(1_020).add_sample(980)
  let noisy = singleton(1_000).add_sample(1_400).add_sample(800)
  assert_eq(is_stable(stable, 50_000), true)
  assert_eq(is_stable(noisy, 50_000), false)
}

///|
test "format and describe are concise" {
  assert_eq(format_ns(42), "42 ns")
  assert_eq(format_ns(42_000), "42 us")
  assert_eq(format_ns(42_000_000), "42 ms")
  assert_eq(
    describe(singleton(1_000_000).add_sample(1_000_000)),
    "count=2, mean=1 ms, min=1 ms, max=1 ms, throughput=1000/s",
  )
}
