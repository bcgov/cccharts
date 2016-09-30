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

test_data <- function(data) {
  check_data3(data, values = list(
    Indicator = "",
    Statistic = factor(.statistic, levels = .statistic),
    Units = "",
    Years = c(1L, 100L),
    Ecoprovince = factor(.ecoprovince, levels = .ecoprovince),
    Season = factor(.season, levels = .season),
    Station = factor(c("", NA)),
    Latitude = c(1, NA),
    Longitude = c(1, NA),
    Trend = c(-1000, 250),
    Uncertainty = c(0, 250, NA),
    Significance = c(TRUE, FALSE, NA)))
}
