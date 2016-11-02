library(cccharts)

plot_estimates_pngs(data = cccharts::air_temperature, facet = "Statistic", ask = FALSE)
plot_estimates_pngs(data = dplyr::filter(cccharts::degree_days, Indicator == "Cooling Degree Days"), height = 500L, dir = "degree_days", ask = FALSE)
plot_estimates_pngs(data = dplyr::filter(cccharts::degree_days, Indicator == "Heating Degree Days"), height = 500L, dir = "degree_days", ask = FALSE)
plot_estimates_pngs(data = dplyr::filter(cccharts::degree_days, Indicator == "Growing Degree Days"), height = 500L, dir = "degree_days", ask = FALSE)
plot_estimates_pngs(data = cccharts::flow_station_discharge, facet = c("Statistic", "Term"), height = 500L, ask = FALSE)
plot_estimates_pngs(data = cccharts::flow_station_timing, x = "Station", by = "Statistic", facet = "Term", width = 500L, ask = FALSE)
plot_estimates_pngs(data = cccharts::glacial, geom = "bar", ask = FALSE)
plot_estimates_pngs(data = cccharts::precipitation, x = "Ecoprovince", facet = "Season", geom = "bar", ci = FALSE, height = 500L, width = 500L, ask = FALSE)
plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station", by = c("Indicator", "Statistic", "Season"), width = 200L, height = 300L, ask = FALSE)
plot_estimates_pngs(data = cccharts::sea_surface_temperature_station, x = "Season", by = "Indicator", facet = "Station", ask = FALSE, width = 500L, height = 500L)
plot_estimates_pngs(data = cccharts::snow, ask = FALSE)
plot_estimates_pngs(data = dplyr::filter(cccharts::snow_station, Indicator == "Snow Depth"), x = "Station", by = c("Indicator"), width = 500L, dir = "snow_station", ask = FALSE)
plot_estimates_pngs(data = dplyr::filter(cccharts::snow_station, Indicator == "Snow Water Equivalent"), x = "Station", by = c("Indicator"), width = 700L, dir = "snow_station", ask = FALSE)

plot_fit_pngs(data = cccharts::flow_station_timing, cccharts::flow_station_timing_observed, color = "Term", ask = FALSE)

write_geojson(file = "cccharts/map")
