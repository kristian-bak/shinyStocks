#' Add stock modal
#' @param ns namespace
add_stock_modal <- function(ns) {
  
  fluidPage(
    fluidRow(
      column(4, 
             textInput(
               inputId = ns("type_stock"), 
               label = "Stock name"
             )
      ),
      column(4, 
             textInput(
               inputId = ns("type_ticker"), 
               label = "Ticker"
             )
      )
    ),
    fluidRow(
      column(4, 
             dateInput(
               inputId = ns("date_first_buy"), 
               label = "First buy day"
             )
      ),
      column(4, 
             numericInput(
               inputId = ns("num_buy_price"), 
               label = "Average buy price", 
               value = NA, 
               min = 0, 
               max = Inf
             )
      ), 
      column(3, 
             numericInput(
               inputId = ns("num_n_stocks"), 
               label = "Number of stocks", 
               value = NA, 
               min = 1, 
               max = Inf, 
               step = 1)
             )
    ),
    fluidRow(
      column(4, 
             selectInput(
               inputId = ns("select_country"), 
               label = "Country", 
               choices = c("USA", "Germany", "Denmark")
             )
      ),
      column(4, 
             selectInput(
               inputId = ns("select_etf"), 
               label = "ETF", 
               choices = c("Yes", "No")
             )
      )
    ),
    fluidRow(
      column(4, 
             selectInput(
               inputId = ns("select_type"), 
               label = "Type", 
               choices = c("Growth", "Value")
             )
      ),
      column(4, 
             selectInput(
               inputId = ns("select_cap"), 
               label = "Market cap", 
               choices = c("Large", "Mid", "Small")
             )
      )
    ),
    fluidRow(
      actionButton(
        inputId = ns("go_submit"), 
        label = "Submit"
      )
    )
  )
  
}