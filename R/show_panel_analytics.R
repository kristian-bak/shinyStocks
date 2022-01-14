#' Show panel analytics
#' @param title title of panel
#' @param table_outputId outputId of DT dataTableOutput object
#' @param plotly_outputId outputId of plotly object
#' 
show_panel_analytics <- function(title, table_outputId = NULL, plotly_outputId) {
  
  tabPanel(
    title = title, 
    fluidRow(
      htmltools::br(),
      column(6, 
             DT::dataTableOutput(outputId = table_outputId)
             ),
      column(6, 
             plotly::plotlyOutput(outputId = plotly_outputId)
      )
    )
  )
  
}