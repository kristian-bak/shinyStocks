#' Add stock modal
#' @param ns namespace
add_stock_modal <- function(ns) {
  
  fluidPage(
    fluidRow(
      column(4, 
             selectizeInput(
               inputId = ns("type_stock"), 
               label = "Stock name", 
               choices = c("", NULL),
               options = list(create = TRUE)
             )
      ),
      column(4, 
             selectizeInput(
               inputId = ns("type_ticker"), 
               label = "Ticker", 
               choices = c("", NULL),
               options = list(create = TRUE)
             )
      )
    ),
    fluidRow(
      column(4, 
             dateInput(
               inputId = ns("date_first_buy"), 
               label = "First buy day", 
               value = Sys.Date() - 5
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
               choices = c("", "USA", "Germany", "Denmark", "Sweden")
             )
      ),
      column(4, 
             selectInput(
               inputId = ns("select_currency"), 
               label = "Currency", 
               choices = c("", "USD", "EUR", "DKK", "SEK")
             )
      ),
      column(4, 
             selectInput(
               inputId = ns("select_etf"), 
               label = "ETF", 
               choices = c("Yes", "No")
             )
      ),
      column(4, 
             shinyWidgets::pickerInput(
               inputId = ns("select_sector"), 
               label = "Sector", 
               choices = c("", "Energy", "Materials", "Industrials", 
                           "Utilities", "Health care", "Financials", 
                           "Consumer Discretionary", "Consumer Staples", 
                           "Information Technology", "Communication Services", 
                           "Real Estate")
             )
      )
    ),
    fluidRow(
      column(4, 
             selectInput(
               inputId = ns("select_type"), 
               label = "Type", 
               choices = c("Growth", "Value", "Blend")
             )
      ),
      column(4, 
             selectInput(
               inputId = ns("select_cap"), 
               label = "Market cap", 
               choices = c("Large", "Mid", "Small")
             )
      ),
      column(4, 
             selectInput(
               inputId = ns("select_broker"), 
               label = "Broker", 
               choices = c("", "Danske Bank", "Saxo Bank", "Nordnet", "Other")
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