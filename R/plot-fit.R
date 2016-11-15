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
#' plot_fit(cccharts::flow_station_timing, cccharts::flow_station_timing_observed,
#'   facet = "Station", nrow = 2)
plot_fit <- function(data, observed, facet = NULL, nrow = NULL, color = NULL, limits = NULL,
                     breaks = waiver(), ylab = ylab_fit) {

  test_estimate_data(data)
  test_observed_data(observed)

  data %<>% complete_estimate_data()
  observed %<>% complete_observed_data()

  check_all_identical(data$Indicator)

  if (data$Units[1] == "percent") {
    data %<>% rescale_data()
    data$Units <- observed$Units[1]
  }
  if (data$Units[1] != observed$Units[1])
    stop("inconsistent units", call. = FALSE)

  suppressMessages(observed %<>% dplyr::inner_join(data))

  if (!is.null(facet)) {
    check_vector(facet, "", min_length = 1, max_length = 2)
    check_cols(data, facet)
  }

  data %<>% change_period(1L)

  data %<>% add_segment_xyend(observed)

  gp <- ggplot(observed, aes_string(x = "Year", y = "Value")) +
    geom_point(alpha = 1/3) +
    scale_y_continuous(ylab(data), labels = get_labels(observed),
                       limits = limits, breaks = breaks)

  if (is.null(color)) {
    gp <- gp + geom_segment(data = data, aes_string(x = "x", xend = "xend", y = "y", yend = "yend"), size = 1.5)
  } else {
    gp <- gp + geom_segment(data = data, aes_string(x = "x", xend = "xend", y = "y", yend = "yend", color = color), size = 1.5) +
      scale_color_manual(values = c("black", "red"))

  }

  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]))
  }
  gp <- gp + theme_cccharts(facet = !is.null(facet), map = FALSE)
  gp
}

#' Fit PNGS
#'
#' @inheritParams plot_estimates_pngs
#' @param observed A data.frame of the observed data.
#' @param color A string indicating the column to plot by color.
#' @export
plot_fit_pngs <- function(
  data = cccharts::precipitation, observed, by = NULL, facet = NULL, nrow = NULL, color = NULL, width = 450L, height = 450L, ask = TRUE, dir = NULL, limits = NULL, breaks = waiver(), ylab = ylab_fit, prefix = "") {

  test_estimate_data(data)
  test_observed_data(observed)
  check_flag(ask)
  if (!is.function(ylab)) stop("ylab must be a function", call. = FALSE)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  dir <- file.path("cccharts", "fit", dir)

  data %<>% complete_estimate_data()
  observed %<>% complete_observed_data()

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  suppressMessages(data %<>% dplyr::semi_join(observed))
  suppressMessages(observed %<>% dplyr::semi_join(data))

  if (is.null(by)) by <- get_by(data, "Year", facet)

  plyr::ddply(data, by, fun_png, observed = observed, facet = facet, nrow = nrow, dir = dir,
              width = width, height = height, limits = limits, breaks = breaks, color = color,
              ylab = ylab,
              fun = plot_fit, prefix = prefix)

  invisible(TRUE)
}
