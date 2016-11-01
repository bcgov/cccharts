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

#' Plot Trend Observed
#'
#' Plots trends with observed data.
#'
#' @inheritParams plot_estimates_pngs
#' @param observed The observed data to plot.
#' @param color A string indicating the column to plot by color.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' plot_trend_observed(cccharts::flow_station_timing, cccharts::flow_station_timing_observed,
#'   facet = "Station", nrow = 2)
plot_trend_observed <- function(data, observed, facet, nrow = NULL, color = NULL, limits = NULL,
                                breaks = waiver()) {
  test_trend_data(data)
  test_observed_data(observed)

  observed %<>% dplyr::inner_join(dplyr::select_(data,~-Units), by = c("Indicator", "Statistic", "Season", "Station"))

  if (!is.null(facet)) {
    check_vector(facet, "", min_length = 1, max_length = 2)
    check_cols(data, facet)
  }

  if (data$Units[1] == "percent") {
    stop()
  }

  data %<>% change_period(1L)

  data %<>% add_segment_xyend(observed)

  gp <- ggplot(observed, aes_string(x = "Year", y = "Value")) +
    geom_point(alpha = 1/3) +
    scale_y_continuous(get_ylab_observed(data), labels = get_labels(observed),
                       limits = limits, breaks = breaks) +
    ggtitle(get_title(data)) +
    theme_cccharts()

  if (is.null(color)) {
    gp <- gp + geom_segment(data = data, aes_string(x = "x", xend = "xend", y = "y", yend = "yend"))
  } else {
    gp <- gp + geom_segment(data = data, aes_string(x = "x", xend = "xend", y = "y", yend = "yend", color = color))
  }

  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]))
  }
  gp
}

#' Plot Trend Estimates
#'
#' Plots trend estimates with uncertainty if available.
#'
#' @inheritParams plot_estimates_pngs
#' @return A ggplot2 object.
#' @export
#' @examples
#' plot_estimates(cccharts::precipitation, x = "Season",
#'   facet = "Ecoprovince", nrow = 2)
plot_estimates <- function(data, x, facet = NULL, nrow = NULL, limits = NULL,
                                 breaks = waiver()) {
  test_trend_data(data)

  if (!is.null(facet)) {
    check_vector(facet, "", min_length = 1, max_length = 2)
    check_cols(data, facet)
  }

  if (data$Units[1] == "percent") {
    data %<>% dplyr::mutate_(Estimate = ~Estimate / 100,
                             Lower = ~Lower / 100,
                             Upper = ~Upper / 100)
    if (is.numeric(limits))
      limits %<>% magrittr::divide_by(100)
    if (is.numeric(breaks))
      breaks %<>% magrittr::divide_by(100)
  }

  data$Significant %<>% factor(levels = c(FALSE, TRUE))

  gp <- ggplot(data, aes_string(x = x, y = "Estimate", alpha = "Significant")) +
    geom_point(size = 4) +
    geom_errorbar(aes_string(ymax = "Upper",
                             ymin = "Lower"), width = 0.3, size = 0.5) +
    geom_hline(aes(yintercept = 0), linetype = 2) +
    scale_y_continuous(get_ylab_trend(data), labels = get_labels(data),
                       limits = limits, breaks = breaks) +
    expand_limits(y = 0) +
    ggtitle(get_title(data)) +
    theme_cccharts() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

  if (all(is.na(data$Significant))) {
      gp <- gp + scale_alpha_discrete(range = c(1, 1), drop = TRUE)
  } else
    gp <- gp + scale_alpha_discrete(range = c(0.5, 1), drop = FALSE)

  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]))
  }
  gp
}

#' Map Trend Estimates
#'
#' Maps trend estimates
#'
#' @inheritParams plot_estimates_pngs
#' @param file A string specifying the filename for a geojson file.
#' @param map A SpatialPolygonsDataFrame object.
#' @param proj4string A character string of projection arguments; the arguments must be entered exactly as in the PROJ.4 documentation.
#' @return A ggplot2 object.
#' @export
#' @examples
#' map_trend_estimates(cccharts::glacial)
map_trend_estimates <- function(data, map = cccharts::map, proj4string = "+init=epsg:3005", file = NULL) {
  test_trend_data(data)
  check_unique(data$Ecoprovince)
  check_string(proj4string)

  map %<>% sp::merge(data, by = "Ecoprovince", all.x = TRUE)

  if (!is.null(file)) {
    check_string(file)
    # remove Lat and Long so not confuse geojson_write
    map@data %<>% dplyr::select_(~-Latitude, ~-Longitude)
    geojsonio::geojson_write(map, file = file, precision = 5)
  }
  map %<>% sp::spTransform(sp::CRS(proj4string))
  suppressMessages(polygon <- broom::tidy(map))
  polygon %<>% dplyr::rename_(.dots = list(Ecoprovince = "id"))
  polygon$Ecoprovince %<>% as.integer()
  polygon$Ecoprovince <- levels(data$Ecoprovince)[polygon$Ecoprovince]
  polygon$Ecoprovince %<>% factor(levels = levels(data$Ecoprovince))

  polygon %<>% dplyr::left_join(data, by = "Ecoprovince")

  gp <- ggplot2::ggplot(data = polygon, ggplot2::aes_string(x = "long",
                                                            y = "lat",
                                                            group = "group")) +
    ggplot2::geom_polygon(data = dplyr::filter_(polygon, ~!hole)) +
    ggplot2::geom_polygon(data = dplyr::filter_(polygon, ~hole), fill = "white") +
    theme_cccharts(map = TRUE)
  gp
}

trend_estimates_png <- function(data, x, facet, nrow, dir, limits, breaks, width, height) {

  filename <- get_filename(data, by) %>% paste0(".png")
  filename <- file.path(dir, filename)

  png(filename = filename, width = width, height = height, type = get_png_type())
  gp <- plot_estimates(data, x = x, facet = facet, nrow = nrow, limits = limits, breaks = breaks)
  print(gp)
  dev.off()
}


#' Trend PNGs
#'
#' Generates plots of climate indicator data as png files.
#' @param data A data frame of the data to plot
#' @param x A string of the column to plot on the x-axis.
#' @param by A character vector of the factors to separate plots by.
#' @param facet A string indicating the factor to facet wrap by.
#' @param nrow A count of the number of rows when facet wrapping.
#' @param width A count of the png width in pixels.
#' @param height A count of the png height in pixels.
#' @param ask A flag indicating whether to ask before creating the directory
#' @param dir A string of the directory to store the results in.
#' @param limits A numeric vector of length two providing limits of the scale.
#' @param breaks A numeric vector of positions.
#' @export
plot_estimates_pngs <- function(
  data = cccharts::precipitation, x = NULL, by = NULL, facet = NULL, nrow = NULL, width = 350L, height = 500L,
  ask = TRUE, dir = NULL, limits = NULL, breaks = waiver()) {
  test_trend_data(data)
  check_flag(ask)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
    dir <- file.path("cccharts", dir)
  } else
    check_string(dir)

  data %<>% complete_data()

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (is.null(limits)) limits <- get_limits(data)
  if (is.null(x)) x <- get_x(data)
  if (is.null(by)) by <- get_by(data, x, facet)

  plyr::ddply(data, by, trend_estimates_png, x = x, facet = facet, nrow = nrow, dir = dir, width = width, height = height,
              limits = limits, breaks = breaks)

  invisible(TRUE)
}

#' Theme
#'
#' ggplot2 theme for cccharts plots
#'
#' @param facet A flag indicating whether to use the theme for facetted graphs.
#' @param map A flag indicating whether to use the theme for maps.
#' @seealso \code{\link[envreportutils]{theme_soe}} and
#'  \code{\link[envreportutils]{theme_soe_facet}}
#' @export
theme_cccharts <- function(facet = FALSE, map = FALSE) {
  if (facet) {
    theme <- envreportutils::theme_soe_facet(base_family = "")
  } else
    theme <- envreportutils::theme_soe(base_family = "")

  theme <- ggplot2::theme_update(
    plot.title = element_text(size = rel(1.2)),
    axis.title.y = element_text(size = 13),
    axis.title.x = element_blank(),
    axis.line = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_line(),
    panel.border = element_rect(colour = "grey50", fill = NA),
    panel.background = element_rect(colour = "grey50", fill = NA),
    legend.position = ("bottom"),
    legend.direction = ("horizontal"))

  if (map) {
    theme <- theme_update(
      panel.grid = element_blank(),
      panel.border = element_blank(),
      panel.background = element_rect(color = "white", fill = NA),
      axis.title = element_blank())
  }
  theme
}
