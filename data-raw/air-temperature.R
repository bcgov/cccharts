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

## Load CSV data file from BC Data Catalogue. Data liscensed under the Open Data License-BC
## See metadata record in BC Data Catalogue for details on the data set.
air_temperature <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86f93096-8d3d-4b68-ab63-175cc68257e6/resource/2ea26a15-8420-4d85-bba0-742b8c1a4dc2/download/temperaturechange19002013.csv")

air_temperature$Station <- factor(NA)

air_temperature$Indicator <- "Air Temperature"

air_temperature$Statistic <- air_temperature$Measure
air_temperature$Statistic %<>% str_replace("^Mean_Temp$", "Mean") %>%
  str_replace("^Min_Temp$", "Minimum") %>% str_replace("^Max_Temp$", "Maximum")
air_temperature$Statistic %<>% factor(levels = statistic)

air_temperature$Units <- "Celsius"
air_temperature$Years <- 100L

air_temperature$Ecoprovince %<>% tolower() %>% tools::toTitleCase()
air_temperature$Ecoprovince %<>%  factor(levels = ecoprovince)
air_temperature$Season %<>% factor(levels = season)
air_temperature %<>% mutate(Significant = 1 - Percent_Confidence/100,
                            Significant = Significant <= 0.05)

air_temperature$Latitude <- NA_real_
air_temperature$Longitude <- NA_real_

air_temperature %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = Trend_Ccentury, Uncertainty = Uncertainty_Ccentury,
  Significant)

use_data(air_temperature, overwrite = TRUE)
