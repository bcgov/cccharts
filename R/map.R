#' Map Ecoprovince
#'
#' @param data The data frame to plot.
#' @param palette A string of the Brewer palette to use.
#' @param breaks A numeric vector of positions.
#' @param breaks
#'
#' @return A SpatialPolygonsDataFrame object.
#' @export
map_ecoprovince <- function(data, palette = "Blues", breaks = NULL) {
  test_data(data)
  check_key(data, "Ecoprovince")
  check_string(palette)

  data %<>% dplyr::filter_(~Ecoprovince != "British Columbia")

  if (is.null(breaks))
    breaks <- get_breaks(data$Trend)

  colors <- c("#979797", RColorBrewer::brewer.pal(length(breaks) + 1, palette)[-1])
  names(colors) <- c("No Data", breaks)

  cut <- cut(data$Trend, breaks = breaks) %>% as.integer() %>% magrittr::add(1)
  data$fillColour <- colors[cut]

  map <- sp::merge(cccharts::map, as.data.frame(data), by = "Ecoprovince", all.x = TRUE)
  map@data$fillColour[is.na(map@data$fillColour)] <- colors["No Data"]

  map
}

plot_ecoprovince <- function(data, palette = "Blues", breaks = NULL) {
  map <- map_ecoprovince(data, palette = palette, breaks = breaks)
  suppressMessages(map %<>% broom::tidy())

  # gp <- ggplot() +
  #   geom_polygon(data = dplyr::filter_(section, ~!hole),
  #                aes_(x = ~long / 1000, y = ~lat / 1000)),
  #     ggplot2::geom_polygon(data = dplyr::filter_(section, ~hole),
  #                           ggplot2::aes_(x = ~long / 1000, y = ~lat / 1000, group = ~group),
  #                           color = "white"))
  #
  map
}
