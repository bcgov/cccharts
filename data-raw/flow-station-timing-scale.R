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

source("data-raw/header.R")

load("data/flow_station_timing.rda")
load("data/flow_station_timing_observed.rda")

flow_station_timing_observed$Station %<>% factor(levels = levels(flow_station_timing$Station))

flow_station_timing %<>% semi_join(flow_station_timing_observed, by = c("Statistic", "Season", "Station", "Units"))
flow_station_timing_observed %<>% semi_join(flow_station_timing, by = c("Statistic", "Season", "Station", "Units"))

flow_station_timing$Station %<>% droplevels()
flow_station_timing_observed$Station %<>% droplevels()

flow_station_timing %<>% mutate(
  Trend = Trend * 10,
  TrendLower = TrendLower * 10,
  TrendUpper = TrendUpper * 10,
  Intercept = Intercept * 10,
  Period = 10L)

use_data(flow_station_timing, overwrite = TRUE)
use_data(flow_station_timing_observed, overwrite = TRUE)

