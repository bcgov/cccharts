.onLoad <- function(libname, pkgname) {
  op <- options()
  # colors from RColorBrewer::brewer.pal(3, "RdYlBu")
  op.cccharts <- list(
    cccharts.low = "#FC8D59",
    cccharts.mid = "#FFFFBF",
    cccharts.high = "#91BFDB")
  toset <- !(names(op.cccharts) %in% names(op))
  if (any(toset)) options(op.cccharts[toset])

  invisible()
}
