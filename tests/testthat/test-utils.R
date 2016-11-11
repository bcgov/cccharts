context("test-utils")

test_that("bounds", {
  expect_equal(c(-139.01427, -114.09113, 48.29752, 60.00057), bounds(c(0,1,0,1), cccharts::bc), tolerance = 1e-06)
  expect_equal(c(-139.01427, -126.55270, 48.29752, 60.00057), bounds(c(0,0.5,0,1), cccharts::bc), tolerance = 1e-06)
  expect_equal(c(-139.01427, -114.09113, 57.07481, 60.00057), bounds(c(0,1,0.75,1), cccharts::bc), tolerance = 1e-06)
  expect_error(bounds(c(0,0,0.75,1), cccharts::bc), "bounds[[]1[]] must be less than bounds[[]2[]]")
})
