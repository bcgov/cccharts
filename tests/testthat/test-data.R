context("test-data")

test_that("data", {
  expect_is(test_data(cci::air_temperature), "tbl_df")
  expect_is(test_data(cci::degree_days), "tbl_df")
  expect_is(test_data(cci::glacial), "tbl_df")
  expect_is(test_data(cci::precipitation), "tbl_df")
  expect_is(test_data(cci::sea_level_station), "tbl_df")
  expect_is(test_data(cci::sea_temperature_station), "tbl_df")
  expect_is(test_data(cci::snow), "tbl_df")
  expect_is(test_data(cci::snow_station), "tbl_df")
})
