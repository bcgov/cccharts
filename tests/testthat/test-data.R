context("test-data")

test_that("data", {
  expect_is(test_data(cccharts::air_temperature), "tbl_df")
  expect_is(test_data(cccharts::degree_days), "tbl_df")
  expect_is(test_data(cccharts::glacial), "tbl_df")
  expect_is(test_data(cccharts::precipitation), "tbl_df")
  expect_is(test_data(cccharts::sea_level_station), "tbl_df")
  expect_is(test_data(cccharts::sea_temperature_station), "tbl_df")
  expect_is(test_data(cccharts::snow), "tbl_df")
  expect_is(test_data(cccharts::snow_station), "tbl_df")
})
