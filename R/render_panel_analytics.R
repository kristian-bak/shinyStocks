#' Render panel analytics
#' @param ns namespace
#' 
render_panel_analytics <- function(ns) {
  renderUI({
    tabsetPanel(id = ns("panel_analytics"),
                tabPanel(
                  title = "Geography", 
                  fluidRow(
                    htmltools::br(),
                    column(8, 
                           plotly::plotlyOutput(outputId = ns("plot_geo"))
                    )
                  )
                ),
                tabPanel(
                  title = "Sector"
                ),
                tabPanel(
                  title = "Type"
                ),
                tabPanel(
                  title = "ETF"
                ),
                tabPanel(
                  title = "Cap"
                )
    )
  })
}