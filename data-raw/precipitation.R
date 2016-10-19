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
precipitation <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86f93096-8d3d-4b68-ab63-175cc68257e6/resource/31b4473e-819e-4c04-becd-655837f05fb5/download/precipitationchange19002013.csv")

precipitation$Station <- factor(NA)

precipitation$StartYear <- 1900L
precipitation$EndYear <- 2013L
precipitation$Term <- factor("Long", levels = term)

precipitation$Indicator <- "Precipitation"

precipitation$Statistic <- "Mean"
precipitation$Statistic %<>% factor(levels = statistic)

precipitation$Units <- "percent"
precipitation$Period <- 100L

precipitation$Ecoprovince %<>% tolower() %>% tools::toTitleCase()
precipitation$Ecoprovince %<>%  factor(levels = ecoprovince)
precipitation$Season %<>% factor(levels = season)
precipitation %<>% mutate(Significant = 1 - Percent_Confidence/100,
                            Significant = Significant <= 0.05)

precipitation$Latitude <- NA_real_
precipitation$Longitude <- NA_real_
precipitation$Intercept <- NA_real_
precipitation$Scale <- 1

precipitation %<>% mutate(Trend = Trend_percentcentury,
                          TrendLower = Trend_percentcentury - Uncertainty_percentcentury,
                          TrendUpper = Trend_percentcentury + Uncertainty_percentcentury)

precipitation %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend, TrendLower, TrendUpper, Intercept, Scale,
  Significant)

precipitation %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

use_data(precipitation, overwrite = TRUE)
