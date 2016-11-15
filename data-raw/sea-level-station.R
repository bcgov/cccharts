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
sea_level_station <- read_csv("https://catalogue.data.gov.bc.ca/dataset/4458bace-7dc2-4c64-9ec8-c5df75117dbd/resource/43d8bc87-926d-426c-bb3d-53951f01e2dc/download/bcsealeveltrends1910-2014.csv")

sea_level_station$StartYear <- 1910L
sea_level_station$EndYear <- 2014L

sea_level_station %<>% rename(Station = station_id)
sea_level_station$Station %<>% str_replace("^Prince_Rupert$", "Prince Rupert")

canada_cities <- maps::canada.cities
canada_cities %<>% select(Station = name, Latitude = lat, Longitude = long)
canada_cities$Station %<>% str_replace("\\s\\w\\w$", "")

sea_level_station %<>% left_join(canada_cities, by = "Station")
sea_level_station$Latitude[sea_level_station$Station == "Tofino"] <- 49.1530
sea_level_station$Longitude[sea_level_station$Station == "Tofino"] <- -125.9066

sea_level_station %<>% get_ecoprovince()
sea_level_station %<>% arrange(Ecoprovince, Longitude, Latitude)
sea_level_station$Station %<>% factor(unique(sea_level_station$Station))

sea_level_station$Indicator <- "Sea Level"

sea_level_station$Units <- "Centimeter"
sea_level_station$Period <- 10L

sea_level_station$Significant <- TRUE

sea_level_station %<>% mutate(
  Estimate = `slope_mm/year`,
  Lower = `slope_mm/year` - `95_percent_mm/year`,
  Upper = `slope_mm/year` + `95_percent_mm/year`)

sea_level_station %<>% select(
  Indicator, Units, Period, StartYear, EndYear, Ecoprovince, Station, Latitude, Longitude,
  Estimate, Lower, Upper,
  Significant)

sea_level_station %<>% arrange(Indicator, Ecoprovince, Station, StartYear, EndYear)

sea_level_station %<>% cccharts::change_period(100L)

use_data(sea_level_station, overwrite = TRUE)
