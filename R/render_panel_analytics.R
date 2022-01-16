#' Render panel analytics
#' @param ns namespace
#' 
render_panel_analytics <- function(ns) {
  renderUI({
    tabsetPanel(id = ns("panel_analytics"),
                tabPanel(
                  title = "Holdings", 
                  fluidRow(
                    htmltools::br(),
                    column(8, 
                           DT::dataTableOutput(outputId = ns("table_holdings"))
                    )
                  )
                ),
                show_panel_analytics(
                  title = "Geography",
                  table_outputId = ns("table_benchmark_geo"),
                  plotly_outputId = ns("plot_geo")
                ),
                show_panel_analytics(
                  title = "Sector", 
                  table_outputId = ns("table_benchmark_sector"),
                  plotly_outputId = ns("plot_sector")
                ),
                show_panel_analytics(
                  title = "Type", 
                  plotly_outputId = ns("plot_type")
                ),
                show_panel_analytics(
                  title = "ETF", 
                  plotly_outputId = ns("plot_etf")
                ),
                show_panel_analytics(
                  title = "Cap", 
                  plotly_outputId = ns("plot_cap")
                )
    )
  })
}