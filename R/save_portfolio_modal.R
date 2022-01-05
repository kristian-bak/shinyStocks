#' Save portfolio modal
#' @param ns namespace
save_portfolio_modal <- function(ns) {
  
  fluidPage(
    fluidRow(
      column(4, 
             textInput(
               inputId = ns("type_user"), 
               label = "Username"
             )
      ),
      column(4, 
             textInput(
               inputId = ns("type_portfolio"), 
               label = "Portfolio name"
             )
      )
    ),
    fluidRow(
      actionButton(
        inputId = ns("go_confirm_saving"), 
        label = "Save"
      )
    )
  )
  
}