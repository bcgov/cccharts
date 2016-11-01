# Copyright 2016 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

test_observed_data <- function(data) {
  check_data3(data, values = list(
    Indicator = "",
    Statistic = factor(.statistic, levels = .statistic),
    Season = factor(.season, levels = .season),
    Station = factor(c("", NA)),
    Year = c(1900L, 2015L),
    Value = 1,
    Units = ""))
}

test_trend_data <- function(data) {
  check_data3(data, values = list(
    Indicator = "",
    Statistic = factor(.statistic, levels = .statistic),
    Units = "",
    Period = c(1L, 10L, 100L),
    Term = factor(c(.term), levels = .term),
    StartYear = c(1900L, 2015L),
    EndYear = c(1900L, 2015L),
    Ecoprovince = factor(.ecoprovince, levels = .ecoprovince),
    Season = factor(.season, levels = .season),
    Station = factor(c("", NA)),
    Latitude = c(1, NA),
    Longitude = c(1, NA),
    Trend = c(1),
    Lower = c(1, NA),
    Upper = c(1, NA),
    Intercept = c(1, NA),
    Scale = c(1),
    Significant = c(TRUE, FALSE, NA)))
}
