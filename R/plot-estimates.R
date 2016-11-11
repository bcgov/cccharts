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
plot_estimates <- function(data, x, facet = NULL, nrow = NULL, limits = NULL, geom = "point", ci = TRUE,
                           breaks = waiver(), ylab = ylab_trend) {
  test_estimate_data(data)
  data %<>% complete_estimate_data()
  check_all_identical(data$Indicator)

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
  missing_limits <- all(is.na(data$Lower))
  if (!missing_limits) {
    data %<>% inconsistent_significance()
    if (any(data$Inconsistent)) {
      warning(sum(data$Inconsistent), " data points have inconsistent significance and limits", call. = FALSE, immediate. = TRUE)
      data$Lower[data$Inconsistent] <- NA_real_
      data$Upper[data$Inconsistent] <- NA_real_
    }
  }

  data$Significant %<>% factor(levels = c(FALSE, TRUE))

  gp <- ggplot(data, aes_string(x = x, y = "Estimate")) +
    scale_y_continuous(ylab(data), labels = get_labels(data),
                       limits = limits, breaks = breaks)

  if (!ci || missing_limits) {
    if (geom == "point") {
      gp <- gp +  geom_hline(aes(yintercept = 0)) +
        geom_point(size = 4)
    } else {
      gp <- gp +  geom_hline(aes(yintercept = 0)) +
        geom_bar(stat = "identity", position = "identity")
    }
  } else { # with limits
    if (geom == "point") {
      gp <- gp +  geom_hline(aes(yintercept = 0), linetype = 2) +
        geom_errorbar(aes_string(ymax = "Upper", ymin = "Lower", alpha = "Significant"), width = 0.3, size = 0.5) +
        geom_point(size = 4, aes_string(alpha = "Significant"))
    } else { # bar with limits
      gp <- gp +  geom_hline(aes(yintercept = 0)) +
        geom_errorbar(aes_string(ymax = "Upper", ymin = "Lower", alpha = "Significant"), width = 0.3, size = 0.5) +
        geom_bar(stat = "identity", position = "identity", aes_string(alpha = "Significant"))
    }
    gp <- gp + scale_alpha_discrete(range = c(0.5, 1), drop = FALSE)
  }

  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]))
  }
  gp <- gp + theme_cccharts(facet = !is.null(facet), map = FALSE) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
  gp
}

#' Estimate PNGs
#'
#' Generates plots of climate indicator data as png files.
#' @param data A data frame of the data to plot
#' @param x A string of the column to plot on the x-axis.
#' @param by A character vector of the factors to separate plots by.
#' @param facet A string indicating the factor to facet wrap by.
#' @param nrow A count of the number of rows when facet wrapping.
#' @param geom A string of the geom ("point" or "bar")
#' @param ci A flag indicating whether to plot confidence intervals.
#' @param width A count of the png width in pixels.
#' @param height A count of the png height in pixels.
#' @param ask A flag indicating whether to ask before creating the directory
#' @param dir A string of the directory to store the results in.
#' @param limits A numeric vector of length two providing limits of the scale.
#' @param breaks A numeric vector of positions.
#' @param ylab A function that takes the data and returns a string for the y-axis label.
#' @export
plot_estimates_pngs <- function(
  data = cccharts::precipitation, x = NULL, by = NULL, facet = NULL, nrow = NULL, geom = "point", ci = TRUE, width = 350L, height = 350L,
  ask = TRUE, dir = NULL, limits = NULL, breaks = waiver(), ylab = ylab_trend) {
  test_estimate_data(data)
  check_flag(ask)
  check_scalar(geom, c("^point$", "^bar$", "^point$"))
  check_flag(ci)
  if(!is.function(ylab)) stop("ylab must be a function", call. = FALSE)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  dir <- file.path("cccharts", "estimates", dir)

  data %<>% complete_estimate_data()

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (is.null(limits)) limits <- get_limits(data)
  if (is.null(x)) x <- get_x(data)
  if (is.null(by)) by <- get_by(data, x, facet)

  if (all(limits > 0)) limits[1] <- 0
  if (all(limits < 0)) limits[2] <- 0

  plyr::ddply(data, by, fun_png, x = x, facet = facet, nrow = nrow, geom = geom, ci = ci, dir = dir,
              width = width, height = height, limits = limits, breaks = breaks,
              ylab = ylab,
              fun = plot_estimates)

  invisible(TRUE)
}