context("test-plot-data")

test_that("plot_estimates_pngs", {
  expect_is(plot_estimates_pngs(data = cccharts::sea_level_station, ask = FALSE, dir = tempfile()), "list")
})

