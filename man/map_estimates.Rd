% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/map-estimates.R
\name{map_estimates}
\alias{map_estimates}
\title{Map Trend Estimates}
\usage{
map_estimates(data, nrow = NULL, station = FALSE, map = cccharts::bc,
  climits = NULL, labels = TRUE, clab = ylab_trend,
  low = getOption("cccharts.low"), mid = getOption("cccharts.mid"),
  high = getOption("cccharts.high"), insig = "white",
  ecoprovinces = c("Coast and Mountains", "Georgia Depression",
  "Central Interior", "Southern Interior", "Southern Interior Mountains",
  "Sub-Boreal Interior", "Boreal Plains", "Taiga Plains",
  "Northern Boreal Mountains", "British Columbia"), bounds = c(0, 1, 0, 1))
}
\arguments{
\item{data}{A data frame of the data to plot}

\item{nrow}{A count of the number of rows when facet wrapping.}

\item{station}{A flag indicating whether the plot is for stations or ecoprovinces.}

\item{map}{A SpatialPolygonsDataFrame object.}

\item{climits}{A character vector of length two providing limits of the color scale.}

\item{labels}{A flag indicating wether to plot labels.}

\item{clab}{A function that takes the data and returns a string for the color legend label.}

\item{low}{A string specifying the color for negative values.}

\item{mid}{A string specifying the color for no change.}

\item{high}{A string specifying the color for positive values.}

\item{insig}{A string specifying the color for insignificant estimates.}

\item{ecoprovinces}{A character vector specifying the ecoprovince areas to include in the map.}

\item{bounds}{A numeric vector of four values between 0 and 1 specifying the start and end of the x-axis bounding box and the start and end of the y-axis bounding box.}
}
\value{
A ggplot2 object.
}
\description{
Maps trend estimates
}
