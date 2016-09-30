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

#' Plot Range
#'
#' @param data The data frame to plot.
#' @param x A string of the column to plot on the x-axis.
#' @param limits A numeric vector of length two providing limits of the scale.
#' @param breaks A numeric vector of positions.
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' plot_range(cccharts::precipitation, x = "Season") + facet_wrap(~Ecoprovince)
plot_range <- function(data, x, limits = NULL,
                       breaks = waiver()) {
  test_data(data)

  data$Significant %<>% not_significant()

  if (data$Units[1] == "Percent") {
    data %<>% dplyr::mutate_(Trend = ~Trend / 100,
                             Uncertainty = ~Uncertainty / 100)
    if(is.numeric(limits))
      limits %<>% magrittr::divide_by(100)
    if(is.numeric(breaks))
      breaks %<>% magrittr::divide_by(100)
  }

  ggplot(data, aes_string(x = x, y = "Trend")) +
    geom_point(size = 4) +
    geom_errorbar(aes_string(ymax = "Trend + Uncertainty",
                             ymin = "Trend - Uncertainty"), width = 0.3, size = 0.5) +
    geom_hline(aes(yintercept = 0), linetype = 2) +
    geom_text(aes_(y = ~Trend, label = ~Significant), hjust = 1.2, vjust = 1.8,
              colour = "grey30", size = 2.8) +
    scale_y_continuous(get_ylab(data), labels = get_labels(data),
                       limits = limits, breaks = breaks) +
    expand_limits(y = 0) +
    ggtitle(get_title(data)) +
    theme_cccharts() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
}

range_png <- function(data, x, dir, limits, breaks, width, height) {

  filename <- get_filename(data) %>% paste0(".png")
  filename <- file.path(dir, filename)

  png(filename = filename, width = width, height = height, type = get_png_type())
  gp <- plot_range(data, x = x, limits = limits, breaks = breaks)
  print(gp)
  dev.off()
}


#' Trend PNGs
#'
#' Generates plots of climate indicator data as png files.
#' @param data A data frame of the data to plot
#' @param x A string of the column to plot on the x-axis.
#' @param by A character vector of the columns to separate plots by.
#' @param width A count of the png width in pixels.
#' @param height A count of the png height in pixels.
#' @param ask A flag indicating whether to ask before creating the directory
#' @param dir A string of the directory to store the results in.
#' @param limits A numeric vector of length two providing limits of the scale.
#' @param breaks A numeric vector of positions.
#' @export
trend_pngs <- function(
  data = cccharts::precipitation, x = NULL, by = NULL, width = 350L, height = 500L,
  ask = TRUE, dir = NULL, limits = NULL, breaks = waiver()) {
  test_data(data)
  check_flag(ask)
  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
    dir <- file.path("cccharts", dir)
  } else
    check_string(dir)

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (is.null(limits)) limits <- get_limits(data)
  if (is.null(x)) x <- get_x(data)
  if (is.null(by)) by <- get_by(data, x)

  plyr::ddply(data, by, range_png, x = x, dir = dir, width = width, height = height,
              limits = limits, breaks = breaks)

  invisible(TRUE)
}

#' Theme
#'
#' ggplot2 theme for cccharts plots
#'
#' @export
theme_cccharts <- function() {
  theme_soe(base_family = "") +
    theme(plot.title = element_text(size = rel(1.2)),
          axis.title.y = element_text(size = 13),
          axis.title.x = element_blank(),
          axis.line = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.y = element_line(),
          panel.border = element_rect(colour = "grey50", fill = NA),
          panel.background = element_rect(colour = "grey50", fill = NA),
          legend.position = ("bottom"),
          legend.direction = ("horizontal"))
}
