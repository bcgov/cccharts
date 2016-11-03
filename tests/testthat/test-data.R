context("test-data")

test_that("trend_data", {
  expect_is(test_estimate_data(cccharts::air_temperature), "tbl_df")
  expect_is(test_estimate_data(cccharts::degree_days), "tbl_df")
  expect_is(test_estimate_data(cccharts::flow_station_timing), "tbl_df")
  expect_is(test_estimate_data(cccharts::flow_station_discharge), "tbl_df")
  expect_is(test_estimate_data(cccharts::glacial), "tbl_df")
  expect_is(test_estimate_data(cccharts::precipitation), "tbl_df")
  expect_is(test_estimate_data(cccharts::sea_level_station), "tbl_df")
  expect_is(test_estimate_data(cccharts::sea_surface_temperature_station), "tbl_df")
  expect_is(test_estimate_data(cccharts::snow), "tbl_df")
  expect_is(test_estimate_data(cccharts::snow_station), "tbl_df")
})

test_that("observed_data", {
  expect_is(test_observed_data(cccharts::flow_station_discharge_observed), "tbl_df")
  expect_is(test_observed_data(cccharts::flow_station_timing_observed), "tbl_df")
  expect_is(test_observed_data(cccharts::snow_observed), "tbl_df")
  expect_is(test_observed_data(cccharts::snow_station_observed), "tbl_df")
})
