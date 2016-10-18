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
snow_station <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86526746-40dd-41d2-82c0-fbee3a2e93a2/resource/f1c6257b-6596-483e-82ac-59ccdc8df898/download/bcsnowdepthswetrendsbystation1950-2014.csv")

snow_station %<>% rename(Station = station_id,
                         Latitude = latitude,
                         Longitude = longitude)

snow_station %<>% get_ecoprovince()
snow_station %<>% arrange(Ecoprovince, Longitude, Latitude)
snow_station$Station %<>% factor(unique(snow_station$Station))

snow_station$Indicator <- NA
snow_station$Indicator[snow_station$measure == "depth"] <- "Snow Depth"
snow_station$Indicator[snow_station$measure == "swe"] <- "Snow Water Equivalent"

snow_station$Statistic <- "Mean"
snow_station$Statistic %<>% factor(levels = statistic)

snow_station$Units <- "Percent"
snow_station$Years <- 1L

snow_station$Ecoprovince %<>%  factor(levels = ecoprovince)
snow_station$Season <- "Annual"
snow_station$Season %<>% factor(levels = season)

snow_station %<>% mutate(Uncertainty = multiply_by(slope_SE_percentperyear, 1.96))

snow_station$StartYear <- NA_integer_
snow_station$EndYear <- NA_integer_

snow_station %<>% select(
  Indicator, Statistic, Units, Years, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = slope_percentperyear, Uncertainty,
  Significant = sigstat)

snow_station %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, StartYear, EndYear)

use_data(snow_station, overwrite = TRUE)
