#' Show panel analytics
#' @param title title of panel
#' @param outputId outputId of plotly object
#' 
show_panel_analytics <- function(title, outputId) {
  
  tabPanel(
    title = title, 
    fluidRow(
      htmltools::br(),
      column(8, 
             plotly::plotlyOutput(outputId = outputId)
      )
    )
  )
  
}