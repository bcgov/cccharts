library(cccharts)
library(magrittr)

### sea level ####

## sea level annual estimates map
map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55),
                          width = 500L, height = 500L, low = "#8c510a", mid = "#f5f5f5", high = "#2166ac", ask = FALSE)

## sea level annual estimates plot
estimates.sl <- plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station",
                                 width = 500L, height = 500L, ybreaks = seq(-15,15,by = 5),
                                 low = "#8c510a", mid = "#f5f5f5", high = "#2166ac", ask = FALSE)

## tweaking theme and plotting order of sea level estimates plot

#order <- c("Prince\nRupert", "Victoria", "Vancouver", "Tofino")

estimates.sl[[1]] <- estimates.sl[[1]] +
#  scale_x_discrete(limits = order) +
  theme(plot.margin = unit(c(13,10,10,0),"mm"))
plot(estimates.sl[[1]])

##print sea level estimates plot to PNG
png(filename = "cccharts/estimates/sea_level_station/Sea_Level_estimates.png",
    width = 500, height = 500, units = "px")
estimates.sl[[1]]
dev.off()

### multiplot sea level map and sea level estimates plots ###
# png(filename = "cccharts/sea_level_station.png", width = 600L, height = 600L, type = get_png_type())
# envreportutils::multiplot(map[[1]], estimates[[1]], cols = 2, widths = c(3,1))
# dev.off()


### SST ####

## SST annual estimates plot
sea_surface_temperature_station <- dplyr::filter(sea_surface_temperature_station, Season == "Annual")


estimate_sst <- plot_estimates_pngs(data = sea_surface_temperature_station, x = "Station", geom = "bar", ask = FALSE,
                    width = 520L, height = 500L, low = "#f5f5f5", mid = NULL, high = "#08519c")

## tweaking theme and plotting order of SST annual estimates plot

# sst.order <- c("Entrance\nIsland", "Langara\nIsland", "Race\nRocks", "Pine\nIsland",
#                "Amphitrite\nPoint", "Kains\nIsland", "Departure\nBay")

estimate_sst[[1]] <- estimate_sst[[1]] +
#  scale_x_discrete(limits = sst.order) +
  theme(plot.margin = unit(c(17,10,10,0),"mm"),
        axis.text.x = element_text(size = 12))
plot(estimate_sst[[1]])

##print SST annual estimates to PNG
png(filename = "cccharts/estimates/sea_surface_temperature_station/Sea_Surface_Temperature_estimates.png",
    width = 520, height = 500, units = "px")
estimate_sst[[1]]
dev.off()

## SST seasonal estimates facet plot
plot_estimates_pngs(data = dplyr::filter(cccharts::sea_surface_temperature_station, Season != "Annual"),
                    x = "Season", facet = "Station", low = "#6baed6", mid = NULL, high = "#6baed6", ask = FALSE,
                    width = 800L, height = 600L, dir = "sea_surface_temperature_station", prefix = "Seasonal")

## SST annual estimates map
## separate Departure Bay and Entrance Island map points
sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Departure Bay"] <- 49.07
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Departure Bay"] <- -123.91

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Entrance Island"] <- 49.25
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Entrance Island"] <- -123.9

## map SST station points based on Google Map lat/long coordinates
sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Race Rocks"] <- 48.31
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Race Rocks"] <- -123.53

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Amphitrite Point"] <- 48.92
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Amphitrite Point"] <- -125.54

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Kains Island"] <- 50.45
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Kains Island"] <- -128.03

sea_surface_temperature_station$Latitude[sea_surface_temperature_station$Station == "Pine Island"] <- 50.98
sea_surface_temperature_station$Longitude[sea_surface_temperature_station$Station == "Pine Island"] <- -127.72


## set ggrepel::geom_text_repel() min.segment.length = unit(0.4, "lines") for this map in map-estimates.R
map_estimates_pngs(data = sea_surface_temperature_station, station = TRUE, bounds = c(0.1,0.65,0,0.5),
                   width = 500L, height = 500L, low = "#f5f5f5", mid = NULL, high = "#08519c",ask = FALSE)


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

# plot_estimates_pngs(data = cccharts::snow_station, ybreaks = seq(-20,10,by = 5),
#                     low = "#8c510a", mid = "#f5f5f5", high = "#2166ac",
#                     width = 900L, height = 500L, ask = FALSE)

## snow annual ecoprovince estimates

## Remove CIs for plotting
snow_estimates_data <- dplyr::select(cccharts::snow, -(c(Lower, Upper))) %>%
                  dplyr::arrange(Indicator, Estimate)

snow_estimates_plot <- plot_estimates_pngs(data = snow_estimates_data, ybreaks = seq(-20,10,by = 5), geom = "bar",
                    low = "#8c510a", mid = "#f5f5f5", high = "#2166ac",
                    width = 500L, height = 500L, ask = FALSE)

## Lists for reordering bars by Estimate
depth_order <- c("SI", "CI", "SIM","GD", "BP", "CM",  "SBI", "TP","NBM")
swe_order <- c("SI", "CI", "SIM","GD", "BP", "SBI",  "CM", "TP","NBM")

## reorder bars in plots
snow_estimates_plot[[1]] <- snow_estimates_plot[[1]] +
  scale_x_discrete(limits = depth_order)
plot(snow_estimates_plot[[1]])

snow_estimates_plot[[2]] <- snow_estimates_plot[[2]] +
  scale_x_discrete(limits = swe_order)
plot(snow_estimates_plot[[2]])

## snow annual ecoprovince estimates map
map_estimates_pngs(data = cccharts::snow, low = "#8c510a", mid = "#f5f5f5", high = "#2166ac",
                   width = 500L, height = 550L, ask = FALSE)


### snow station ###
#
# map_estimates_pngs(data = cccharts::snow_station, station = TRUE, labels = FALSE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)
#
# plot_fit_pngs(data = snow_station, observed = cccharts::snow_station_observed, by = c("Indicator", "Station"), width = 300L, height = 300L, xbreaks = seq(1950, 2010,by = 10), ask = FALSE)
