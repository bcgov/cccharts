library(cccharts)

### sea level ####
estimates <- plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station", by = "Indicator", width = 300L, height = 300L, breaks = seq(-15,15,by = 5), low = "#543005", mid = "#f5f5f5", high = "#053061",ask = FALSE)

map <- map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55), low = "#543005", mid = "#f5f5f5", high = "#053061", ask = FALSE)

png(filename = "cccharts/sea_level_station.png", width = 600L, height = 600L, type = get_png_type())
envreportutils::multiplot(map[[1]], estimates[[1]], cols = 2, widths = c(3,1))
dev.off()

### SST ####

sea_surface_temperature_station <- dplyr::filter(sea_surface_temperature_station, Season == "Annual")

plot_estimates_pngs(data = sea_surface_temperature_station, x = "Station", by = "Indicator", geom = "bar", ask = FALSE, width = 450L)

# hack to separate Departure Bay and Entrance Island map points
sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Departure Bay"] <- 49
sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Entrance Island"] <- 49.2

map_estimates_pngs(data = sea_surface_temperature_station, by = "Indicator", station = TRUE, bounds = c(0.1,0.65,0,0.5), ask = FALSE)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"), x = "Season", by = "Indicator", facet = "Station", ask = FALSE, width = 600L, height = 500L, dir = "sea_surface_temperature_station", prefix = "Seasonal")

### flow timing ####

flow_station_timing <- dplyr::filter(cccharts::flow_station_timing, Term == "Medium")

plot_estimates_pngs(data = flow_station_timing, x = "Station", by = "Indicator", breaks = seq(-10,5,by = 2.5), width = 700L, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

map_estimates_pngs(data = flow_station_timing, station = TRUE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = flow_station_timing, observed = cccharts::flow_station_timing_observed, facet = "Station", by = "Indicator", free_y = TRUE, width = 600L, ask = FALSE)

plot_fit_pngs(data = flow_station_timing, observed = cccharts::flow_station_timing_observed, by = "Station", width = 300L, height = 300L, ask = FALSE)

### flow discharge ####

flow_station_discharge <- dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Medium")

plot_estimates_pngs(data = flow_station_discharge, x = "Station", by = "Indicator", low = getOption("cccharts.high"), high = getOption("cccharts.low"), breaks = seq(-1,0.5, by = 0.25), ask = FALSE, width = 700L)

map_estimates_pngs(data = flow_station_discharge, station = TRUE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = flow_station_discharge, observed = cccharts::flow_station_discharge_observed, facet = "Station", by = "Indicator", free_y = TRUE, width = 600L, ask = FALSE)

plot_fit_pngs(data = flow_station_discharge, observed = cccharts::flow_station_discharge_observed, by = "Station", width = 300L, height = 300L, ask = FALSE)

### snow ###

plot_estimates_pngs(data = cccharts::snow, breaks = seq(-20,10,by = 5), low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

map_estimates_pngs(data = cccharts::snow, by = "Indicator", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

### snow station ###

map_estimates_pngs(data = cccharts::snow_station, by = "Indicator", station = TRUE, labels = FALSE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = snow_station, observed = cccharts::snow_station_observed, by = c("Indicator", "Station"), width = 300L, height = 300L, ask = FALSE)
