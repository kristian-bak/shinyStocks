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
      ),
      shinyjs::hidden(
        tagList(
          actionButton(
            inputId = ns("go_calculate_marked_value"), 
            label = "Calculate marked value", 
            icon = icon("calculator")
          )
        )
      )
    ), 
    shinyBS::bsTooltip(
      id = ns("go_load"), 
      title = "Load stock price, currency rates and ETF info."
    ),
    shinyBS::bsTooltip(
      id = ns("go_calculate_marked_value"), 
      title = "Calculations such as marked value, holdings and exposure across geography and sectors will be made. You can adjust your portfolio by add, edit, delete buttons. Additionally, you can modify the fields in the table, for instance number of stocks, and recalculate marked value."
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
      df_saved_portfolios  = read_log()
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
      
      if (is_blank(input$type_ticker)) {
        
        shinyWidgets::show_alert(
          title = "Error", 
          text = "You must select ticker code", 
          type = "error"
        )
        
        return()
        
      }
      
      if (is.na(input$num_n_stocks)) {
        
        shinyWidgets::show_alert(
          title = "Error", 
          text = "You need to fill out number of stocks", 
          type = "error"
        )
        
        return()
        
      }
      
      if (is_blank(input$select_currency)) {
        
        shinyWidgets::show_alert(
          title = "Error", 
          text = "You must select currency", 
          type = "error"
        )
        
        return()
        
      }
      
      if (is_blank(input$select_etf)) {
        
        shinyWidgets::updatePickerInput(
          session = session, 
          inputId = "select_etf", 
          label = "ETF*"
        )

        return()
        
      }
      
      if (input$select_etf == "No" & is_blank(input$select_sector)) {
        
        shinyWidgets::updatePickerInput(
          session = session, 
          inputId = "select_sector", 
          label = "Sector*"
        )
        
        return()
        
      }
      
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
      
      str_text <- get_delete_text(rows_selected = input$table_portfolio_rows_selected)
      
      shinyWidgets::ask_confirmation(
        inputId = ns("go_confirm_delete"), 
        title = "Warning", 
        text = str_text, 
        type = "warning", 
        btn_labels = c("No", "Yes"), 
        btn_colors = c("red", "green"), 
        closeOnClickOutside = TRUE
      )
      
    })
    
    observeEvent(input$go_confirm_delete, {
      
      if (!input$go_confirm_delete) {
        
        return()
        
      }
      
      if (is.null(input$table_portfolio_rows_selected)) {
        
        react_var$df_portfolio        <- NULL
        react_var$df_holdings         <- NULL
        react_var$df_benchmark_geo    <- NULL
        react_var$df_benchmark_sector <- NULL
        react_var$df_holdings_agg     <- NULL
        react_var$df_sector           <- NULL
        
      } else {
        
        react_var$df_portfolio        <- react_var$df_portfolio[-input$table_portfolio_rows_selected, ]
        #react_var$df_holdings         <- NULL
        #react_var$df_benchmark_geo    <- NULL
        #react_var$df_benchmark_sector <- NULL
        #react_var$df_holdings_agg     <- NULL
        #react_var$df_sector           <- NULL
        
        rownames(react_var$df_portfolio) <- 1:nrow(react_var$df_portfolio)
        
      }
      
    })
    
    observeEvent(input$go_confirm_loading, {
      
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
      
      DT::datatable(
        data = df_portfolio, 
        options = list(scrollX = TRUE), 
        editable = list(target = 'cell')
      )
      
    })
    
    observe({
      
      if (!is.null(react_var$df_portfolio)) {
        shinyjs::show(id = "go_load")
        shinyjs::show(id = "go_save")
        shinyjs::show(id = "go_calculate_marked_value")
        output$panel_analytics <- render_panel_analytics(ns = ns)
      } else {
        shinyjs::hide(id = "go_load")
        shinyjs::hide(id = "go_save")
        shinyjs::hide(id = "go_calculate_marked_value")
      }
      
    })
    
    observeEvent(input$go_load, {
      
      progress <- shiny::Progress$new()
      progress$set(message = "Loading stock data", value = 0)

      on.exit(progress$close())
      
      df_portfolio <- react_var$df_portfolio
      
      n <- nrow(df_portfolio)
      
      ## Important that updateProgress is defined here
      updateProgress <- function(value = NULL, detail = NULL) {
        if (is.null(value)) {
          value <- progress$getValue()
          value <- value + (1 / n)
        }
        progress$set(value = value, detail = detail)
      }

      df_portfolio <- add_rates(data = df_portfolio)
      
      react_var$df_portfolio <- df_portfolio
      
      out <- catch_error(
        vectorized_load_data_and_get_etf_info(
          ticker = df_portfolio$Ticker,
          stock_name = df_portfolio$Stock,
          from = df_portfolio$Date, 
          rate = df_portfolio$Rate, 
          updateProgress = updateProgress
        )
      )
      
      if (is.null(out$error)) {
        
        react_var$df_marked_value <- out$value$df_marked_value
        react_var$etf_info <- out$value$etf_list
        
      } else {
        
        shinyWidgets::show_alert(
          title = "Error", 
          text = "Loading failed for one of the stocks. The error most likely occured because the selected ticker code doesn't exist", 
          type = "error"
        )
        
        browser()
        
        return()
        
      }
      
    })
    
    observeEvent(input$go_calculate_marked_value, {
      
      df_portfolio      <- react_var$df_portfolio
      etf_info          <- react_var$etf_info
      str_ticker        <- stringify(x = df_portfolio$Ticker)
      closing_price_dkk <- react_var$df_marked_value %>% dplyr::select(-Date)
      n_stocks          <- df_portfolio$Stocks
        
      marked_value_today <- sapply(
        X = closing_price_dkk, 
        FUN = get_market_value_today
      ) * n_stocks
      
      total_marked_value <- sum(marked_value_today)
      
      df_portfolio <- df_portfolio %>% 
        dplyr::mutate(Region = map_country_to_region(x = Country),
                      Marked_value = marked_value_today, 
                      Weight = round(Marked_value / total_marked_value, 3))
      
      res <- get_holdings(
        df_portfolio = df_portfolio, 
        etf_info = etf_info
      )
      
      react_var$df_holdings <- res$df_holdings
      react_var$df_holdings_agg <- res$df_holdings_agg
      
      react_var$df_portfolio <- df_portfolio %>% 
        dplyr::select(-Region)
      
      react_var$df_sector <- react_var$df_holdings %>% 
        remove_cash(var = Sector)
      
      react_var$list_benchmark <- load_benchmark_info(
        df_portfolio = df_portfolio, 
        etf_info = etf_info, 
        benchmark_name = "iShares MSCI ACWI UCITS ETF", 
        benchmark_ticker = "IUSQ.DE"
      )
      
      df_benchmark_geo <- compare_with_benchmark_portfolio(
        df_holdings    = react_var$df_holdings, 
        benchmark_info = react_var$list_benchmark$country_info, 
        var = "Region"
      )
      
      names(df_benchmark_geo) <- c("Region", "Portfolio", info_benchmark_col, info_diff_col)
      
      df_benchmark_geo$Region[df_benchmark_geo$Region == "Other"] <- info_region_other
      
      react_var$df_benchmark_geo <- df_benchmark_geo
      
      df_benchmark_sector <- compare_with_benchmark_portfolio(
        df_holdings    = react_var$df_sector, 
        benchmark_info = react_var$list_benchmark$sector_info %>% remove_cash(var = Sector), 
        var = "Sector"
      )
      
      names(df_benchmark_sector) <- c("Sector", "Portfolio", info_benchmark_col, info_diff_col)
      
      react_var$df_benchmark_sector <- df_benchmark_sector
      
    })
    
    output$plot_geo <- plotly::renderPlotly({
      plot_pie_chart(
        data = react_var$df_holdings, 
        labels = "Region"
      )
    })
    
    output$table_benchmark_geo <- formattable::renderFormattable({
      
      if (is.null(react_var$df_benchmark_geo)) {
        return()
      }
      
      formattable::formattable(react_var$df_benchmark_geo, colors_geo)
      
    })
    
    output$table_benchmark_sector <- formattable::renderFormattable({
      
      if (is.null(react_var$df_benchmark_sector)) {
        return()
      }
      
      formattable::formattable(react_var$df_benchmark_sector, colors_sector)
      
    })
    
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
    
    df_portfolio_proxy <- DT::dataTableProxy(
      outputId = 'table_portfolio', 
      session = session
    )
    
    observeEvent(input$table_portfolio_cell_edit, {
      
      info <- input$table_portfolio_cell_edit
      
      react_var$df_portfolio <- DT::editData(react_var$df_portfolio, info)
      
      DT::replaceData(
        proxy = df_portfolio_proxy, 
        data = react_var$df_portfolio, 
        resetPaging = FALSE
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
      
      if (is_not_null(input$table_saved_portfolios_rows_selected) & is_not_blank(input$type_user) & is_not_blank(input$type_portfolio)) {
        shinyWidgets::show_alert(
          title = "Error", 
          text = "Either click on a row and thereby save existing portfolio or fill out user name and portfolio name and save new portfolio", 
          type = "error"
        )
        return()
        
      }
      
      if (is_not_null(input$table_saved_portfolios_rows_selected)) {
        
        df_log <- read_log()
        
        id <- df_log %>% 
          dplyr::slice(input$table_saved_portfolios_rows_selected) %>% 
          dplyr::pull(ID)
        
        update_log(
          df_log = df_log, 
          id = id, 
          new_date = Sys.Date()
        )
        
      } else {
        
        id <- generate_id()
        
        write_to_log(
          user_name = input$type_user, 
          portfolio_name = input$type_portfolio, 
          id = id
        )
        
      }
      
      save_portfolio(df_portfolio = react_var$df_portfolio, id = id)
      
      react_var$df_saved_portfolios <- read_log()
      
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

      if (is.null(row_nr)) {
        
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
      
      n <- length(file_name)
      
      for (i in 1:n) {
        
        f_name <- paste0("./data/", file_name[i], ".rda")
        
        df_portfolio_loaded <- load(file = f_name)
        df_portfolio_loaded <- mget(df_portfolio_loaded)$df_portfolio
        
        if (input$check_overwrite_portfolio) {
          
          react_var$df_portfolio <- df_portfolio_loaded
          
        } else {
          
          react_var$df_portfolio <- rbind(
            react_var$df_portfolio,
            df_portfolio_loaded
          )
          
        }
        
      }
      
      removeModal()
      
    })
    
    output$table_saved_portfolios <- DT::renderDataTable(
      expr = DT::datatable(react_var$df_saved_portfolios, selection = "single")
    )
    
    output$table_holdings <- DT::renderDataTable({
      
      if (is.null(react_var$df_holdings_agg)) {
        return()
      }
      
      ft <- formattable::formattable(react_var$df_holdings_agg)
      
      formattable::as.datatable(ft)
      
    })
    
    observe({
      
      req(input$type_stock)
      
      if (is_etf(input$type_stock)) {
        
        shinyWidgets::updatePickerInput(
          session = session, 
          inputId = "select_etf", 
          selected = "Yes"
        )
        
      } else {
        
        shinyWidgets::updatePickerInput(
          session = session, 
          inputId = "select_etf", 
          selected = "No"
        )
        
        shinyjs::enable(id = "select_country")
        
      }
      
      if (is_sparindex(input$type_stock)) {
        shinyWidgets::updatePickerInput(
          session = session, 
          inputId = "select_currency", 
          selected = "DKK"
        )
      } else {
          shinyWidgets::updatePickerInput(
            session = session, 
            inputId = "select_currency", 
            selected = ""
          )
      }
      
    })
 
  })
}
    
## To be copied in the UI
# mod_overview_ui("overview_ui_1")
    
## To be copied in the server
# mod_overview_server("overview_ui_1")
