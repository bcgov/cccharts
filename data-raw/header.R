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

library(bcmaps)
library(datacheckr)
library(devtools)
library(magrittr)
library(maps)
library(raster)
library(rmapshaper)
library(readr)
library(sp)
library(stringi)
library(stringr)
library(tidyr)
library(tools)

library(dplyr)

rm(list = ls())

season <- c("Annual", "Early Spring", "Spring", "Late Spring", "Early Summer", "Summer", "Late Summer", "Fall", "Winter")

ecoprovince <- c("Coast and Mountains", "Georgia Depression", "Sub-Boreal Interior",
                  "Northern Boreal Mountains", "Boreal Plains", "Central Interior",
                  "Taiga Plains", "Southern Interior", "Southern Interior Mountains",
                  "British Columbia")

statistic <- c("Minimum", "Mean", "Maximum")

term <- c("Medium", "Long")

longlat2sp <- function(data) {
  check_data2(data, values = list(Longitude = 1, Latitude = 1))

  coords <- data[c("Longitude", "Latitude")]
  coords %<>% sp::SpatialPointsDataFrame(data = data, proj4string = sp::CRS("+proj=longlat +ellps=GRS80 +datum=NAD83"))
  coords %<>% spTransform(sp::proj4string(ecoprovinces))
  coords
}

get_ecoprovince <- function(data) {
  station <- longlat2sp(data)
  ecoprovinces <-  bcmaps::ecoprovinces

  station <- dplyr::bind_cols(station@data, dplyr::select_(sp::over(station, ecoprovinces), ~CPRVNCNM))
  station %<>% dplyr::mutate_(Ecoprovince = ~CPRVNCNM,
                              CPRVNCNM = ~NULL)
  station$Ecoprovince %<>% tolower() %>% tools::toTitleCase() %>%
    factor(levels = ecoprovince)
  station
}

get_flow_statistic_season <- function(data, col) {
  col <- data[[col]]

  col %<>% str_replace("^trend[.]", "")

  data$Statistic <- str_replace(col, "(^\\w+[.])(\\w+$)", "\\2")

  data$Statistic %<>% str_replace("min", "Minimum") %>%
    str_replace("max", "Maximum") %>% str_replace("mean", "Mean") %>%
    str_replace("1halfdate", "Mean") %>%
    str_replace("1thrdate", "Mean")

  data$Statistic %<>% factor(levels = statistic)

  data$Season <- str_replace(col, "(^\\w+)([.]\\w+$)", "\\1")

  data$Season %<>% str_replace("ann", "Annual") %>%
    str_replace("DJF", "Winter") %>%
    str_replace("MAM", "Early Spring") %>%
    str_replace("AMJ", "Late Spring") %>%
    str_replace("JJA", "Early Summer") %>%
    str_replace("JAS", "Late Summer") %>%
    str_replace("SON", "Fall")

  data$Season %<>% factor(levels = season)

  data
}
