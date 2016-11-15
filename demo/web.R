library(cccharts)

plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station", by = c("Indicator", "Statistic", "Season"), width = 250L, height = 300L, ask = FALSE)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), x = "Station", by = "Indicator", geom = "bar", ask = FALSE, dir = "sea_surface_temperature_station", width = 450L)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"), x = "Season", by = "Indicator", facet = "Station", ask = FALSE, width = 500L, height = 500L, dir = "sea_surface_temperature_station", prefix = "Seasonal")

map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.7,0,0.55), ask = FALSE)

map_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), by = "Indicator", station = TRUE, bounds = c(0.1,0.65,0,0.5), dir = "sea_surface_temperature_station", ask = FALSE)
