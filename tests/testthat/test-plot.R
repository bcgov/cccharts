context("test-plot-data")

test_that("plot_estimates_pngs", {
  expect_true(plot_estimates_pngs(ask = FALSE, dir = tempfile()))
})
