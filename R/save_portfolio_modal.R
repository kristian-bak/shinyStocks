#' Save portfolio modal
#' @param ns namespace
save_portfolio_modal <- function(ns) {
  
  fluidPage(
    fluidRow(
      h3("Saved portfolios")
    ),
    fluidRow(
      DT::dataTableOutput(outputId = ns("table_saved_portfolios"))
    ),
    fluidRow(
      p("Click on a portfolio and press save in order to overwrite existing portfolio."), 
      p("Enter username and portfolio name to save a new portfolio.")
    ),
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
      ),
      column(4, 
             actionButton(
               inputId = ns("go_confirm_saving"), 
               label = "Save"
             ), 
             style = "margin-top: 25px"
      )
    )
  )
  
}