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
      
      react_var$df_portfolio <- load_example_portfolio()
      
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
        "Type"       = input$select_type,
        "Cap"        = input$select_cap
      )
      
      if (is.null(react_var$df_portfolio)) {
        df_portfolio <- NULL
      } else {
        df_portfolio <- react_var$df_portfolio %>% 
          dplyr::select(Stock, Ticker, Date, Price, Stocks, Country, ETF, Type, Cap)
      }
      
      react_var$df_portfolio <- rbind(
        df_portfolio, 
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
        output$panel_analytics <- render_panel_analytics(ns = ns)
      } else {
        shinyjs::hide(id = "go_load")
      }
      
    })
    
    observeEvent(input$go_load, {
      
      df_portfolio <- react_var$df_portfolio
    
      countries <- df_portfolio %>% 
        dplyr::pull(Country) %>% 
        unique()
      
      currencies <- map_country_to_currency(x = countries)
      
      currency_rates <- vectorized_convert_to_dkk(from = currencies)
      
      df_currency <- dplyr::tibble(
        Country = countries, 
        Currency = currencies, 
        Rate = currency_rates
      )
      
      df_portfolio <- df_portfolio %>% 
        dplyr::left_join(df_currency, by = "Country")
      
      react_var$df_marked_value <- vectorized_load_data(
        ticker = df_portfolio$Ticker,
        from = df_portfolio$Date, 
        cbind = TRUE, 
        rate = df_portfolio$Rate * df_portfolio$Stocks
      )
      
      str_ticker <- gsub("\\.|-", "_", df_portfolio$Ticker)
      
      vector_marked_value_today <- react_var$df_marked_value %>% 
        dplyr::filter(Date == max(Date)) %>% 
        dplyr::select(-Date) %>% 
        dplyr::select(str_ticker) %>% 
        convert_data_frame_to_vector() %>% 
        round(1)
      
      df_portfolio$Marked_value <- vector_marked_value_today
      
      react_var$df_portfolio <- df_portfolio
      
      
    })
    
    output$plot_geo <- plotly::renderPlotly({
      
      if (is.null(react_var$df_portfolio$Marked_value)) {
        return()
      }
      
      plotly::plot_ly(
        data = react_var$df_portfolio, 
        labels = ~Country, 
        values = ~Marked_value, 
        type = "pie")
      
    })
    
    observeEvent(input$go_edit, {
      
      shinyWidgets::show_alert(
        title = "Error", 
        text = "This actionButton has no features yet.", 
        type = "error"
      )
      
    })
    
    observeEvent(input$go_copy, {
      
      shinyWidgets::show_alert(
        title = "Error", 
        text = "This actionButton has no features yet.", 
        type = "error"
      )
      
    })
 
  })
}
    
## To be copied in the UI
# mod_overview_ui("overview_ui_1")
    
## To be copied in the server
# mod_overview_server("overview_ui_1")
