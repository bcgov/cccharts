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
glacial <- read_csv("https://catalogue.data.gov.bc.ca/dataset/89ff86d7-2d04-4c96-b945-ba56688906eb/resource/bf6ba520-dcfd-4a6b-a822-963b77ff7848/download/glacierchange1985-2005.csv")

glacial$Station <- factor(NA)

glacial$StartYear <- 1985L
glacial$EndYear <- 2005L

glacial$Term <- factor("Medium", levels = term)

glacial$Indicator <- "Glacial Area"

glacial$Statistic <- "Mean"
glacial$Statistic %<>% factor(levels = statistic)

glacial$Units <- "percent"
glacial$Period <- 10L

glacial %<>% mutate(Trend = Percentage_Area_Change / (EndYear - StartYear + 1) * Period)

glacial$Ecoprovince %<>% tolower() %>% tools::toTitleCase()
glacial$Ecoprovince %<>%  factor(levels = ecoprovince)
glacial$Season <- "Annual"
glacial$Season %<>% factor(levels = season)

glacial$Uncertainty <- NA_real_
glacial$Significant <- NA

glacial$Latitude <- NA_real_
glacial$Longitude <- NA_real_
glacial$Intercept <- NA_real_

glacial %<>% select(
  Indicator, Statistic, Units, Period, Term, StartYear, EndYear, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = Percentage_Area_Change, Uncertainty, Intercept,
  Significant)

glacial %<>% filter(!is.na(Trend))

glacial %<>% arrange(Indicator, Statistic, Ecoprovince, Station, Season, Term, StartYear, EndYear)

use_data(glacial, overwrite = TRUE)
