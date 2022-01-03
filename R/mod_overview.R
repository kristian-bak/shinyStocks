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
    shinyjs::useShinyjs(),
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
    ), 
    htmltools::br(),
    fluidRow(
      shinyjs::hidden(
        tagList(
          actionButton(
            inputId = ns("go_load"), 
            label = "Load portfolio"
          )
        )
      )
    ), 
    htmltools::br(),
    fluidRow(
      uiOutput(outputId = ns("panel_analytics"))
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
      df_portfolio = NULL
    )
    
    observeEvent(input$go_show_example, {
      
      react_var$df_portfolio <- dplyr::tribble(
        ~Stock,              ~Ticker, ~Date,        ~Price, ~Stocks, ~Country, ~ETF, ~Type,    ~Cap,
        "Tesla, Inc.",       "TSLA",  "2021-11-15", 1018,   10,      "USA",    "NO", "Growth", "Large",
        "Johnson & Johnson", "JNJ",   "2021-12-14", 168,    50,      "USA",    "NO", "Value",  "Large",
      )
      
    })
    
    observeEvent(input$go_add, {
      
      showModal(
        ui = modalDialog(
          add_stock_modal(ns = ns), 
          easyClose = TRUE
        ),
        session = session
      )
      
    })
    
    observeEvent(input$go_submit, {
      
      df_new_row <- data.frame(
        "Stock"      = input$type_stock, 
        "Ticker"     = input$type_ticker,
        "Date"       = input$date_first_buy,
        "Price"      = input$num_buy_price,
        "Stocks"     = input$num_n_stocks,
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
    
    observe({
      
      if (!is.null(react_var$df_portfolio)) {
        shinyjs::show(id = "go_load")
        output$panel_analytics <- renderUI({
          tabsetPanel(id = ns("panel_analytics"),
                      tabPanel(
                        title = "Geography", 
                        fluidRow(
                          htmltools::br(),
                          column(8, 
                                 plotly::plotlyOutput(outputId = ns("plot_geo"))
                                 )
                        )
                      ),
                      tabPanel(
                        title = "Sector"
                      ),
                      tabPanel(
                        title = "Type"
                      ),
                      tabPanel(
                        title = "ETF"
                      ),
                      tabPanel(
                        title = "Cap"
                      )
          )
        })
      } else {
        shinyjs::hide(id = "go_load")
      }
      
    })
    
    observeEvent(input$go_load, {
      
      df_temp <- react_var$df_portfolio[1, ]
      
      react_var$df_stock <- yahoo::load_data(
        ticker = df_temp %>% dplyr::pull(Ticker), 
        from = df_temp %>% dplyr::pull("Date")
      )
      
    })
    
    output$plot_geo <- plotly::renderPlotly({
      plotly::plot_ly(
        data = react_var$df_portfolio, 
        labels = ~Country, 
        values = ~Stocks, 
        type = "pie")
    })
 
  })
}
    
## To be copied in the UI
# mod_overview_ui("overview_ui_1")
    
## To be copied in the server
# mod_overview_server("overview_ui_1")
