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
# flow_station_discharge <- read_csv("../timing-volume-river-flow-analysis/nobackup_plots/bc_riverflow_timing_volume_trends.csv")

flow_station_discharge_observed <- read_csv("data-raw/raw_flow_data/annual_river_flow_volumes.csv")

flow_station_discharge %<>% rename(Station = station_name,
                         Latitude = latitude,
                         Longitude = longitude,
                         Units = trend_units,
                         Term = analysis_term,
                         StartYear = start_year,
                         EndYear = end_year,
                         MeanAnnualFlow = mean_annual_flow,
                         MaxAnnualFlow = max_annual_flow,
                         MinAnnualFlow = min_annual_flow,
                         Estimate = trend,
                         Lower = lbound,
                         Upper = ubound,
                         Intercept = intercept,
                         Significant = sig)

flow_station_discharge$Term %<>% str_to_title() %>% factor(levels = term)
# flow_station_discharge$Station %<>% str_to_title() %>% str_replace("(.*)(\\sRiver\\s)(At|Near)(.*)", "\\1")

flow_station_discharge %<>% get_ecoprovince()

flow_station_discharge %<>% arrange(Ecoprovince, Longitude, Latitude)
flow_station_discharge$Ecoprovince %<>%  factor(levels = ecoprovince)
flow_station_discharge$Station %<>% factor(unique(flow_station_discharge$Station))

flow_station_discharge %<>% filter(Units == "m3/sec per year")
flow_station_discharge$Units <- "Cumecs"
flow_station_discharge$Period <- 1L
flow_station_discharge$Indicator <- "Discharge"

trend_labels <- c("trend.ann.1thrdate"   = "Timing: 1/3",
                  "trend.ann.1halfdate"  = "Timing: 1/2",
                  "trend.ann.mean"       = "Annual Mean",
                  "trend.ann.min"        = "Annual Min",
                  "trend.ann.max"        = "Annual Max",
                  "trend.SON.mean"       = "Fall Mean",
                  "trend.DJF.mean"       = "Winter Mean",
                  "trend.MAM.mean"       = "Spring Mean",
                  "trend.JJA.mean"       = "Summer Mean",
                  "trend.AMJ.max"        = "Early Spring Max",
                  "trend.JAS.min"        = "Late Summer Min")

flow_station_discharge %<>% mutate(
  Trend_Type = factor(trend_labels[trend_type], levels = trend_labels),
  Sign = ifelse(Estimate > 0, "increase",
                ifelse(Estimate == 0, "stable", "decrease")),
  StartYear = as.integer(StartYear),
  EndYear = as.integer(EndYear))

flow_station_discharge %<>% get_flow_statistic_season(col = "trend_type")

flow_station_discharge %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince,
  Season, Station, Latitude, Longitude, Trend_Type, Estimate, Lower, Upper,
  MeanAnnualFlow, MinAnnualFlow, MaxAnnualFlow, Intercept, Significant, Sign, station)

flow_station_discharge %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

flow_station_discharge_observed %<>% rename(Year = year,
                                        Value = annual_flow_value)

flow_station_discharge_observed %<>% get_flow_statistic_season(col = "annual_flow_summary")

flow_station_discharge_observed %<>% filter(!is.na(Value))

flow_station_discharge_observed$Units <- "Cumecs"
flow_station_discharge_observed$Indicator <- "Discharge"

flow_station_discharge_observed %<>% inner_join(unique(select(flow_station_discharge, Station, Ecoprovince, station)), by = "station")

flow_station_discharge_observed %<>% select(Indicator, Statistic, Season, Ecoprovince, Station, Year, Value, Units)

flow_station_discharge_observed %<>% arrange(Indicator, Statistic, Season, Ecoprovince, Station, Year)

flow_station_discharge_observed$Station %<>% factor(levels = levels(flow_station_discharge$Station))

flow_station_discharge_observed %<>% semi_join(flow_station_discharge, by = c("Statistic", "Season", "Station", "Units"))

flow_station_discharge$Station %<>% droplevels()

flow_station_discharge_observed$Station %<>% droplevels()

flow_station_discharge %<>% mutate(Estimate = Estimate / MeanAnnualFlow,
                                   Lower = Lower / MeanAnnualFlow,
                                   Upper = Upper / MeanAnnualFlow,
                                   Units = "percent")
flow_station_discharge$Scale <- flow_station_discharge$MeanAnnualFlow

flow_station_discharge %<>% cccharts::change_period(1L)

use_data(flow_station_discharge, overwrite = TRUE)
use_data(flow_station_discharge_observed, overwrite = TRUE)
