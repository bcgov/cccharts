.onLoad <- function(libname, pkgname) {
  op <- options()
  # colors from http://colorbrewer2.org/#type=diverging&scheme=BrBG&n=11
  op.cccharts <- list(
    cccharts.high = "#543005",
    cccharts.mid = "#f5f5f5",
    cccharts.low = "#003c30"
  )
  toset <- !(names(op.cccharts) %in% names(op))
  if (any(toset)) options(op.cccharts[toset])

  invisible()
}
