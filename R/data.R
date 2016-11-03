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
#' Air temperature trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/long-term-change-in-air-temperature-and-precipitation-in-bc}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"air_temperature"

#' Degree Days Trend Data
#'
#' Degree days trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/long-term-change-in-growing-degree-days-and-heating-and-cooling-degree-days-in-bc}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"degree_days"

#' Flow Station Discharge Trend Data
#'
#' Flow station discharge trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/xx}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{Term}{The term of the analysis with levels 'Medium' or 'Long' (fctr)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Intercept}{The estimated intercept (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"flow_station_discharge"

#' Flow Station Timing Trend Data
#'
#' Flow station timing trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/xx}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{Term}{The term of the analysis with levels 'Medium' or 'Long' (fctr)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"flow_station_timing"

#' Glacial Trend Data
#'
#' Glacial trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/change-in-size-of-glaciers-in-bc-1985-2005-}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Estimate}{The estimated trend (dbl)}
#' }
"glacial"

#' Precipitation Trend Data
#'
#' Precipitation trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/long-term-change-in-air-temperature-and-precipitation-in-bc}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"precipitation"

#' Sea Level Station Trend Data
#'
#' Sea level station trend data imported and reformatted from
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
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{Term}{The term of the analysis with levels 'Medium' or 'Long' (fctr)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"sea_level_station"

#' Sea Surface Temperature Station Trend Data
#'
#' Sea surfacte temperature station trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/change-in-sea-surface-temperature-in-bc-1935-2014-}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"sea_surface_temperature_station"

#' Snow Trend Data
#'
#' Snow trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/change-in-snow-depth-and-snow-water-content-in-bc-1950-2014-}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{Term}{The term of the analysis with levels 'Medium' or 'Long' (fctr)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"snow"

#' Snow Station Trend Data
#'
#' Snow station trend data imported and reformatted from
#' \url{https://catalogue.data.gov.bc.ca/dataset/change-in-snow-depth-and-snow-water-content-in-bc-1950-2014-}.
#'
#' Data licensed under the Open Data License-BC.
#' See metadata record in BC Data Catalogue for more details on the original data set.
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Units}{The units (chr)}
#' \item{Period}{The period of the estimated change in years (int)}
#' \item{Term}{The term of the analysis with levels 'Medium' or 'Long' (fctr)}
#' \item{StartYear}{The first year (int)}
#' \item{EndYear}{The last year (int)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name if a station (fctr)}
#' \item{Latitude}{The longitude if a station (dbl)}
#' \item{Longitude}{The latitude if a station (dbl)}
#' \item{Estimate}{The estimated trend (dbl)}
#' \item{Lower}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Upper}{The estimated lower 95\% confidence interval in the trend (dbl)}
#' \item{Significant}{Whether the estimate is statistically significant at the 5\% level (lgl)}
#' }
"snow_station"

#' Flow Station Discharge Observed Data
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name (fctr)}
#' \item{Year}{The flow year (int)}
#' \item{Value}{The discharge (dbl)}
#' \item{Units}{The units (chr)}
#' }
"flow_station_discharge_observed"

#' Flow Station Timing Observed Data
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Statistic}{The statistic with levels 'Mean', 'Minimum' or 'Maximum' (fctr)}
#' \item{Season}{The season with levels 'Spring', 'Summer', 'Fall', 'Winter' or 'Annual' (fctr)}
#' \item{Station}{The station name (fctr)}
#' \item{Year}{The flow year (int)}
#' \item{Value}{The timing (dbl)}
#' \item{Units}{The units (chr)}
#' }
"flow_station_timing_observed"

#' Snow Data Observed
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Year}{The flow year (int)}
#' \item{Value}{The depth (dbl)}
#' \item{Units}{The units (chr)}
#' }
"snow_observed"

#' Snow Station Data Observed
#'
#' @format A tbl data frame:
#' \describe{
#' \item{Indicator}{The indicator name (chr)}
#' \item{Ecoprovince}{The Ecoprovince (fctr)}
#' \item{Station}{The station (fctr)}
#' \item{Year}{The flow year (int)}
#' \item{Value}{The depth (dbl)}
#' \item{Units}{The units (chr)}
#' }
"snow_station_observed"

#' Map of Ecoprovinces
#'
#' SpatialPolygonsDataFrame of Ecoprovinces for British Columbia.
#'
#' From bcmaps package.
"bc"
