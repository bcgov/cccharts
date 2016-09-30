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

snow_station <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86526746-40dd-41d2-82c0-fbee3a2e93a2/resource/f1c6257b-6596-483e-82ac-59ccdc8df898/download/bcsnowdepthswetrendsbystation1950-2014.csv")

snow_station %<>% rename(Station = station_id,
                         Latitude = latitude,
                         Longitude = longitude)

warning("need to get Ecoprovince by Lat and Long")
snow_station$Ecoprovince <- "British Columbia"

warning("need to order stations by Ecoprovince")
snow_station$Station %<>% factor()

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

snow_station %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = slope_percentperyear, Uncertainty,
  Significant = sigstat)

use_data(snow_station, overwrite = TRUE)
