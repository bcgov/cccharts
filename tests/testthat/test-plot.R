context("test-plot-data")

test_that("trend_estimates_pngs", {
  expect_true(trend_estimates_pngs(ask = FALSE, dir = tempfile()))
})
