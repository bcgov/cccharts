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

flow_station_discharge_data <- read_csv("data-raw/annual_river_flow_volumes.csv")

flow_station_discharge_data %<>% rename(Station = station, Year = year,
                                        Value = annual_flow_value)

flow_station_discharge_data %<>% get_flow_statistic_season(col = "annual_flow_summary")

flow_station_discharge_data %<>% filter(!is.na(Value))

flow_station_discharge_data$Units <- "cumecs"

flow_station_discharge_data %<>% select(Statistic, Season, Station, Year, Value, Units)

flow_station_discharge_data %<>% arrange(Statistic, Season, Station, Year)

use_data(flow_station_discharge_data, overwrite = TRUE)
