context("test-plot-data")

test_that("plot_data", {
  expect_true(plot_trends(ask = FALSE, dir = tempfile()))
})
