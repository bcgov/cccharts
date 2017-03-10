library(cccharts)

### SEA LEVEL ####

## sea level annual estimates map
## set ggrepel::geom_text_repel(point.padding = unit(0.4, "lines"), min.segment.length = unit(0.6, "lines")
map_estimates_pngs(data = cccharts::sea_level_station, station = TRUE, bounds = c(0.1,0.65,0,0.55),
                   width = 500L, height = 500L, low = "#8c510a", mid = "#f5f5f5", high = "#2166ac",
                   ask = FALSE, insig = NULL)

## sea level annual estimates plot
estimates.sl <- plot_estimates_pngs(data = cccharts::sea_level_station, x = "Station",
                                 width = 500L, height = 500L, ybreaks = seq(-15,15,by = 5),
                                 low = "#8c510a", mid = "#f5f5f5", high = "#2166ac", ask = FALSE)

## tweaking theme of sea level estimates plot
estimates.sl[[1]] <- estimates.sl[[1]] +
  theme(plot.margin = unit(c(13,10,10,0),"mm"))
plot(estimates.sl[[1]])

## print sea level estimates plot to PNG
png(filename = "cccharts/estimates/sea_level_station/Sea_Level_estimates.png",
    width = 500, height = 500, units = "px")
estimates.sl[[1]]
dev.off()


### SEA SURFACE TEMPERATURE ####

## SST annual estimates plot
sea_surface_temperature_station <- dplyr::filter(sea_surface_temperature_station, Season == "Annual")


estimate_sst <- plot_estimates_pngs(data = sea_surface_temperature_station, x = "Station", geom = "bar", ask = FALSE,
                    width = 520L, height = 500L, low = "#f5f5f5", mid = NULL, high = "#08519c")

## tweaking theme of SST annual estimates plot
estimate_sst[[1]] <- estimate_sst[[1]] +
  theme(plot.margin = unit(c(17,10,10,0),"mm"),
        axis.text.x = element_text(size = 12))
plot(estimate_sst[[1]])

## print SST annual estimates to PNG
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
                   width = 500L, height = 500L, low = "#f5f5f5", mid = NULL, high = "#08519c",ask = FALSE, insig = NULL)


### RIVER FLOW TIMING ####

##100 year timing trend results
flow_station_timing <- dplyr::filter(cccharts::flow_station_timing, Term == "Long")
flow_station_timing <- cccharts::change_period(flow_station_timing, 100L)

## map with points
timing <- map_estimates_pngs(data = flow_station_timing, station = TRUE,
                   low = "#8c510a", high = "#2166ac", ask = FALSE, insig = "grey40")

## add annotation to map
timing[[1]] <- timing[[1]] +
  labs(caption = "*Grey-coloured stations have trend\nestimates that are not significant (NS)")
plot(timing[[1]])

## print out PNG maps
png(filename = "cccharts/map/flow_station_timing/Flow_Timing_map.png",
    width = 500, height = 500, units = "px")
timing[[1]]
dev.off()

# ## estimate plots
# plot_estimates_pngs(data = flow_station_timing, x = "Station",
#                     width = 800L, low = "#3182bd", high = "#3182bd", ask = FALSE)
#
# ## facet of station plots with trends lines
# plot_fit_pngs(data = flow_station_timing, observed = cccharts::flow_station_timing_observed,
#               facet = "Station", free_y = TRUE, width = 600L, ask = FALSE)
#
# ## individual station plots with trend lines
# plot_fit_pngs(data = flow_station_timing, observed = cccharts::flow_station_timing_observed,
#               by = "Station", width = 300L, height = 300L, xbreaks = seq(1900, 2010,by = 20), ask = FALSE)


### RIVER FLOW DISCHARGE ####
plot_river_estimates <- function(
  data, x, facet = NULL, nrow = NULL, ylimits = NULL, climits = NULL, geom = "point",
  low = getOption("cccharts.low"), mid = getOption("cccharts.mid"), high = getOption("cccharts.high"),
  insig = NULL, ybreaks = waiver(), xbreaks = waiver(), ylab = ylab_estimates) {
  # test_estimate_data(data)
  # data %<>% complete_estimate_data()
  cccharts:::check_all_identical(data$Indicator)

  if (!is.null(facet)) {
    check_vector(facet, "", min_length = 1, max_length = 2)
    check_cols(data, facet)
  }
  if (!is.null(insig)) check_string(insig)

  if (data$Units[1] %in% c("percent", "Percent")) {
    data %<>% dplyr::mutate_(Estimate = ~Estimate / 100,
                             Lower = ~Lower / 100,
                             Upper = ~Upper / 100)
    if (is.numeric(ylimits))
      ylimits %<>% magrittr::divide_by(100)
    if (is.numeric(climits))
      climits %<>% magrittr::divide_by(100)
    if (is.numeric(ybreaks))
      ybreaks %<>% magrittr::divide_by(100)
  }

  ci <- any(!is.na(data$Lower))

  # if (ci) {
  #   data %<>% inconsistent_significance()
  #   if (any(data$Inconsistent)) {
  #     warning(sum(data$Inconsistent), " data points have inconsistent significance and confidence limits", call. = FALSE, immediate. = TRUE)
  #   }
  # }

  data$Significant %<>% cccharts:::not_significant()

  if (x == "Ecoprovince") levels(data[[x]]) <- acronym(levels(data[[x]]))
  if (x == "Station") levels(data[[x]]) <- stringr::str_replace_all(levels(data[[x]]), " ", "\n")

  outline <- "grey25"
  if (identical(low, high)) {
    mid <- NULL
    outline <- "grey25"
  }

  gp <- ggplot(data, aes_string(x = x, y = "Estimate")) +
    scale_y_continuous(ylab(data), labels = cccharts:::get_labels(data),
                       limits = ylimits, breaks = ybreaks)

  if (is.vector(xbreaks))
    gp <- gp + scale_x_continuous(breaks = xbreaks)

  if (geom == "point") {
    if (ci) {
      gp <- gp +  geom_errorbar(aes_string(ymax = "Upper", ymin = "Lower"),
                                width = 0.15, size = 0.5, color = outline)
    }
    gp <- gp + geom_hline(aes(yintercept = 0), linetype = 2) +
      geom_point(size = 4, aes_string(fill = "Sign", shape = "Sign"), color = outline) +
      scale_shape_manual(values = c(stable = 21, increase = 24, decrease = 25), guide = "none")
    if (!is.null(insig))
      gp <- gp + geom_point(data = dplyr::filter_(data, ~Significant == "NS"), size = 4, shape = 21, fill = insig, color = outline)
  } else {
    gp <- gp + geom_hline(aes(yintercept = 0)) +
      geom_col(aes_string(fill = "Sign"), color = outline)
    if (!is.null(insig))
      gp <- gp + geom_col(data = dplyr::filter_(data, ~Significant == "NS"), fill = insig, color = outline)
    if (ci) {
      gp <- gp +  geom_errorbar(aes_string(ymax = "Upper", ymin = "Lower"),
                                width = 0.2, size = 0.5, color = outline)
    }
  }

  gp <- gp + geom_text(aes_(y = ~Estimate, label = ~Significant), hjust = 1.2, vjust = 1.8, size = 2.8)

  gp <- gp + scale_fill_manual(values = c(stable = mid, increase = high, decrease = low), guide = FALSE)

  if (length(facet) == 1) {
    gp <- gp + facet_wrap(facet, nrow = nrow)
  } else if (length(facet) == 2) {
    gp <- gp + facet_grid(stringr::str_c(facet[1], " ~ ", facet[2]))
  }
  gp <- gp + theme_cccharts(facet = !is.null(facet), map = FALSE)
  gp
}

library(magrittr)
library(dplyr)
library(cowplot)
ordered_seasons <- c("Annual Mean", "Annual Min", "Annual Max",
                     "Fall Mean", "Winter Mean", "Early Spring Mean",
                     "Late Spring Max", "Early Summer Mean", "Late Summer Min")

# Convert estimate from percent per year to total % change, format seasons
flow_station_discharge <- cccharts::flow_station_discharge %>%
  dplyr::mutate(
    range = EndYear - StartYear,
    Estimate = (Estimate * range) * 100,
    Lower = (Lower * range) * 100,
    Upper = (Upper * range) * 100,
    Season_stat = factor(paste(Season, gsub("imum$", "", Statistic)), levels = ordered_seasons),
    Seasonal = as.factor(ifelse(Season == "Annual", "Annual", "Seasonal")))


## Create y limits (nearest 10 of max and min upper and lower CLs)
ylims <- c(floor(min(flow_station_discharge$Lower, na.rm = TRUE) / 10) * 10,
           ceiling(max(flow_station_discharge$Upper, na.rm = TRUE) / 10) * 10)

rivers_ylab <- function(...) "Change in Flow (%)"

this_theme <- theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
                    plot.margin = unit(c(25, 1, 1, 1), "points"),
                    plot.subtitle = element_text(size = 14),
                    panel.spacing = unit(0, "points"))

out_dir <- "cccharts/estimates/flow_station_discharge/"
dir.create(out_dir, showWarnings = FALSE)

for (s in unique(flow_station_discharge$Station)) {
  med_data <- filter_(flow_station_discharge, ~ Station == s, ~ Term == "Medium")
  stn_name <- tools::toTitleCase(tolower(s))
  stn_id <- flow_station_discharge$station[flow_station_discharge$Station == s][1]

  if (nrow(med_data) == 0) {
    cat("No medium data for ", s, "\n")
    p_med <- NULL
  } else {
    med_mad <- round(med_data$MeanAnnualFlow[med_data$Trend_Type == "Annual Mean"], 1)
    p_med <- plot_river_estimates(med_data, x = "Season_stat", ylimits = ylims,
                                  low = "#a6611a", mid = "#f5f5f5", high = "#018571",
                                  ylab = rivers_ylab) +
    facet_grid(.~Seasonal, scales = "free_x", space = "free_x") +
    this_theme +
    labs(subtitle = paste0(med_data$StartYear[1], " - ", med_data$EndYear[1], "*"),
         caption = bquote("*"~Mean~Annual~Discharge:~.(med_mad)~m^{3}/s))
  }

  long_data <- filter_(flow_station_discharge, ~ Station == s, ~ Term == "Long")
  if (nrow(long_data) == 0) {
    cat("No long data for ", s, "\n")
    p_long <- NULL
  } else {
    long_mad <- round(long_data$MeanAnnualFlow[long_data$Trend_Type == "Annual Mean"], 1)
    p_long <- plot_river_estimates(long_data, x = "Season_stat", ylimits = ylims,
                                 low = "#a6611a", mid = "#f5f5f5", high = "#018571",
                                 ylab = rivers_ylab) +
    facet_grid(.~Seasonal, scales = "free_x", space = "free_x") +
    this_theme +
    labs(subtitle = paste0(long_data$StartYear[1], " - ", long_data$EndYear[1], "*"),
         caption = bquote("*"~Mean~Annual~Discharge:~.(long_mad)~m^{3}/s))
  }
  p <- plot_grid(p_med, p_long, nrow = 2) +
    draw_plot_label(label = stn_name, x = 0.5, y = 1, size = 16, hjust = 0.5)

  if (is.null(p_med)) {
    p <- p + draw_text("No Medium-Term Analysis", y = 0.75, size = 14)
  }

  if (is.null(p_long)) {
    p <- p + draw_text("No Long-Term Analysis", y = 0.25, size = 14)
  }
  png(filename = paste0(out_dir, stn_id, "_discharge.png"),
      width = 350, height = 600, units = "px")
  plot(p)
  dev.off()
}

##100 year timing trend results
##annual
# discharge.mean.annual <- dplyr::filter(flow_station_discharge, Statistic == "Mean",
#                                Season == "Annual", Term == "Long")
#
# discharge.min.annual <- dplyr::filter(flow_station_discharge, Statistic == "Minimum",
#                                       Season == "Annual", Term == "Long")
#
# # discharge.max.annual <- dplyr::filter(flow_station_discharge, Statistic == "Maximum",
# #                                       Season == "Annual", Term == "Long")
# # ##spring
# # discharge.max.spring <- dplyr::filter(flow_station_discharge, Statistic == "Maximum",
# #                                       Season == "Late Spring", Term == "Long")
# #
# # discharge.mean.spring <- dplyr::filter(flow_station_discharge, Statistic == "Mean",
# #                                       Season == "Early Spring", Term == "Long")
# ##summer
# discharge.min.summer <- dplyr::filter(flow_station_discharge,
#                                        Trend_Type == "Summer Mean", Term == "Long")
#
# discharge.mean.summer <- dplyr::filter(flow_station_discharge, Statistic == "Mean",
#                                 Season == "Early Summer", Term == "Long")
# # ##fall and winter
# # discharge.mean.winter <- dplyr::filter(flow_station_discharge, Statistic == "Mean",
# #                                       Season == "Winter", Term == "Long")
# #
# # discharge.mean.fall <- dplyr::filter(flow_station_discharge, Statistic == "Mean",
# #                                       Season == "Fall", Term == "Long")
#
# ## estimate plots
# min.summer <- plot_estimates(data = discharge.min.summer, x = "Station", #low = "#3182bd",
#                     #high = "#3182bd", #ask = FALSE, width = 500L, height = 500L,
#                     ylimits = (c(-75,75)), ybreaks = seq(-75,75,by = 15))
#
# min.annual <- plot_estimates_pngs(data = discharge.min.annual, x = "Station", low = "#3182bd",
#                     high = "#3182bd", ask = FALSE, width = 500L, height = 500L,
#                     ylimits = (c(-75,75)), ybreaks = seq(-75,75,by = 15))
#
# mean.annual <- plot_estimates_pngs(data = discharge.mean.annual, x = "Station", low = "#3182bd",
#                                   high = "#3182bd", ask = FALSE, width = 500L, height = 500L,
#                                   ylimits = (c(-75,75)), ybreaks = seq(-75,75,by = 15))
#
# mean.summer <- plot_estimates_pngs(data = discharge.mean.summer, x = "Station", low = "#3182bd",
#                                    high = "#3182bd", ask = FALSE, width = 500L, height = 500L,
#                                    ylimits = (c(-75,75)), ybreaks = seq(-75,75,by = 15))
#
# ## add titles to plots
# min.summer <- min.summer +
#  ggtitle("Minimum Summer River Flow")
# plot(min.summer)
#
# mean.summer[[1]] <- mean.summer[[1]] +
#   ggtitle("Mean Summer River Flow")
# plot(min.summer[[1]])
#
# min.annual[[1]] <- min.annual[[1]] +
#   ggtitle("Minimum Annual River Flow")
# plot(min.annual[[1]])
#
# mean.annual[[1]] <- mean.annual[[1]] +
#   ggtitle("Mean Annual River Flow")
# plot(mean.annual[[1]])
#
# ## print out PNG plots
# png(filename = "cccharts/estimates/discharge.min.summer/Discharge_MinSummer_estimates.png",
#     width = 500, height = 500, units = "px")
# min.summer[[1]]
# dev.off()
#
# png(filename = "cccharts/estimates/discharge.min.annual/Discharge_MinAnnual_estimates.png",
#     width = 500, height = 500, units = "px")
# min.annual[[1]]
# dev.off()
#
# png(filename = "cccharts/estimates/discharge.mean.summer/Discharge_MeanSummer_estimates.png",
#     width = 500, height = 500, units = "px")
# mean.summer[[1]]
# dev.off()
#
# png(filename = "cccharts/estimates/discharge.mean.annual/Discharge_MeanAnnual_estimates.png",
#     width = 500, height = 500, units = "px")
# mean.annual[[1]]
# dev.off()

# ## facet of station plots with trends lines
# plot_fit_pngs(data = flow_station_discharge, observed = cccharts::flow_station_discharge_observed,
#               facet = "Station", free_y = TRUE, width = 600L, ask = FALSE)
#
# ## individual station plots with trend lines
# plot_fit_pngs(data = flow_station_discharge, observed = cccharts::flow_station_discharge_observed,
# by = "Station", width = 300L, height = 300L, xbreaks = seq(1950, 2010,by = 10), ask = FALSE)
#
# ## map with points
# map_estimates_pngs(data = flow_station_discharge, station = TRUE,
# low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)


### SNOW ###

## snow annual ecoprovince estimates
snow_estimates_plot <- plot_estimates_pngs(data = cccharts::snow, ybreaks = seq(-20,10,by = 5), geom = "bar",
                    low = "#8c510a", high = "#f6e8c3", insig = "grey90",
                    width = 500L, height = 500L, ask = FALSE)

## lists for reordering bars by Estimate
depth_order <- c("SI", "CI", "SIM","GD", "BP", "CM",  "SBI", "TP","NBM")
swe_order <- c("SI", "CI", "SIM","GD", "BP", "SBI",  "CM", "TP","NBM")

## reorder bars in plots
snow_estimates_plot[[1]] <- snow_estimates_plot[[1]] +
  scale_x_discrete(limits = depth_order) +
  theme(plot.margin = unit(c(13,10,10,0),"mm"))
plot(snow_estimates_plot[[1]])

snow_estimates_plot[[2]] <- snow_estimates_plot[[2]] +
  scale_x_discrete(limits = swe_order) +
  theme(plot.margin = unit(c(13,10,10,0),"mm"))
plot(snow_estimates_plot[[2]])

## print out PNG plots
png(filename = "cccharts/estimates/snow/Snow_Depth_estimates.png",
    width = 500, height = 500, units = "px")
snow_estimates_plot[[1]]
dev.off()

png(filename = "cccharts/estimates/snow/Snow_Water_Equivalent_estimates.png",
    width = 500, height = 500, units = "px")
snow_estimates_plot[[2]]
dev.off()

## snow annual ecoprovince estimates map
snow_maps <- map_estimates_pngs(data = cccharts::snow, low = "#8c510a", high = "#f6e8c3",
      width = 500L, height = 500L, ask = FALSE, insig = "grey90")

## add annotation to maps
snow_maps[[1]] <- snow_maps[[1]] +
  labs(caption = "*Grey-shaded ecoprovinces have trend\nestimates that are not significant (NS)")
plot(snow_maps[[1]])

snow_maps[[2]] <- snow_maps[[2]] +
  labs(caption = "*Grey-shaded ecoprovinces have trend\nestimates that are not significant (NS)")
plot(snow_maps[[2]])

## print out PNG maps
png(filename = "cccharts/map/snow/Snow_Depth_map.png",
    width = 500, height = 500, units = "px")
snow_maps[[1]]
dev.off()

png(filename = "cccharts/map/snow/Snow_Water_Equivalent_map.png",
    width = 500, height = 500, units = "px")
snow_maps[[2]]
dev.off()


### SNOW STATION ###
# plot_estimates_pngs(data = cccharts::snow_station, ybreaks = seq(-20,10,by = 5),
#                     low = "#8c510a", mid = "#f5f5f5", high = "#2166ac",
#                     width = 900L, height = 500L, ask = FALSE)
#
# map_estimates_pngs(data = cccharts::snow_station, station = TRUE, labels = FALSE, low = getOption("cccharts.high"), high = getOption("cccharts.low"), ask = FALSE)
#
# plot_fit_pngs(data = snow_station, observed = cccharts::snow_station_observed, by = c("Indicator", "Station"), width = 300L, height = 300L, xbreaks = seq(1950, 2010,by = 10), ask = FALSE)
