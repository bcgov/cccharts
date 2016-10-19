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

load("data/flow_station_discharge.rda")
load("data/flow_station_discharge_observed.rda")

flow_station_discharge_observed$Station %<>% factor(levels = levels(flow_station_discharge$Station))

mad <- group_by(flow_station_discharge_observed, Statistic, Season, Station, Units) %>% summarise(MAD = mean(Value)) %>% ungroup()

flow_station_discharge %<>% inner_join(mad, by = c("Statistic", "Season", "Station", "Units"))
flow_station_discharge_observed %<>% semi_join(flow_station_discharge, by = c("Statistic", "Season", "Station", "Units"))

flow_station_discharge$Station %<>% droplevels()
flow_station_discharge_observed$Station %<>% droplevels()

flow_station_discharge %<>% mutate(
  Trend = Trend / MAD * 10,
  TrendLower = TrendLower / MAD * 10,
  TrendUpper = TrendUpper / MAD * 10,
  Units = "percent",
  Period = 10L)

flow_station_discharge$Scale <- flow_station_discharge$MAD
flow_station_discharge$MAD <- NULL

use_data(flow_station_discharge, overwrite = TRUE)
use_data(flow_station_discharge_observed, overwrite = TRUE)

