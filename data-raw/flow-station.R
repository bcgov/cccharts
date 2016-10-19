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

## Load CSV data file from BC Data Catalogue. Data licensed under the Open Data License-BC
## See metadata record in BC Data Catalogue for details on the data set.
flow_station <- read_csv("https://catalogue.data.gov.bc.ca/dataset/d6f30634-a6a8-45b5-808e-210036f25044/resource/eecc311c-2e5b-4bec-8d0a-ae5f1956dffe/download/bcriverflowtimingvolumetrends.csv")

flow_station %<>% rename(Station = station,
                         Latitude = latitude,
                         Longitude = longitude,
                         Units = trend_units,
                         Term = analysis_term,
                         StartYear = start_year,
                         EndYear = end_year,
                         Trend = percent_change,
                         Significant = sig)

flow_station$Term %<>% str_to_title() %>% factor(levels = term)

flow_station %<>% get_ecoprovince()

flow_station %<>% arrange(Ecoprovince, Longitude, Latitude)
flow_station$Ecoprovince %<>%  factor(levels = ecoprovince)
flow_station$Station %<>% factor(unique(flow_station$Station))

flow_station %<>% filter(Units == "m3/sec per year")
flow_station$Units <- "percent"
flow_station$Period <- 10L
flow_station$Indicator <- "Flow"

warning("assumes trend is across entire period and scales to decadal")
flow_station %<>% mutate(
  Trend = Trend / nyears * 10,
  Uncertainty = (((trend - lbound) + (ubound - trend)) / 2)  * Trend / trend)

warning("because trend and/or percent_change are 0 can't get convert uncertainty to percent trend")
flow_station %<>% filter(!is.nan(Uncertainty)) %>%
  filter(is.finite(Uncertainty))

flow_station %<>% get_flow_statistic_season(col = "trend_type")

flow_station %<>% filter(!is.na(Statistic))

flow_station %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend, Uncertainty,
  Significant)

flow_station %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

use_data(flow_station, overwrite = TRUE)
