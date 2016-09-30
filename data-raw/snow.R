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
snow <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86526746-40dd-41d2-82c0-fbee3a2e93a2/resource/0e6afa41-5a2c-4e23-9d5a-e07ed35ef443/download/bcsnowdepthswetrendsbyecoprovince1950-2014.csv")

snow %<>% rename(Ecoprovince = ecoprov)
snow$Ecoprovince %<>% tolower() %>% toTitleCase()

snow$Station <- factor(NA)

snow$Indicator <- NA
snow$Indicator[snow$measure == "depth"] <- "Snow Depth"
snow$Indicator[snow$measure == "swe"] <- "Snow Water Equivalent"

snow$Statistic <- "Mean"
snow$Statistic %<>% factor(levels = statistic)

snow$Units <- "Percent"
snow$Years <- 1L

snow$Ecoprovince %<>%  factor(levels = ecoprovince)
snow$Season <- "Annual"
snow$Season %<>% factor(levels = season)

snow %<>% mutate(Uncertainty = multiply_by(slope_SE_percentperyear, 1.96))

snow$Latitude <- NA_real_
snow$Longitude <- NA_real_

snow %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = slope_percentperyear, Uncertainty,
  Significant = validstat)

snow %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season)

use_data(snow, overwrite = TRUE)
