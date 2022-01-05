#' Load portfolio modal
#' @param ns namespace
load_portfolio_modal <- function(ns) {
  
  fluidPage(
    fluidRow(
      DT::dataTableOutput(outputId = ns("table_saved_portfolios"))
    ),
    fluidRow(
      actionButton(
        inputId = ns("go_confirm_loading"), 
        label = "Load"
      )
    )
  )
  
}