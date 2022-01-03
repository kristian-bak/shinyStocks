#' overview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_overview_ui <- function(id){
  ns <- NS(id)
  
  fluidPage(
    fluidRow(
      actionButton(
        inputId = ns("go_show_example"), 
        label = "Show example"
      )
    ),
    htmltools::br(),
    fluidRow(
      actionButton(
        inputId = ns("go_add"), 
        label = "Add", 
        icon = icon("plus")
      ),
      actionButton(
        inputId = ns("go_edit"), 
        label = "Edit", 
        icon = icon("edit")
      ),
      actionButton(
        inputId = ns("go_copy"), 
        label = "Copy", 
        icon = icon("copy")
      ),
      actionButton(
        inputId = ns("go_delete"), 
        label = "Delete", 
        icon = icon("trash-alt")
      )
    ), 
    htmltools::br(),
    DT::dataTableOutput(
      outputId = ns("table_portfolio")
    )
  )
}
    
#' overview Server Functions
#'
#' @noRd 
mod_overview_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    react_var <- reactiveValues(
      df_portfolio = data.frame()
    )
    
    observeEvent(input$go_add, {
      
      showModal(
        ui = modalDialog(
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
                       label = "Stock type", 
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
          ), 
          easyClose = TRUE),
        session = session
      )
      
    })
    
    observeEvent(input$go_submit, {
      
      df_new_row <- data.frame(
        "Stock"      = input$type_stock, 
        "Ticker"     = input$type_ticker,
        "Date"       = input$date_first_buy,
        "Price"      = input$num_buy_price,
        "Country"    = input$select_country,
        "ETF"        = input$select_etf,
        "Stock_type" = input$select_type,
        "Cap"        = input$select_cap
      )
      
      react_var$df_portfolio <- rbind(
        react_var$df_portfolio, 
        df_new_row
      )
      
      removeModal()
      
    })
    
    observeEvent(input$go_delete, {
      
      shinyWidgets::ask_confirmation(
        inputId = ns("go_confirm_delete"), 
        title = "Warning", 
        text = "This will permantly delete the table. Do you want to continue?", 
        type = "warning", 
        btn_labels = c("No", "Yes"), 
        btn_colors = c("red", "green"), 
        closeOnClickOutside = TRUE
      )
      
    })
    
    observe({
      
      req(input$go_confirm_delete)
      
      if (input$go_confirm_delete) {
        
        react_var$df_portfolio <- NULL
        
      }
      
    })
    
    output$table_portfolio <- DT::renderDataTable(
      expr = DT::datatable(react_var$df_portfolio, options = list(dom = "t"))
    )
 
  })
}
    
## To be copied in the UI
# mod_overview_ui("overview_ui_1")
    
## To be copied in the server
# mod_overview_server("overview_ui_1")
