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

flow_station_timing_observed <- read_csv("data-raw/annual_half_river_flow_dates.csv")

flow_station_timing_observed %<>% rename(Station = station, Year = year,
                                Value = ann_half_date)

flow_station_timing_observed$Value %<>% as.numeric()

flow_station_timing_observed %<>% filter(!is.na(Value))

flow_station_timing_observed$Statistic <- factor("Mean", levels = statistic)
flow_station_timing_observed$Season <- factor("Annual", levels = season)
flow_station_timing_observed$Units <- "days"

flow_station_timing_observed %<>% select(Statistic, Season, Station, Year, Value, Units)

flow_station_timing_observed %<>% arrange(Statistic, Season, Station, Year)

use_data(flow_station_timing_observed, overwrite = TRUE)
