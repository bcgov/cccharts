#' Theme
#'
#' ggplot2 theme for cccharts plots
#'
#' @param facet A flag indicating whether to use the theme for facetted graphs.
#' @param map A flag indicating whether to use the theme for maps.
#' @seealso \code{\link[envreportutils]{theme_soe}} and
#'  \code{\link[envreportutils]{theme_soe_facet}}
#' @export
theme_cccharts <- function(facet = FALSE, map = FALSE) {
  if (facet) {
    theme <- envreportutils::theme_soe_facet(base_family = "")
  } else
    theme <- envreportutils::theme_soe(base_family = "")

  theme <- theme_update(
    plot.title = element_text(size = rel(1.2)),
    axis.title.y = element_text(size = 13),
    axis.title.x = element_text(size = 13),
    axis.line = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.y = element_line(),
    panel.border = element_rect(colour = "grey50", fill = NA),
    panel.background = element_rect(colour = "grey50", fill = NA),
    legend.position = ("bottom"),
    legend.direction = ("horizontal"),
    legend.key = element_rect(color = "white", fill = NA))

  if (map) {
    theme <- theme_update(
      panel.grid = element_blank(),
      panel.border = element_blank(),
      panel.background = element_rect(color = "white", fill = NA),
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank()
      )
  }
  theme
}
