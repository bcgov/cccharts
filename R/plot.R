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

plot_trends_ecoprovince <- function(data, colrs, dir) {
  stopifnot(length(unique(data$Indicator)) == 1)
  stopifnot(length(unique(data$Statistic)) == 1)
  stopifnot(length(unique(data$Units)) == 1)
  stopifnot(length(unique(data$Years)) == 1)
  stopifnot(length(unique(data$Ecoprovince)) == 1)

  filename <- paste0(data$Indicator[1], " ", data$Statistic[1], " ", data$Ecoprovince[1], ".png")
  filename <- file.path(dir, filename)

  ylab <- paste(data$Units[1], "per", data$Years[1], "years")
  title <- paste(data$Ecoprovince[1], ifelse(data$Ecoprovince[1] == "British Columbia", "", "Ecoprovince"))

  data$Sig <- "NS"
  data$Sig[data$Significance] <- ""

  png(filename = filename, width = 350, height = 500, type = "cairo-png")

  gp <- ggplot(data, aes_(x = ~Season, y = ~Trend)) +
    geom_point(aes_(colour = ~colrs), size = 4) +
    geom_errorbar(aes_(ymax = ~Trend + Uncertainty,
                       ymin = ~Trend - Uncertainty,
                       colour = ~colrs), width = 0.3, size = .5) +
    geom_hline(aes_(yintercept = 0), linetype = 2, colour = "black") +
    scale_y_continuous(name = ylab, limits = c(-40,50), breaks = seq(-40, 50, 10),
                       expand = c(0,0)) +
    ggtitle(title) +
    envreportutils::theme_soe() +
    theme(plot.title = element_text(size = rel(1.2)),
          axis.title.y = element_text(size=13),
          axis.title.x = element_blank(),
          axis.line = element_blank(),
          panel.grid.major.x = element_blank(),
          panel.grid.minor.y = element_line(),
          panel.border = element_rect(colour = "grey50", fill = NA),
          panel.background = element_rect(colour = "grey50", fill = NA),
          legend.position = ("bottom"),
          legend.direction = ("horizontal"),
          plot.margin = unit(c(1,0.1,0,0.5), "lines")) +
    geom_text(aes_(y = ~Trend, label = ~Sig, hjust = 1.2, vjust = 1.8),
              colour = "grey30", size = 2.8, family = "Verdana") +
    scale_colour_manual(name = "", values = colrs,
                        labels = data$Statistic[1])

  print(gp)
  dev.off()
}


#' Plot Data
#'
#' Generates plot of climate indicator data as png files.
#' @param data A data frame of the data to plot
#' @param colrs A string of the palette.
#' @param ask A flag indicating whether to ask before creating the directory
#' @param dir A string of the directory to store the results in.
#' @export
plot_trends <- function(
  data = cci::precipitation, colrs = "#377eb8", ask = getOption("cci.ask", FALSE),
  dir = NULL) {

  test_data(data)
  check_string(colrs)
  check_flag(ask)
  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  plyr::ddply(data, c("Ecoprovince", "Indicator", "Statistic"), plot_trends_ecoprovince, colrs = colrs, dir = dir)

  invisible(TRUE)
}
