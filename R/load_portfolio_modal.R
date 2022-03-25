#' Load portfolio modal
#' @param ns namespace
load_portfolio_modal <- function(ns) {
  
  fluidPage(
    fluidRow(
      DT::dataTableOutput(outputId = ns("table_saved_portfolios"))
    ),
    br(),
    fluidRow(
      column(2, 
       actionButton(
         inputId = ns("go_confirm_loading"), 
         label = "Load"
       )
      ),
      column(5, 
       checkboxInput(
         inputId = ns("check_overwrite_portfolio"), 
         label = "Overwrite existing portfolio", 
         value = TRUE
       ), style = "margin-top: -6px"
      )
    )
  )
}