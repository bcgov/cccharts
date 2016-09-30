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
library(readr)
library(stringr)
library(tools)

library(dplyr)

rm(list = ls())

season <- c("Spring", "Summer", "Fall", "Winter", "Annual")

ecoprovince <- c("Coast and Mountains", "Georgia Depression", "Central Interior", "Southern Interior", "Southern Interior Mountains", "Sub-Boreal Interior", "Boreal Plains", "Taiga Plains", "Northern Boreal Mountains", "British Columbia")

statistic <- c("Minimum", "Mean", "Maximum")

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

