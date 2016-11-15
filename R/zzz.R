.onLoad <- function(libname, pkgname) {
  op <- options()
  op.cccharts <- list(
    cccharts.low = "blue",
    cccharts.mid = "yellow",
    cccharts.high = "red")
  toset <- !(names(op.cccharts) %in% names(op))
  if (any(toset)) options(op.cccharts[toset])

  invisible()
}
