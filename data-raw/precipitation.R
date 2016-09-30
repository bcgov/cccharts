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

precipitation <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86f93096-8d3d-4b68-ab63-175cc68257e6/resource/31b4473e-819e-4c04-becd-655837f05fb5/download/precipitationchange19002013.csv")

precipitation$Station <- factor(NA)

precipitation$Indicator <- "Precipitation"

precipitation$Statistic <- "Mean"
precipitation$Statistic %<>% factor(levels = statistic)

precipitation$Units <- "Percent"
precipitation$Years <- 100L

precipitation$Ecoprovince %<>% tolower() %>% tools::toTitleCase()
precipitation$Ecoprovince %<>%  factor(levels = ecoprovince)
precipitation$Season %<>% factor(levels = season)
precipitation %<>% mutate(Significance = 1 - Percent_Confidence/100,
                            Significance = Significance <= 0.05)

precipitation$Latitude <- NA_real_
precipitation$Longitude <- NA_real_

precipitation %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = Trend_percentcentury, Uncertainty = Uncertainty_percentcentury,
  Significance)

use_data(precipitation, overwrite = TRUE)
