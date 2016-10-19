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
flow_station_discharge <- read_csv("https://catalogue.data.gov.bc.ca/dataset/d6f30634-a6a8-45b5-808e-210036f25044/resource/eecc311c-2e5b-4bec-8d0a-ae5f1956dffe/download/bcriverflowtimingvolumetrends.csv")

flow_station_discharge %<>% rename(Station = station,
                         Latitude = latitude,
                         Longitude = longitude,
                         Units = trend_units,
                         Term = analysis_term,
                         StartYear = start_year,
                         EndYear = end_year,
                         Trend = trend,
                         Intercept = intercept,
                         Significant = sig)

flow_station_discharge$Term %<>% str_to_title() %>% factor(levels = term)

flow_station_discharge %<>% get_ecoprovince()

flow_station_discharge %<>% arrange(Ecoprovince, Longitude, Latitude)
flow_station_discharge$Ecoprovince %<>%  factor(levels = ecoprovince)
flow_station_discharge$Station %<>% factor(unique(flow_station_discharge$Station))

flow_station_discharge %<>% filter(Units == "m3/sec per year")
flow_station_discharge$Units <- "cumecs"
flow_station_discharge$Period <- 1L
flow_station_discharge$Indicator <- "Flow"

flow_station_discharge %<>% get_flow_statistic_season(col = "trend_type")

flow_station_discharge %<>% mutate(Uncertainty = ((Trend - lbound) + (ubound - Trend)) / 2)

flow_station_discharge %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend, Uncertainty, Intercept,
  Significant)

flow_station_discharge %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

use_data(flow_station_discharge, overwrite = TRUE)
