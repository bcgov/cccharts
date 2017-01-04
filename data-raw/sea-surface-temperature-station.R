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
sea_surface_temperature_station <- read_csv("https://catalogue.data.gov.bc.ca/dataset/ad95a5c1-5e3e-4571-99a8-1090282a9757/resource/231afe68-3aaa-4552-b396-649de1a55bef/download/bcseasurfacetemptrends1935-2014.csv")

sea_surface_temperature_station %<>% rename(Station = Station_Name)

sea_surface_temperature_station$StartYear <- 1935L
sea_surface_temperature_station$EndYear <- 2014L

sea_surface_temperature_station %<>% get_ecoprovince()
# race rocks falls outside BC ecoprovinces
sea_surface_temperature_station$Ecoprovince[sea_surface_temperature_station$Station == "Race Rocks"] <- "Georgia Depression"

sea_surface_temperature_station %<>% arrange(Ecoprovince, Longitude, Latitude)
sea_surface_temperature_station$Station %<>% factor(unique(sea_surface_temperature_station$Station))

sea_surface_temperature_station$Indicator <- "Sea Surface Temperature"

sea_surface_temperature_station$Units <- "Celsius"
sea_surface_temperature_station$Period <- 100L

sea_surface_temperature_station$Ecoprovince %<>%  factor(levels = ecoprovince)
sea_surface_temperature_station$Season %<>% str_to_title() %>% factor(levels = season)

sea_surface_temperature_station %<>% mutate(
  Estimate = `Trend_Slope_DegreesC_per_century`,
  Lower = Trend_Slope_LCL,
  Upper = Trend_Slope_UCL)


sea_surface_temperature_station %<>% select(
  Indicator, Units, Period, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Estimate, Lower, Upper, Significant = stat_significance)

sea_surface_temperature_station %<>% arrange(Indicator, Ecoprovince, Station, StartYear, EndYear)

use_data(sea_surface_temperature_station, overwrite = TRUE)
