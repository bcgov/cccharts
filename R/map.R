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

#' Map Trend Estimates
#'
#' Maps trend estimates
#'
#' @inheritParams plot_estimates_pngs
#' @inheritParams map_estimates_pngs
#' @return A ggplot2 object.
#' @export
map_estimates <- function(data, nrow = NULL, station = FALSE, map = cccharts::bc, proj4string = "+init=epsg:3005", limits = NULL, labels = TRUE, llab = ylab_trend, low = "blue", mid = "yellow", high = "red", switch = FALSE) {
  test_estimate_data(data)
  data %<>% complete_estimate_data()

  if (station) {
    check_unique(data$Station)
  } else {
    check_unique(data$Ecoprovince)
  }
  check_flag(switch)

  if (!inherits(map, "SpatialPolygonsDataFrame"))
    stop("map must be a SpatialPolygonsDataFrame", call. = FALSE)
  check_string(proj4string)

  if (data$Units[1] == "percent") {
    data %<>% dplyr::mutate_(Estimate = ~Estimate / 100,
                             Lower = ~Lower / 100,
                             Upper = ~Upper / 100)
    if (is.numeric(limits))
      limits %<>% magrittr::divide_by(100)
  }

  map %<>% sp::spTransform(sp::CRS(proj4string))

  map@data <- as.data.frame(dplyr::bind_cols(
  map@data, dplyr::select_(as.data.frame(rgeos::gCentroid(map, byid = TRUE)),
                       EastingEcoprovince = ~x, NorthingEcoprovince = ~y)))

  suppressMessages(polygon <- broom::tidy(map))
  polygon %<>% dplyr::rename_(.dots = list(Ecoprovince = "id"))
  polygon$Ecoprovince %<>% as.integer()
  polygon$Ecoprovince <- levels(data$Ecoprovince)[polygon$Ecoprovince]
  polygon$Ecoprovince %<>% factor(levels = levels(data$Ecoprovince))

  if (!station) {
    polygon %<>% dplyr::left_join(data, by = "Ecoprovince")
  }
  data %<>% latlong2eastnorth(projargs = proj4string)

  if (switch) {
    x <- low
    low <- high
    high <- x
  }

  gp <- ggplot() +
    coord_equal()

  if (station) {
    gp <- gp + geom_polygon(data = dplyr::filter_(polygon, ~!hole),
                            ggplot2::aes_string(x = "long", y = "lat", group = "group"),
                            fill = "grey80", color = "grey50") +
      geom_point(data = data, aes_string(x = "Easting", y = "Northing", color = "Estimate"), size = 4) +
      scale_color_gradient2(limits = limits, labels = get_labels(data),
                             guide = guide_colourbar(title = llab(data), title.position = "bottom"),
                            low = low, mid = mid, high = high)

    if (labels) {
      gp <- gp + ggrepel::geom_label_repel(data = data, aes_(x = ~Easting, y = ~Northing, label = ~Station))
    }
  } else {
    gp <- gp + geom_polygon(data = dplyr::filter_(polygon, ~!hole),
                            ggplot2::aes_string(x = "long", y = "lat", group = "group", fill = "Estimate"),
                            color = "grey50") +
      scale_fill_gradient2(limits = limits, labels = get_labels(data), low = low,
                           high = high, mid = mid,
                            na.value = "grey80",
                            guide = guide_colourbar(title = llab(data), title.position = "bottom"))
        if (labels) {
          gp <- gp + ggrepel::geom_label_repel(data = map@data, aes_(x = ~EastingEcoprovince, y = ~NorthingEcoprovince, label = ~Ecoprovince))
    }
  }

  gp <- gp + theme_cccharts(facet = FALSE, map = TRUE) +
    theme(legend.justification = c(0,0),
          legend.position = c(0,0),
          legend.direction = "vertical")
  gp
}

#' Maps PNGs
#'
#' Generates maps of climate indicator data as png files.
#' @inheritParams plot_estimates_pngs
#' @param station A flag indicating whether the plot is for stations or ecoprovinces.
#' @param map A SpatialPolygonsDataFrame object.
#' @param proj4string A character string of projection arguments; the arguments must be entered exactly as in the PROJ.4 documentation.
#' @param llab A function that takes the data and returns a string for the legend label.
#' @param labels A flag indicating wether to plot labels.
#' @param low A string specifying the color for negative values.
#' @param mid A string specifying the color for no change.
#' @param high A string specifying the color for positive values.
#' @param switch A flag indicating whether to switch the high and low color values.
#' @export
map_estimates_pngs <- function(
  data = cccharts::precipitation, by = NULL, station = FALSE, nrow = NULL,
  map = cccharts::bc, proj4string = "+init=epsg:3005", width = 500L, height = 425L,
  ask = TRUE, dir = NULL, limits = NULL, llab = ylab_trend, labels = TRUE,
  low = "blue", mid = "yellow", high = "red", switch = FALSE) {

  test_estimate_data(data)
  check_flag(station)
  check_flag(ask)
  check_flag(switch)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  dir <- file.path("cccharts", "map", dir)

  data %<>% complete_estimate_data()

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (is.null(limits)) limits <- get_limits(data)
  if (is.null(by)) by <- get_by(data, c("Ecoprovince", "Station"), facet)

  if (all(limits > 0)) limits[1] <- 0
  if (all(limits < 0)) limits[2] <- 0

  plyr::ddply(data, by, fun_png, nrow = nrow, station = station, dir = dir,
              width = width, height = height, map = map, proj4string = proj4string, llab = llab,
              limits = limits, labels = labels, low = low, mid = mid, high = high, switch = switch,
              fun = map_estimates)
  invisible(TRUE)
}

