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

glacial <- read_csv("https://catalogue.data.gov.bc.ca/dataset/89ff86d7-2d04-4c96-b945-ba56688906eb/resource/bf6ba520-dcfd-4a6b-a822-963b77ff7848/download/glacierchange1985-2005.csv")

glacial$Station <- factor(NA)

glacial$Indicator <- "Glacial Area"

glacial$Statistic <- "Mean"
glacial$Statistic %<>% factor(levels = statistic)

glacial$Units <- "Percent"
glacial$Years <- 20L

glacial$Ecoprovince %<>% tolower() %>% tools::toTitleCase()
glacial$Ecoprovince %<>%  factor(levels = ecoprovince)
glacial$Season <- "Annual"
glacial$Season %<>% factor(levels = season)

glacial$Uncertainty <- NA_real_
glacial$Significant <- NA

glacial$Latitude <- NA_real_
glacial$Longitude <- NA_real_

glacial %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = Percentage_Area_Change, Uncertainty,
  Significant)

glacial %<>% filter(!is.na(Trend))

use_data(glacial, overwrite = TRUE)
