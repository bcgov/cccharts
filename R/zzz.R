.onLoad <- function(libname, pkgname) {
  op <- options()
  # colors from http://colorbrewer2.org/#type=diverging&scheme=RdYlBu&n=11
  op.cccharts <- list(
    cccharts.high = "#a50026",
    cccharts.mid = "#ffffbf",
    cccharts.low = "#313695"
  )
  toset <- !(names(op.cccharts) %in% names(op))
  if (any(toset)) options(op.cccharts[toset])

  invisible()
}
