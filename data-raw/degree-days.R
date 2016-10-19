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
degree_days <- read_csv("https://catalogue.data.gov.bc.ca/dataset/8f0d304e-161d-42e6-a982-cad13e60bd8f/resource/31d62c2b-ab92-49b5-89af-16ebda42aa98/download/growheatcooldegreedaychange1900-2013.csv")

degree_days$Station <- factor(NA)

degree_days$StartYear <- 1900L
degree_days$EndYear <- 2013L

degree_days$Term <- factor("Long", levels = term)

degree_days$Indicator <- degree_days$Measure %>% str_replace_all("_", " ")

degree_days$Statistic <- "Mean"
degree_days$Statistic %<>% factor(levels = statistic)

degree_days$Units <- "degree days"
degree_days$Period <- 100L

degree_days$Ecoprovince %<>% tolower() %>% toTitleCase()
degree_days$Ecoprovince %<>%  factor(levels = ecoprovince)
degree_days$Season %<>% factor(levels = season)

degree_days %<>% mutate(Significant = Stat_Significance == 1)

degree_days$Latitude <- NA_real_
degree_days$Longitude <- NA_real_
degree_days$Intercept <- NA_real_
degree_days$Scale <- NA_real_

degree_days %<>% mutate(Trend = Trend_DDcentury,
                        TrendLower = Trend_DDcentury - Uncertainty_DDcentury,
                        TrendUpper = Trend_DDcentury + Uncertainty_DDcentury)

degree_days$Trend %<>% as.numeric()
degree_days$TrendLower %<>% as.numeric()
degree_days$TrendUpper %<>% as.numeric()

degree_days %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend, TrendLower, TrendUpper,
  Intercept, Scale,
  Significant)

degree_days %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

use_data(degree_days, overwrite = TRUE)


