library(cccharts)

### sea level ####
estimates <- plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station",
                                 width = 500L, height = 500L, ybreaks = seq(-15,15,by = 5),
                                 low = "#8c510a", mid = "#f5f5f5", high = "#2166ac", ask = FALSE)

map <- map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55),
                          width = 500L, height = 500L, low = "#8c510a", mid = "#f5f5f5", high = "#2166ac", ask = FALSE)

sl_estimates <- estimates[[1]] +
  theme(plot.margin = unit(c(13,10,10,0),"mm"))
plot(sl_estimates)

##print map to PNG
png(filename = "cccharts/estimates/sea_level_station/Sea_Level_estimates.png", width = 500, height = 500, units = "px")
sl_estimates
dev.off()

### multiplot sea level map and sea level estimates plots ###
# png(filename = "cccharts/sea_level_station.png", width = 600L, height = 600L, type = get_png_type())
# envreportutils::multiplot(map[[1]], estimates[[1]], cols = 2, widths = c(3,1))
# dev.off()

### SST ####

sea_surface_temperature_station <- dplyr::filter(sea_surface_temperature_station, Season == "Annual")

plot_estimates_pngs(data = sea_surface_temperature_station, x = "Station", geom = "bar", ask = FALSE,
                    width = 600L, height = 500L, low = "#f5f5f5", mid = NULL, high = "#08519c")

# separate Departure Bay and Entrance Island map points
sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Departure Bay"] <- 49.07
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Departure Bay"] <- -123.91

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Entrance Island"] <- 49.25
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Entrance Island"] <- -123.9

# map station points based on Google Map lat/long coordinates
sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Race Rocks"] <- 48.31
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Race Rocks"] <- -123.53

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Amphitrite Point"] <- 48.92
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Amphitrite Point"] <- -125.54

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Kains Island"] <- 50.45
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Kains Island"] <- -128.03

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Pine Island"] <- 50.98
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Pine Island"] <- -127.72

map_estimates_pngs(data = sea_surface_temperature_station, station = TRUE, bounds = c(0.1,0.65,0,0.5),
                   width = 500L, height = 500L, low = "#f5f5f5", mid = NULL, high = "#08519c",ask = FALSE)

plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"),
                    x = "Season", facet = "Station", low = "#6baed6", mid = NULL, high = "#6baed6", ask = FALSE,
                    width = 800L, height = 600L, dir = "sea_surface_temperature_station", prefix = "Seasonal")

### flow timing ####

flow_station_timing <- dplyr::filter(cccharts::flow_station_timing, Term == "Medium")

plot_estimates_pngs(data = flow_station_timing, x = "Station", ybreaks = seq(-10,5,by = 2.5), width = 700L, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

map_estimates_pngs(data = flow_station_timing, station = TRUE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = flow_station_timing, observed = cccharts::flow_station_timing_observed, facet = "Station", free_y = TRUE, width = 600L, ask = FALSE)

plot_fit_pngs(data = flow_station_timing, observed = cccharts::flow_station_timing_observed, by = "Station", width = 300L, height = 300L, xbreaks = seq(1950, 2010,by = 10), ask = FALSE)

### flow discharge ####

flow_station_discharge <- dplyr::filter(cccharts::flow_station_discharge, Season == "Annual", Statistic == "Mean", Term == "Medium")

plot_estimates_pngs(data = flow_station_discharge, x = "Station", low = getOption("cccharts.high"), high = getOption("cccharts.low"), ybreaks = seq(-1,0.5, by = 0.25), ask = FALSE, width = 700L)

map_estimates_pngs(data = flow_station_discharge, station = TRUE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = flow_station_discharge, observed = cccharts::flow_station_discharge_observed, facet = "Station", free_y = TRUE, width = 600L, ask = FALSE)

plot_fit_pngs(data = flow_station_discharge, observed = cccharts::flow_station_discharge_observed, by = "Station", width = 300L, height = 300L, xbreaks = seq(1950, 2010,by = 10), ask = FALSE)

### snow ###

plot_estimates_pngs(data = cccharts::snow, ybreaks = seq(-20,10,by = 5), low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

map_estimates_pngs(data = cccharts::snow, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

### snow station ###

map_estimates_pngs(data = cccharts::snow_station, station = TRUE, labels = FALSE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)

plot_fit_pngs(data = snow_station, observed = cccharts::snow_station_observed, by = c("Indicator", "Station"), width = 300L, height = 300L, xbreaks = seq(1950, 2010,by = 10), ask = FALSE)
