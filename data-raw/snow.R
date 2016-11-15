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
snow <- read_csv("https://catalogue.data.gov.bc.ca/dataset/86526746-40dd-41d2-82c0-fbee3a2e93a2/resource/0e6afa41-5a2c-4e23-9d5a-e07ed35ef443/download/bcsnowdepthswetrendsbyecoprovince1950-2014.csv")

snow_observed <- read_csv("data-raw/raw_snow_data/ecoprov_swe_depth_anomalies_1950_2014.csv")

snow$StartYear <- 1950L
snow$EndYear <- 2014L

snow %<>% rename(Ecoprovince = ecoprov,
                 Intercept = intercept,
                 Significant = validstat)
snow$Ecoprovince %<>% tolower() %>% toTitleCase()

snow$Indicator <- NA
snow$Indicator[snow$measure == "depth"] <- "Snow Depth"
snow$Indicator[snow$measure == "swe"] <- "Snow Water Equivalent"

snow$Units <- "anomaly"
snow$Period <- 1L

snow$Ecoprovince %<>%  factor(levels = ecoprovince)

snow %<>% mutate(Uncertainty = multiply_by(slope_SE, 1.96))
snow %<>% mutate(Estimate = slope_percentperyear,
                 Lower = slope_percentperyear - Uncertainty,
                 Upper = slope_percentperyear + Uncertainty,
                 Estimate = Estimate * 10,
                 Lower = Lower * 10,
                 Upper = Upper * 10)

snow %<>% select(
  Indicator, Units, Period, StartYear, EndYear, Ecoprovince,
  Estimate, Lower, Upper, Intercept, Significant)

snow %<>% arrange(Indicator, Ecoprovince, StartYear, EndYear)

snow_observed %<>% rename(Year = year)

snow_observed %<>% gather(Ecoprovince, Value, -Year)
snow_se_observed <- filter(snow_observed, str_detect(Ecoprovince, "\\sSE$"))
snow_observed %<>% filter(!str_detect(Ecoprovince, "\\sSE$"))

snow_se_observed$Ecoprovince %<>% str_replace("\\sSE$", "")

snow_observed$Ecoprovince %<>% str_to_title() %>% str_replace("And", "and") %>%
  factor(levels = ecoprovince)
snow_se_observed$Ecoprovince %<>% str_to_title() %>% str_replace("And", "and") %>%
  factor(levels = ecoprovince)

snow_observed$Indicator <- "Snow Depth"
snow_se_observed$Indicator <- "Snow Water Equivalent"

snow_observed %<>% bind_rows(snow_se_observed)

snow_observed %<>% inner_join(snow, by = c("Indicator", "Ecoprovince"))
snow_observed %<>% filter(Year >= StartYear & Year <= EndYear)

snow_observed %<>% mutate(Value = as.numeric(Value))

scale <- group_by(snow_observed, Indicator, Ecoprovince) %>% summarise(Scale = mean(Value)) %>%
  ungroup()

snow %<>% inner_join(scale, by = c("Indicator", "Ecoprovince"))

snow %<>% select(
  Indicator, Units, Period, StartYear, EndYear, Ecoprovince,
  Estimate, Lower, Upper, Intercept, Scale, Significant)

snow_observed$Units <- "anomaly"

snow_observed %<>% select(Indicator, Ecoprovince, Year, Value, Units)

use_data(snow, overwrite = TRUE)
use_data(snow_observed, overwrite = TRUE)
