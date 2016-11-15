.onLoad <- function(libname, pkgname) {
  op <- options()
  # colors from http://colorbrewer2.org/#type=diverging&scheme=RdYlBu&n=11
  op.cccharts <- list(
    cccharts.low = "#313695",
    cccharts.mid = "#ffffbf",
    cccharts.high = "#a50026")
  toset <- !(names(op.cccharts) %in% names(op))
  if (any(toset)) options(op.cccharts[toset])

  invisible()
}
