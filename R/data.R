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

#' Air Temperature Trend Data
#'
#' Air temperature trend data imported and modified from
#' \url{https://catalogue.data.gov.bc.ca/dataset/change-in-sea-level-in-bc-1910-2014-}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Units}{The units (chr)}
#' \item{Years}{The period in years (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Trend}{The estimated trend (dbl)}
#' \item{Uncertainty}{The estimated 95\% uncertainty in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"air_temperature"

#' Degree Days Trend Data
#'
"degree_days"

#' Air Temperature Trend Data
#'
"glacial"

#' Precipitation Trend Data
#'
"precipitation"

#' Sea Level Station Trend Data
#'
"sea_level_station"

#' Sea Temperature Station Trend Data
#'
"sea_temperature_station"

#' Snow Trend Data
#'
"snow"

#' Snow Station Trend Data
#'
"snow_station"

