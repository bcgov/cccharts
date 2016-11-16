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

#' Acronym
#'
#' Creates an Acronym by just extracting the capital letters.
#' @param x The character vector to convert to acronyms.
#' @return A character vector.
#' @export
#' @examples
#' acronym(levels(snow$Ecoprovince))
acronym <- function(x) {
  x %<>% stringr::str_extract_all("[A-Z]")
  x %<>% lapply(stringr::str_c, collapse = "") %>% unlist()
  x
}

bounds <- function(bounds, map) {
  if (bounds[1] >= bounds[2]) stop("bounds[1] must be less than bounds[2]", call. = FALSE)
  if (bounds[3] >= bounds[4]) stop("bounds[3] must be less than bounds[4]", call. = FALSE)
  bbox <- sp::bbox(map)
  diff <- as.vector(diff(t(bbox)))
  origin <- as.vector(bbox[,1,drop = FALSE])
  start <- origin + diff * bounds[c(1,3)]
  end <- origin + diff * bounds[c(2,4)]
  bbox <- c(start[1], end[1], start[2], end[2])
  bbox
}

bound <- function(map, bounds) {
  bounds %<>% bounds(map)
  bounds %<>% raster::extent()
  map %<>% raster::crop(bounds)
  map
}

check_all_identical <- function(x) {
  stopifnot(all_identical(x))
  x
}

#' Inconsistent Significance
#'
#' @param data The data to identify inconsistent significance
#' @return The data with an additional column called Inconsistent.
#' @export
inconsistent_significance <- function(data) {
  check_data2(data, values = list(
    Estimate = 1,
    Lower = 1,
    Upper = 1,
    Significant = TRUE))

  data$Inconsistent <- (!data$Significant  & (data$Lower > 0 | data$Upper < 0)) | (data$Significant & data$Lower < 0 & data$Upper > 0)
  data
}

#' Y-Axis Estimates Trend
#'
#' @param data The data to generate the y-axis label for.
#' @return A string
#' @export
ylab_estimates <- function(data) {
  check_all_identical(data$Units)
  check_all_identical(data$Period)

  ylab <- paste0(data$Units[1], " per ", data$Period[1], " years")
  ylab %<>% stringr::str_replace("100 years", "century") %>%
    stringr::str_replace("10 years", "decade") %>%
    stringr::str_replace("1 years", "year") %>%
    stringr::str_replace("percent", "Percent")
    ylab
}

#' Y-Axis Label Trend
#'
#' @param data The data to generate the y-axis label for.
#' @return A string
#' @export
ylab_trend <- function(data) {
  check_all_identical(data$Units)
  check_all_identical(data$Period)

  ylab <- paste0(data$Units[1], "\nper ", data$Period[1], " years")
  ylab %<>% stringr::str_replace("100 years", "century") %>%
    stringr::str_replace("10 years", "decade") %>%
    stringr::str_replace("1 years", "year") %>%
    stringr::str_replace("percent", "Percent")
    ylab
}

#' Y-Axis Label Fit
#'
#' @param data The data to generate the y-axis label for.
#' @return A string
#' @export
ylab_fit <- function(data) {
  check_all_identical(data$Units)

  ylab <- paste0(data$Units[1]) %>%
    stringr::str_replace("percent", "Percent")
  ylab
}

get_labels <- function(data) {
  check_all_identical(data$Units)
  if (data$Units[1] %in% c("Percent", "percent"))
    return(percent)
  return(comma)
}

get_limits <- function(data) {
  x <- c(data$Estimate)
  range(x, na.rm = TRUE)
}

get_ylimits <- function(data) {
  x <- c(data$Estimate, data$Lower, data$Upper)
  range(x, na.rm = TRUE)
}

get_filename <- function(data) {
  filename <- NULL
  if (all_identical(data$Indicator)) filename %<>% paste(data$Indicator[1])
  if (all_identical(data$Statistic) && data$Statistic[1] != "Mean")
    filename %<>% paste(data$Statistic[1])
  if (all_identical(data$Season) && data$Season != "Annual")
    filename %<>% paste(data$Season[1])
  if (all_identical(data$Term) && !is.na(data$Term[1]))
    filename %<>% paste(data$Term[1])
  if (all_identical(data$Station)) {
    if (!is.na(data$Station[1])) {
      filename %<>% paste(data$Station[1])
    } else if (all_identical(data$Ecoprovince)) {
      filename %<>% paste(data$Ecoprovince[1])
    }
  } else {
    if (all_identical(data$Ecoprovince))
      filename %<>% paste(data$Ecoprovince[1])
  }
  stopifnot(!is.null(filename))
  filename
}

get_by <- function(data, x, facet = NULL) {
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

#' Get PNG Type
#'
#' @return A string of the platform specific png type.
#' @export
get_png_type <- function() {
  ifelse(.Platform$OS.type == "unix", "cairo", "windows")
}

add_segment_xyend <- function(data, observed) {
  data$x <- data$StartYear
  data$xend <- data$EndYear
  data$y <- data$Intercept + data$Estimate * (data$x - data$StartYear - 1)
  data$yend <- data$Intercept + data$Estimate * (data$xend - data$StartYear - 1)
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
  check_cols(data, c("Estimate", "Lower", "Upper", "Period"))
  check_scalar(period, c(1L, 10L, 100L))

  data %<>% dplyr::mutate_(Estimate = ~Estimate / Period * period,
                           Lower = ~Lower / Period * period,
                           Upper = ~Upper / Period * period,
                           Period = period)
  data
}

not_significant <- function(x) {
  ns <- rep("NS", length(x))
  ns[is.na(x) | x] <- ""
  ns
}

rescale_data <- function(data) {
  check_data1(data)
  check_cols(data, c("Estimate", "Lower", "Upper", "Scale"))

  data %<>% dplyr::mutate_(Estimate = ~Estimate * Scale,
                           Lower = ~Lower * Scale,
                           Upper = ~Upper * Scale)
  data
}

complete_missing <- function (data, missing, na = NA_real_) {
  missing <- missing[!missing %in% colnames(data)]

  if (!length(missing)) return(data)

  for (col in missing) {
    data[col] <- na
  }
  data
}

complete_estimate_data <- function(data) {
  data %<>% complete_missing(missing = c("Latitude", "Longitude", "Intercept", "Lower", "Upper"))

  if (!tibble::has_name(data, "Scale")) data$Scale <- 1
  if (!tibble::has_name(data, "Station")) data$Station <- factor(NA)
  if (!tibble::has_name(data, "Term")) data$Term <- factor(NA, levels = .term)
  if (!tibble::has_name(data, "Statistic")) data$Statistic <- factor("Mean", levels = .statistic)
  if (!tibble::has_name(data, "Season")) data$Season <- factor("Annual", levels = .season)
  if (!tibble::has_name(data, "Significant")) data$Significant <- NA

  data %<>% dplyr::select_(
    ~Indicator, ~Statistic, ~Units, ~Period, ~Term, ~StartYear, ~EndYear,
    ~Ecoprovince, ~Season, ~Station, ~Latitude, ~Longitude,
    ~Estimate, ~Lower, ~Upper, ~Intercept, ~Scale, ~Significant)

  data %<>% dplyr::arrange_(~Indicator, ~Statistic, ~Ecoprovince, ~Station,
                            ~Season, ~StartYear, ~EndYear)
  data
}

complete_observed_data <- function(data) {

  if (!tibble::has_name(data, "Station")) data$Station <- factor(NA)
  if (!tibble::has_name(data, "Statistic")) data$Statistic <- factor("Mean", levels = .statistic)
  if (!tibble::has_name(data, "Season")) data$Season <- factor("Annual", levels = .season)

  data %<>% dplyr::select_(
    ~Indicator, ~Statistic, ~Season, ~Ecoprovince, ~Station, ~Year, ~Value, ~Units)

  data %<>% dplyr::arrange_(~Indicator, ~Statistic, ~Season, ~Ecoprovince, ~Station, ~Year)
  data
}

#' Plot GGPlot
#'
#' @param gp The ggplot object to plot.
#' @param filename A string of the filename.
#' @param width A count of the width in pixels.
#' @param height A count of the height in pixels.
plot_ggplot <- function(gp, filename, width, height) {
  stopifnot(is.ggplot(gp))
  check_string(filename)
  check_count(width)
  check_count(height)

  png(filename = filename, width = width, height = height, type = get_png_type())
  print(gp)
  dev.off()
}

fun_png <- function(data, dir, width, height, fun, prefix, ...) {
  check_string(prefix)

  filename <- get_filename(data) %>% paste0(".png") %>% paste0(prefix, .)
  filename <- file.path(dir, filename)

  gp <- fun(data, ...)
  plot_ggplot(gp, filename = filename, width = width, height = height)
  gp
}

latlong2eastnorth <- function(
  data, long = "Longitude", lat = "Latitude", east = "Easting", north = "Northing",
  geodatum = "WGS84", projargs = "+init=epsg:3005") {

  check_string(long)
  check_string(lat)
  check_string(east)
  check_string(north)
  check_string(geodatum)
  check_string(projargs)

  if (inherits(data, "Spatial")) {
    if (sp::proj4string(data) != paste0("+proj=longlat +ellps=", geodatum))
      stop("data must have projection '+proj=longlat +ellps=WGS84'", call. = FALSE)
    data <- suppressWarnings(broom::tidy(data))
  }
  check_data2(data, values = stats::setNames(list(c(1,NA), c(1,NA)), c(long, lat)))

  if (tibble::has_name(data, east)) warning("column '", east, "' has been replaced", call. = FALSE)
  if (tibble::has_name(data, north)) warning("column '", north, "' has been replaced", call. = FALSE)

  data$Easting <- NA_real_
  data$Northing <- NA_real_

  geodatum <- paste0("+proj=longlat +ellps=", geodatum)
  points <- data[c(long, lat)]
  missing <- is.na(points[[long]]) | is.na(points[[lat]])

  if (any(!missing)) {
    points <- points[!missing,,drop = FALSE]
    points %<>% sp::SpatialPoints(sp::CRS(geodatum))
    points %<>% sp::spTransform(sp::CRS(projargs))
    points <- suppressWarnings(broom::tidy(points)) # SpatialPoints method undefined
    data$Easting[!missing] <- points[[long]]
    data$Northing[!missing] <- points[[lat]]
  }

  data
}

#' Write GeoJSON file
#'
#' @param map The SpatialPolygonsDataFrame to write.
#' @param file A string of the filename.
#' @export
write_geojson <- function(map = cccharts::bc, file = "map") {
  check_string(file)
  geojsonio::geojson_write(map, file = file, precision = 5)
}
