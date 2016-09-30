context("test-plot-data")

test_that("plot_data", {
  expect_true(trend_pngs(ask = FALSE, dir = tempfile()))
})
