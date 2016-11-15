library(cccharts)

### sea level ####
plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station", by = c("Indicator", "Statistic", "Season"), width = 250L, height = 300L, ask = FALSE)

map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55), ask = FALSE)

### SST ####
plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), x = "Station", by = "Indicator", geom = "bar", ask = FALSE, dir = "sea_surface_temperature_station", width = 450L)

map_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), by = "Indicator", station = TRUE, bounds = c(0.1,0.65,0,0.5), dir = "sea_surface_temperature_station", ask = FALSE)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"), x = "Season", by = "Indicator", facet = "Station", ask = FALSE, width = 500L, height = 500L, dir = "sea_surface_temperature_station", prefix = "Seasonal")


### flow ####

plot_estimates_pngs(data = dplyr::filter(cccharts::flow_station_timing, Term == "Medium"), x = "Station", by = "Statistic", width = 600L, low = getOption("cccharts.high"), high = getOption("cccharts.low"), dir = "flow_station_timing", ask = FALSE)

map_estimates_pngs(data = dplyr::filter(cccharts::flow_station_timing, Season == "Annual", Statistic == "Mean", Term == "Medium"), station = TRUE, dir = "flow_station_timing", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = cccharts::flow_station_timing, observed = cccharts::flow_station_timing_observed, color = "Term", facet = "Station", by = "Indicator", ask = FALSE)

