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

all_identical <- function(x) {
  length(unique(x)) == 1
}

check_all_identical <- function(x) {
  stopifnot(all_identical(x))
  x
}

get_ylab_trend <- function(data) {
  check_all_identical(data$Units)
  check_all_identical(data$Period)

  ylab <- paste0("Trend (", data$Units[1], " per ", data$Period[1], " years)")
  ylab %<>% stringr::str_replace("100 years", "century") %>%
    stringr::str_replace("10 years", "decade") %>%
    stringr::str_replace("1 years", "year") %>%
    stringr::str_replace("Percent", "percent") %>%
    ylab
}

get_ylab_observed <- function(data) {
  check_all_identical(data$Units)

  ylab <- paste0("Observed (", data$Units[1], ")") %>%
    stringr::str_replace("Percent", "percent")
  ylab
}

get_labels <- function(data) {
  check_all_identical(data$Units)
  if (data$Units[1] == "percent")
    return(percent)
  return(comma)
}

get_title <- function(data) {
  check_all_identical(data$Indicator)

  data$Indicator[1]
}

get_limits <- function(data) {
  x <- c(data$TrendLower, data$TrendUpper)
  range(x)
}

get_filename <- function(data, by) {
  filename <- NULL
  if (all_identical(data$Indicator)) filename %<>% paste(data$Indicator[1])
  if (all_identical(data$Statistic) && data$Statistic != "Mean")
    filename %<>% paste(data$Statistic[1])
  if (all_identical(data$Season) && data$Season != "Annual")
    filename %<>% paste(data$Season[1])
  if (all_identical(data$Station)) {
    if (all_identical(data$Ecoprovince)) {
      filename %<>% paste(data$Ecoprovince[1])
    } else if (!is.na(data$Station[1]))
      filename %<>% paste(data$Station[1])
  } else {
    if (all_identical(data$Ecoprovince))
      filename %<>% paste(data$Ecoprovince[1])
  }
  stopifnot(!is.null(filename))
  filename
}

not_significant <- function(x) {
  ns <- rep("NS", length(x))
  ns[is.na(x) | x] <- ""
  ns
}

get_by <- function(data, x, facet) {
  by <- c("Indicator", "Ecoprovince", "Station", "Statistic", "Season")
  by <- by[!by %in% c(x, facet)]
  by
}

get_x <- function(data) {
  if (!all_identical(data$Season)) return("Season")
  if (!all_identical(data$Statistic)) return("Statistic")
  if (!all_identical(data$Station)) return("Station")
  if (!all_identical(data$Ecoprovince)) return("Ecoprovince")
  "Indicator"
}

get_png_type <- function() {
  ifelse(.Platform$OS.type == "unix", "cairo", "png-cairo")
}

add_segment_xyend <- function(data, observed) {
  data$x <- min(observed$Year)
  data$xend <- max(observed$Year)
  data$y <- data$Intercept + data$Trend * data$x
  data$yend <- data$Intercept + data$Trend * data$xend
  data
}

#' Change Period
#'
#' Changes Period of data by scaling the trend and its upper and lower limits.
#'
#' @param data The data to
#' @param period The new value for the period.
#'
#' @return The modified data.
#' @export
change_period <- function(data, period = 1L) {
  check_data1(data)
  check_cols(data, c("Trend", "TrendLower", "TrendUpper", "Period"))
  check_scalar(period, c(1L, 10L, 100L))

    data %<>% dplyr::mutate_(Trend = ~Trend / Period * period,
                   TrendLower = ~TrendLower / Period * period,
                   TrendUpper = ~TrendUpper / Period * period,
                   Period = period)
    data
}
