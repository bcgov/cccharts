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
map_estimates <- function(
  data, nrow = NULL, station = FALSE, map = cccharts::bc, climits = NULL, labels = TRUE, clab = ylab_trend,
  low = getOption("cccharts.low"), mid = getOption("cccharts.mid"), high = getOption("cccharts.high"),
  insig = "white",
  ecoprovinces = c("Coast and Mountains", "Georgia Depression", "Central Interior",
                   "Southern Interior", "Southern Interior Mountains",
                   "Sub-Boreal Interior", "Boreal Plains", "Taiga Plains",
                   "Northern Boreal Mountains", "British Columbia"),
  bounds = c(0,1,0,1)) {
  test_estimate_data(data)
  data %<>% complete_estimate_data()

  if (station) {
    check_unique(data$Station)
  } else {
    check_unique(data$Ecoprovince)
  }
  check_vector(bounds, c(0,1), min_length = 4, max_length = 4)
  check_vector(ecoprovinces, value = .ecoprovince, min_length = 1)
  if (!is.null(insig)) check_string(insig)

  ecoprovinces %<>% c("Southern Alaska Mountains", "British Columbia") %>% unique()

  if (!inherits(map, "SpatialPolygonsDataFrame"))
    stop("map must be a SpatialPolygonsDataFrame", call. = FALSE)

  if (data$Units[1] %in% c("percent", "Percent")) {
    data %<>% dplyr::mutate_(Estimate = ~Estimate / 100,
                             Lower = ~Lower / 100,
                             Upper = ~Upper / 100)
    if (is.numeric(climits))
      climits %<>% magrittr::divide_by(100)
  }

  map %<>% sp::spTransform(sp::CRS("+init=epsg:3005"))

  map %<>% bound(bounds)

  if (!station) {
    map@data <- as.data.frame(dplyr::bind_cols(
      map@data, dplyr::select_(as.data.frame(rgeos::gCentroid(map, byid = TRUE)),
                               EastingEcoprovince = ~x, NorthingEcoprovince = ~y)))
    map <- map[map@data$Ecoprovince %in% ecoprovinces,,drop = FALSE]
    suppressMessages(polygon <- broom::tidy(map))
    polygon$Ecoprovince <- map@data$Ecoprovince[as.integer(polygon$id)]
    polygon$Ecoprovince %<>% factor(levels = levels(data$Ecoprovince))
    polygon %<>% dplyr::left_join(data, by = "Ecoprovince")
  } else {
    map <- map[map@data$Ecoprovince %in% ecoprovinces,,drop = FALSE]
    map %<>% rmapshaper::ms_dissolve()
    suppressMessages(polygon <- broom::tidy(map))
    data %<>% latlong2eastnorth(projargs = "+init=epsg:3005")
  }
  if (identical(low, high)) mid <- NULL

  gp <- ggplot() +
    coord_equal()

  if (station) {
    gp <- gp + geom_polygon(data = dplyr::filter_(polygon, ~!hole),
                            ggplot2::aes_string(x = "long", y = "lat", group = "group"),
                            fill = "grey75", color = "white") +
         geom_point(data = data, aes_string(x = "Easting", y = "Northing", fill = "Estimate"),
                 size = 5, shape = 21, color = "grey33")

    if (!is.null(insig)) {
      gp <- gp + geom_point(data = dplyr::filter_(data, ~Significant == FALSE),
                              ggplot2::aes_string(x = "Easting", y = "Northing", fill = "Estimate"),
                              fill = insig, color = "black",  size = 5, shape = 21)
    }

    if (is.null(mid)) {
      if (identical(low, high)) {
        gp <- gp + scale_fill_gradient(guide = FALSE, low = low, high = high)
      } else {
        gp <- gp + scale_fill_gradient(limits = climits, labels = get_labels(data),
                                       guide = guide_colourbar(title = clab(data), title.position = "bottom"),
                                       low = low, high = high)      }
    } else {
      gp <- gp + scale_fill_gradient2(limits = climits, labels = get_labels(data),
                                      guide = guide_colourbar(title = clab(data), title.position = "bottom"),
                                      low = low, mid = mid, high = high)
    }
    if (labels) {
      levels(data$Station) <- stringr::str_replace_all(levels(data$Station), " ", "\n")
      gp <- gp + ggrepel::geom_text_repel(data = data, aes_(x = ~Easting, y = ~Northing, label = ~Station),
                                          point.padding = unit(0.4, "lines"), min.segment.length = unit(0.6, "lines"), size = 5)
    }
  } else {
    gp <- gp + geom_polygon(data = dplyr::filter_(polygon, ~!hole),
                            ggplot2::aes_string(x = "long", y = "lat", group = "group", fill = "Estimate"),
                            color = "white")
    if (!is.null(insig)) {
      gp <- gp + geom_polygon(data = dplyr::filter_(polygon, ~!hole & !Significant),
                   ggplot2::aes_string(x = "long", y = "lat", group = "group"),
                   fill = insig, color = "white")
    }
    if (is.null(mid)) {
      gp <- gp + scale_fill_gradient(limits = climits, labels = get_labels(data), low = low,
                                     high = high,
                                     na.value = "grey90",
                                     guide = guide_colourbar(title = clab(data), title.position = "bottom"))
    } else {
      gp <- gp + scale_fill_gradient2(limits = climits, labels = get_labels(data),
                                      low = low, mid = mid, high = high,
                                      na.value = "grey90",
                                      guide = guide_colourbar(title = clab(data), title.position = "bottom"))

    }
    if (labels) {
      data2 <- map@data
      data2$EastingEcoprovince[data2$Ecoprovince == "Coast and Mountains"] <- 700000
      data2$NorthingEcoprovince[data2$Ecoprovince == "Coast and Mountains"] <- 720000
      data2$EastingEcoprovince[data2$Ecoprovince == "Georgia Depression"] <- 1285000
      data2$NorthingEcoprovince[data2$Ecoprovince == "Georgia Depression"] <- 377500
      data2 %<>% dplyr::filter_(~Ecoprovince != "Southern Alaska Mountains")
      data2$Ecoprovince %<>% stringr::str_c(" (", acronym(.),")")
      data2$Ecoprovince %<>% stringr::str_replace("Southern", "S.") %>%
        stringr::str_replace("Sub[-]", "S. ") %>%
        stringr::str_replace("Northern", "N.") %>%
        stringr::str_replace("and", "&")
      data2$Ecoprovince %<>% stringr::str_replace("( )(Mountains|Depression|Plains)", "\n\\2")
      data2$Ecoprovince %<>% stringr::str_replace("(\\(NBM\\)|\\(TP\\)|\\(BP\\)|\\(CI\\)|\\(SIM\\)|\\(SI\\)|\\(SBI\\))", "\n\\1")


      gp <- gp + ggplot2::geom_text(data = data2, aes_(x = ~EastingEcoprovince, y = ~NorthingEcoprovince, label = ~Ecoprovince))
    }
  }

  gp <- gp + theme_cccharts(facet = FALSE, map = TRUE) +
    theme(legend.justification = c(0,0),
          legend.position = c(0,0),
          legend.direction = "vertical",
          legend.background = element_rect(fill = "transparent", colour = NA))
  gp
}

#' Maps PNGs
#'
#' Generates maps of climate indicator data as png files.
#' @inheritParams plot_estimates_pngs
#' @param station A flag indicating whether the plot is for stations or ecoprovinces.
#' @param map A SpatialPolygonsDataFrame object.
#' @param clab A function that takes the data and returns a string for the color legend label.
#' @param labels A flag indicating wether to plot labels.
#' @param bounds A numeric vector of four values between 0 and 1 specifying the start and end of the x-axis bounding box and the start and end of the y-axis bounding box.
#' @param ecoprovinces A character vector specifying the ecoprovince areas to include in the map.
#' @export
map_estimates_pngs <- function(
  data = cccharts::precipitation, by = "Indicator", station = FALSE, nrow = NULL,
  map = cccharts::bc, width = 500L, height = 450L,
  ask = TRUE, dir = NULL, climits = NULL, clab = ylab_trend, labels = TRUE,
  low = getOption("cccharts.low"), mid = getOption("cccharts.mid"), high = getOption("cccharts.high"),
  insig = "white",
  bounds = c(0,1,0,1),
  ecoprovinces = c("Coast and Mountains", "Georgia Depression", "Central Interior",
                   "Southern Interior", "Southern Interior Mountains",
                   "Sub-Boreal Interior", "Boreal Plains", "Taiga Plains",
                   "Northern Boreal Mountains", "British Columbia"),
  prefix = "") {

  test_estimate_data(data)
  check_flag(station)
  check_flag(ask)
  check_vector(bounds, c(0,1), min_length = 4, max_length = 4)
  check_vector(ecoprovinces, value = .ecoprovince, min_length = 1)
  check_vector(by, "", min_length = 1)

  if (is.null(dir)) {
    dir <- deparse(substitute(data)) %>% stringr::str_replace("^\\w+[:]{2,2}", "")
  } else
    check_string(dir)

  if (!abs_path(dir)) {
    dir <- file.path("cccharts", "map", dir)
  }

  data %<>% complete_estimate_data()

  if (ask && !yesno(paste0("Create directory '", dir ,"'"))) return(invisible(FALSE))

  dir.create(dir, recursive = TRUE, showWarnings = FALSE)

  if (is.null(climits)) climits <- get_climits(data, insig)

  data %<>% plyr::dlply(by, fun_png, nrow = nrow, station = station, dir = dir,
                        width = width, height = height, map = map, clab = clab,
                        climits = climits, labels = labels, low = low, mid = mid, high = high,
                        insig = insig,
                        bounds = bounds, ecoprovinces = ecoprovinces,
                        fun = map_estimates, prefix = prefix, by = by, suffix = "map")
  invisible(data)
}
