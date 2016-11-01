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
flow_station_timing <- read_csv("https://catalogue.data.gov.bc.ca/dataset/d6f30634-a6a8-45b5-808e-210036f25044/resource/eecc311c-2e5b-4bec-8d0a-ae5f1956dffe/download/bcriverflowtimingvolumetrends.csv")

flow_station_timing %<>% rename(Station = station,
                         Latitude = latitude,
                         Longitude = longitude,
                         Units = trend_units,
                         Term = analysis_term,
                         StartYear = start_year,
                         EndYear = end_year,
                         Estimate = trend,
                         Lower = lbound,
                         Upper = ubound,
                         Intercept = intercept,
                         Significant = sig)

flow_station_timing$Term %<>% str_to_title() %>% factor(levels = term)

flow_station_timing %<>% get_ecoprovince()

flow_station_timing %<>% arrange(Ecoprovince, Longitude, Latitude)
flow_station_timing$Ecoprovince %<>%  factor(levels = ecoprovince)
flow_station_timing$Station %<>% factor(unique(flow_station_timing$Station))

flow_station_timing %<>% filter(Units == "days per year") %>%
  filter(trend_type == "trend.ann.1halfdate")
flow_station_timing$Units <- "days"
flow_station_timing$Period <- 1L
flow_station_timing$Indicator <- "Flow"

flow_station_timing %<>% get_flow_statistic_season(col = "trend_type")

flow_station_timing %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Estimate, Lower, Upper, Intercept,
  Significant)

flow_station_timing %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

use_data(flow_station_timing, overwrite = TRUE)
