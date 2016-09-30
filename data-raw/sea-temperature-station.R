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

sea_temperature_station <- read_csv("https://catalogue.data.gov.bc.ca/dataset/ad95a5c1-5e3e-4571-99a8-1090282a9757/resource/231afe68-3aaa-4552-b396-649de1a55bef/download/bcseasurfacetemptrends1935-2014.csv")

sea_temperature_station %<>% rename(Station = Station_Name)

warning("need to get Ecoprovince by Lat and Long")
sea_temperature_station$Ecoprovince <- "British Columbia"

warning("need to order stations by Ecoprovince")
sea_temperature_station$Station %<>% factor()

sea_temperature_station$Indicator <- "Sea Surface Temperature"

sea_temperature_station$Statistic <- "Mean"
sea_temperature_station$Statistic %<>% factor(levels = statistic)

sea_temperature_station$Units <- "Celsius"
sea_temperature_station$Years <- 100L

sea_temperature_station$Ecoprovince %<>%  factor(levels = ecoprovince)
sea_temperature_station$Season %<>% str_to_title() %>% factor(levels = season)

sea_temperature_station %<>% select(
  Indicator, Statistic, Units, Years, Ecoprovince, Season, Station, Latitude, Longitude,
  Trend = `Trend_Slope_degreesC_per_century`, Uncertainty = `95_percent_uncert_degreesC_per_century`,
  Significant = stat_significance)

use_data(sea_temperature_station, overwrite = TRUE)
