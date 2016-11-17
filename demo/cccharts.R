library(cccharts)

### sea level ####
estimates <- plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station", by = c("Indicator", "Statistic", "Season"), width = 300L, height = 300L, breaks = seq(-15,15,by = 5),
                                 low = "#543005", mid = "#f5f5f5", high = "#053061",ask = FALSE)

map <- map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55),
                          low = "#543005", mid = "#f5f5f5", high = "#053061", ask = FALSE)

png(filename = "cccharts/sea_level_station.png", width = 600L, height = 600L, type = get_png_type())
envreportutils::multiplot(map[[1]], estimates[[1]], cols = 2)
dev.off()

### SST ####
plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season == "Annual"), x = "Station", by = "Indicator", geom = "bar", ask = FALSE, dir = "sea_surface_temperature_station", width = 450L)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"), x = "Season", by = "Indicator", facet = "Station", ask = FALSE, width = 600L, height = 500L, dir = "sea_surface_temperature_station", prefix = "Seasonal")

sst <- cccharts::sea_surface_temperature_station

# hack to separate Departure Bay and Entrance Island map points
sst$Latitude[sst$Station == "Departure Bay"] <- 49
sst$Latitude[sst$Station == "Entrance Island"] <- 49.2

map_estimates_pngs(data = dplyr::filter(sst, Season == "Annual"), by = "Indicator", station = TRUE, bounds = c(0.1,0.65,0,0.5), dir = "sea_surface_temperature_station", ask = FALSE)


### flow timing ####

plot_estimates_pngs(data = dplyr::filter(cccharts::flow_station_timing, Term == "Medium"), x = "Station", by = "Statistic", breaks = seq(-10,5,by = 2.5), width = 700L, low = getOption("cccharts.high"), high = getOption("cccharts.low"), dir = "flow_station_timing", ask = FALSE)

map_estimates_pngs(data = dplyr::filter(cccharts::flow_station_timing, Season == "Annual", Statistic == "Mean", Term == "Medium"), station = TRUE, dir = "flow_station_timing", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = dplyr::filter(cccharts::flow_station_timing, Term == "Medium"), observed = cccharts::flow_station_timing_observed, facet = "Station", by = "Indicator", free_y = TRUE, width = 600L, dir = "flow_station_timing", ask = FALSE)

### flow discharge ####

plot_estimates_pngs(data = dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Medium"), x = "Station", by = "Indicator", low = getOption("cccharts.high"), high = getOption("cccharts.low"), breaks = seq(-1,0.5, by = 0.25), ask = FALSE, width = 700L, dir = "flow_station_discharge")

map_estimates_pngs(data = dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Medium"), station = TRUE, dir = "flow_station_discharge", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

# fit for flow discharge
plot_fit_pngs(data = dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Medium"), observed = cccharts::flow_station_discharge_observed, facet = "Station", by = "Indicator", dir = "flow_station_discharge", free_y = TRUE, width = 600L, ask = FALSE)

### snow ###

plot_estimates_pngs(data = dplyr::filter(cccharts::snow, Indicator == "Snow Depth"), dir = "snow", breaks = seq(-20,10,by = 5), low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

map_estimates_pngs(data = dplyr::filter(cccharts::snow, Indicator == "Snow Depth"), by = "Indicator", low = getOption("cccharts.high"), high = getOption("cccharts.low"), dir = "snow", ask = FALSE)

### snow station ###

map_estimates_pngs(data = dplyr::filter(cccharts::snow_station, Indicator == "Snow Depth"), by = "Indicator", station = TRUE, labels = FALSE, dir = "snow_station", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = dplyr::filter(cccharts::snow_station, Indicator == "Snow Depth"), observed = cccharts::snow_station_observed, by = "Station", dir = "snow_station", width = 400L, height = 400L, ask = FALSE)
