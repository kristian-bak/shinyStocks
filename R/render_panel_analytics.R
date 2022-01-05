#' Render panel analytics
#' @param ns namespace
#' 
render_panel_analytics <- function(ns) {
  renderUI({
    tabsetPanel(id = ns("panel_analytics"),
                show_panel_analytics(
                  title = "Geography", 
                  outputId = ns("plot_geo")
                ),
                show_panel_analytics(
                  title = "Sector", 
                  outputId = ns("plot_sector")
                ),
                show_panel_analytics(
                  title = "Type", 
                  outputId = ns("plot_type")
                ),
                show_panel_analytics(
                  title = "ETF", 
                  outputId = ns("plot_etf")
                ),
                show_panel_analytics(
                  title = "Cap", 
                  outputId = ns("plot_cap")
                )
    )
  })
}