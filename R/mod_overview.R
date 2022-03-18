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
      outputId = ns("table_portfolio"), width = 1000
    ) %>% shinycssloaders::withSpinner(type = 4), 
    htmltools::br(),
    fluidRow(
      actionButton(
        inputId = ns("go_load_saved_portfolio"), 
        label = "Load portfolio", 
        icon = icon("spinner")
      ),
      shinyjs::hidden(
        tagList(
          actionButton(
            inputId = ns("go_save"), 
            label = "Save portfolio", 
            icon = icon("save")
          )
        )
      ),
      shinyjs::hidden(
        tagList(
          actionButton(
            inputId = ns("go_load"), 
            label = "Load stock data", 
            icon = icon("spinner")
          )
        )
      )
    ), 
    shinyBS::bsTooltip(
      id = ns("go_load"), 
      title = "The missing values in currency rate and marked value will be replaced with actual data when loading stock data."
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
      df_portfolio         = NULL, 
      df_saved_portfolios  = get_saved_portfolios()
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
    
    react_stock_name <- reactive({
      
      if (is.null(input$type_ticker)) {
        return()
      }
      
      stock_name <- get_stock_name(
        ticker = input$type_ticker, 
        df = df_stocks, 
        shiny = TRUE
      )
      
      if (length(stock_name) == 0) {
        return(input$type_stock)
      } else {
        return(stock_name)
      }
      
    })
    
    observe({
      
      updateSelectizeInput(
        session = session, 
        inputId = "type_stock", 
        choices = react_stock_name()
      )
      
    })
    
    observe({
      
      if (!is.null(input$type_stock) & !is.null(input$type_ticker)) {
        if (input$type_stock == "Danske Bank") {
          #browser()
        }
      }
      
    })
    
    react_ticker <- reactive({
      
      if (is.null(input$type_stock)) {
        return()
      }
      
      ticker <- get_ticker(
        stock_name = input$type_stock, 
        df = df_stocks, 
        shiny = TRUE
      )
      
      if (length(ticker) == 0) {
        return(input$type_ticker)
      } else {
        return(ticker)
      }
      
    })
    
    observe({
      
      updateSelectizeInput(
        session = session, 
        inputId = "type_ticker", 
        choices = react_ticker()
      )
      
    })
    
    observeEvent(input$go_submit, {
      
      df_new_row <- data.frame(
        "Stock"        = input$type_stock, 
        "Ticker"       = input$type_ticker,
        "Date"         = input$date_first_buy,
        "Price"        = input$num_buy_price,
        "Stocks"       = input$num_n_stocks,
        "Country"      = input$select_country,
        "Currency"     = input$select_currency,
        "ETF"          = input$select_etf,
        "Type"         = input$select_type,
        "Sector"       = input$select_sector,
        "Cap"          = input$select_cap,
        "Broker"       = input$select_broker, 
        "Rate"         = NA,
        "Marked_value" = NA,
        "Weight"       = NA
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
        
        react_var$df_portfolio        <- NULL
        react_var$df_holdings         <- NULL
        react_var$df_benchmark_geo    <- NULL
        react_var$df_benchmark_sector <- NULL
        react_var$df_holdings_agg     <- NULL
        react_var$df_sector           <- NULL
        
      }
      
    })
    
    observeEvent(input$go_load_saved_portfolio, {
      
      react_var$df_holdings         <- NULL
      react_var$df_benchmark_geo    <- NULL
      react_var$df_benchmark_sector <- NULL
      react_var$df_holdings_agg     <- NULL
      react_var$df_sector           <- NULL
      
    })
    
    output$table_portfolio <- DT::renderDataTable({
      
      df_portfolio <- react_var$df_portfolio
      
      if (!is.null(react_var$df_portfolio)) {
        
        df_portfolio <- df_portfolio %>% 
          dplyr::mutate(Weight = 100 * Weight)
        
      }
      
      DT::datatable(df_portfolio, 
                    options = list(dom = "t", scrollX = TRUE))
    })
    
    observe({
      
      if (!is.null(react_var$df_portfolio)) {
        shinyjs::show(id = "go_load")
        shinyjs::show(id = "go_save")
        output$panel_analytics <- render_panel_analytics(ns = ns)
      } else {
        shinyjs::hide(id = "go_load")
        shinyjs::hide(id = "go_save")
      }
      
    })
    
    observeEvent(input$go_load, {
      
      progress <- shiny::Progress$new()
      progress$set(message = "Loading stock data", value = 0)

      on.exit(progress$close())
      
      df_portfolio <- react_var$df_portfolio
      
      n <- nrow(df_portfolio)
      
      updateProgress <- function(value = NULL, detail = NULL) {
        if (is.null(value)) {
          value <- progress$getValue()
          value <- value + (1 / n)
        }
        progress$set(value = value, detail = detail)
      }
      
      df_portfolio <- add_rates(data = df_portfolio)
      
      out <- catch_error(
        vectorized_load_data_and_get_etf_info(
          ticker = df_portfolio$Ticker,
          stock_name = df_portfolio$Stock,
          from = df_portfolio$Date, 
          rate = df_portfolio$Rate * df_portfolio$Stocks, 
          updateProgress = updateProgress
        )
      )
      
      if (is.null(out$error)) {
        
        react_var$df_marked_value <- out$value$df_marked_value
        
      } else {
        
        shinyWidgets::show_alert(
          title = "Error", 
          text = "Loading failed for one of the stocks. The error most likely occured because the ticker code doesn't exist. The error can also occur if you selected today as first buy date on a day where the stock marked is still open. ", 
          type = "error"
        )
        
        browser()
        
        return()
        
      }
      
      str_ticker <- stringify(x = df_portfolio$Ticker)
      
      marked_value_today <- sapply(
        X = react_var$df_marked_value %>% dplyr::select(-Date), 
        FUN = get_market_value_today
      )
      
      total_marked_value <- sum(marked_value_today)
      
      df_portfolio <- df_portfolio %>% 
        dplyr::mutate(Region = map_country_to_region(x = Country),
                      Marked_value = marked_value_today, 
                      Weight = round(Marked_value / total_marked_value, 3))
      
      res <- get_holdings(
        df_portfolio = df_portfolio, 
        etf_info = out$value$etf_list
      )
      
      react_var$df_holdings <- res$df_holdings
      react_var$df_holdings_agg <- res$df_holdings_agg
      
      react_var$df_portfolio <- df_portfolio %>% 
        dplyr::select(-Region)
      
      react_var$df_sector <- react_var$df_holdings %>% 
        dplyr::filter(Sector != "Cash and/or Derivatives")
      
      react_var$list_benchmark <- load_benchmark_info(
        df_portfolio = df_portfolio, 
        etf_info = out$value$etf_list
      )
      
      react_var$df_benchmark_geo <- compare_with_benchmark_portfolio(
        df_holdings    = react_var$df_holdings, 
        benchmark_info = react_var$list_benchmark$country_info, 
        var = "Region"
      )
      
      react_var$df_benchmark_sector <- compare_with_benchmark_portfolio(
        df_holdings    = react_var$df_sector, 
        benchmark_info = react_var$list_benchmark$sector_info %>% dplyr::filter(Sector != "Cash and/or Derivatives"), 
        var = "Sector"
      )
      
    })
    
    output$plot_geo <- plotly::renderPlotly({
      plot_pie_chart(
        data = react_var$df_holdings, 
        labels = "Region"
      )
    })
    
    output$table_benchmark_geo <- DT::renderDataTable(
      expr = DT::datatable(react_var$df_benchmark_geo)
    )
    
    output$table_benchmark_sector <- DT::renderDataTable(
      expr = DT::datatable(react_var$df_benchmark_sector)
    )
    
    output$plot_sector <- plotly::renderPlotly({
      plot_pie_chart(
        data = react_var$df_sector, 
        labels = "Sector"
      )
    })
    
    output$plot_type <- plotly::renderPlotly({
      plot_pie_chart(
        data = react_var$df_portfolio, 
        labels = "Type"
      )
    })
    
    output$plot_etf <- plotly::renderPlotly({
      plot_pie_chart(
        data = react_var$df_portfolio, 
        labels = "ETF"
      )
    })
    
    output$plot_cap <- plotly::renderPlotly({
      plot_pie_chart(
        data = react_var$df_portfolio, 
        labels = "Cap"
      )
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
    
    observeEvent(input$go_save, {
      
      showModal(
        ui = modalDialog(
          save_portfolio_modal(ns = ns), 
          easyClose = TRUE
        ),
        session = session
      )
      
      
    })
    
    observeEvent(input$go_confirm_saving, {
      
      initialize_log_table()
      
      ID <- generate_id()
      
      df_log_new <- data.frame(
        Date = Sys.Date() %>% as.Date(),
        Username = input$type_user,
        Portfolio = input$type_portfolio,
        ID = ID
      )
      
      file_name_txt <- "shinyStocksLog.txt"
      
      file_txt <- paste0("./data/", file_name_txt)
      
      write.table(x = df_log_new, file = file_txt,  
                  append = TRUE, quote = FALSE, row.names = FALSE, col.names = FALSE, sep = ";")
      
      file_name_rda <- paste0(ID, ".rda")
      
      file_rda <- paste0("./data/", file_name_rda)
      
      df_portfolio <- react_var$df_portfolio
      
      save(df_portfolio, file = file_rda)
      
      react_var$df_saved_portfolios <- get_saved_portfolios()
      
      removeModal()
      
      shinyWidgets::sendSweetAlert(
        session = session, 
        title = "Success", 
        text = "Your portfolio has been saved in the app. You can select the saved portfolio by using the load portfolio button.", type = "success", 
        closeOnClickOutside = TRUE
      )
      
    })
    
    observeEvent(input$go_load_saved_portfolio, {
      
      if (is.null(react_var$df_saved_portfolios)) {
        shinyWidgets::show_alert(
          title = "Error", 
          text = "You need to save portfolios before you can load them.", 
          type = "error"
        )
        return()
      }
      
      showModal(
        ui = modalDialog(
          load_portfolio_modal(ns = ns), 
          easyClose = TRUE
        ),
        session = session
      )
      
      
    })
    
    observeEvent(input$go_confirm_loading, {
      
      row_nr <- input$table_saved_portfolios_rows_selected
      
      if (is.null(id)) {
        
        shinyWidgets::show_alert(
          title = "Error", 
          text = "Pick a portfolio by clicking a row in the table", 
          type = "error"
        )
        
        return()
        
      }
      
      file_name <- react_var$df_saved_portfolios %>% 
        dplyr::slice(row_nr) %>% 
        dplyr::pull(ID)
      
      file_name <- paste0("./data/", file_name, ".rda")
      
      df_portfolio_loaded <- load(file = file_name)
      df_portfolio_loaded <- mget(df_portfolio_loaded)$df_portfolio
      
      react_var$df_portfolio <- df_portfolio_loaded
      
      removeModal()
      
    })
    
    output$table_saved_portfolios <- DT::renderDataTable(
      expr = DT::datatable(react_var$df_saved_portfolios, options = list(dom = "t"))
    )
    
    output$table_holdings <- DT::renderDataTable(
      expr = DT::datatable(react_var$df_holdings_agg)
    )
 
  })
}
    
## To be copied in the UI
# mod_overview_ui("overview_ui_1")
    
## To be copied in the server
# mod_overview_server("overview_ui_1")
