library(cccharts)

### sea level ####
estimates <- plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station", by = c("Indicator", "Statistic", "Season"), width = 300L, height = 300L, breaks = seq(-15,15,by = 5),
                                 low = "#543005", mid = "#f5f5f5", high = "#053061",ask = FALSE)

map <- map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55),
                          low = "#543005", mid = "#f5f5f5", high = "#053061", ask = FALSE)

# png(filename = "cccharts/sea_level_station.png", width = 800L, height = 800L, type = get_png_type())
# envreportutils::multiplot(map[[1]], estimates[[1]], cols = 2)
# dev.off()

### SST ####
plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), x = "Station", by = "Indicator", geom = "bar", ask = FALSE, dir = "sea_surface_temperature_station", width = 450L)

map_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), by = "Indicator", station = TRUE, bounds = c(0.1,0.65,0,0.5), dir = "sea_surface_temperature_station", ask = FALSE)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"), x = "Season", by = "Indicator", facet = "Station", ask = FALSE, width = 500L, height = 500L, dir = "sea_surface_temperature_station", prefix = "Seasonal")

### flow timing ####

plot_estimates_pngs(data = dplyr::filter(cccharts::flow_station_timing, Term == "Medium"), x = "Station", by = "Statistic", width = 600L, low = getOption("cccharts.high"), high = getOption("cccharts.low"), dir = "flow_station_timing", ask = FALSE)

map_estimates_pngs(data = dplyr::filter(cccharts::flow_station_timing, Season == "Annual", Statistic == "Mean", Term == "Medium"), station = TRUE, dir = "flow_station_timing", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = dplyr::filter(cccharts::flow_station_timing, Term == "Medium"), observed = cccharts::flow_station_timing_observed, facet = "Station", by = "Indicator", dir = "flow_station_timing", ask = FALSE)

### flow discharge ####

plot_estimates_pngs(data = dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Long"), x = "Station", by = "Indicator", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE, dir = "flow_station_discharge")

map_estimates_pngs(data = dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Long"), station = TRUE, dir = "flow_station_discharge", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

# fit for flow discharge
plot_fit_pngs(data = dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Long"), observed = cccharts::flow_station_discharge_observed, facet = "Station", by = "Indicator", dir = "flow_station_discharge", free_y = TRUE, ask = FALSE)

### snow ###

plot_estimates_pngs(data = cccharts::snow, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

map_estimates_pngs(data = cccharts::snow, by = "Indicator", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

# fit for snow...

### snow station ###

plot_estimates_pngs(data = dplyr::filter(cccharts::snow_station, Indicator == "Snow Depth"), x = "Station", by = c("Indicator"), width = 500L, dir = "snow_station", low = getOption("cccharts.high"), high = getOption("cccharts.low"), hjust = 0.5, vjust = 0.5, horizontal = FALSE, ask = FALSE)

plot_estimates_pngs(data = dplyr::filter(cccharts::snow_station, Indicator == "Snow Water Equivalent"), x = "Station", by = c("Indicator"), width = 800L, dir = "snow_station", low = getOption("cccharts.high"), high = getOption("cccharts.low"), hjust = 0.5, vjust = 0.5, horizontal = FALSE, ask = FALSE)

map_estimates_pngs(data = cccharts::snow_station, by = "Indicator", station = TRUE, labels = FALSE, dir = "snow_station", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

# fit for snow station...

### glacial ###

map_estimates_pngs(data = cccharts::glacial, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)
