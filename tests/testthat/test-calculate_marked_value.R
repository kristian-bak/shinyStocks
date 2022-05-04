test_that("Test: caculate marked value", {
  
  file_name <- read_log() %>% 
    dplyr::filter(Portfolio == "Danske Bank") %>% 
    dplyr::pull(ID)
  
  df_portfolio <- load_portfolio(
    file_name = file_name, 
    overwrite_portfolio = TRUE
  )
  
  df_portfolio <- add_rates(data = df_portfolio)
  
  data_list <- vectorized_load_data_and_get_etf_info(
    ticker         = df_portfolio$Ticker,
    stock_name     = df_portfolio$Stock,
    from           = df_portfolio$Date, 
    rate           = df_portfolio$Rate
  )
  
  df_sector_performance <- get_sector_performance()
  list_geo_performance <- get_geo_and_stock_type_performance()
  
  performance_info <- list("df_sector_performance" = df_sector_performance, 
                           "list_geo_performance"  = list_geo_performance)
  
  out <- calculate_marked_value(
    df_portfolio     = df_portfolio, 
    etf_info         = data_list$etf_list, 
    df_closing_price = data_list$df_closing_price, 
    performance_info = performance_info
  )
  
  expect_equal(c("df_portfolio", "df_holdings", "df_holdings_agg",     
                 "df_sector", "list_benchmark", "df_benchmark_geo",
                 "df_benchmark_sector"), names(out))
  
  expect_equal(class(out$df_portfolio), "data.frame")
  expect_equal(class(out$df_holdings)[1], "tbl_df")
  expect_equal(class(out$df_holdings_agg)[1], "tbl_df")
  expect_equal(class(out$df_sector)[1], "tbl_df")
  expect_equal(class(out$list_benchmark), "list")
  expect_equal(class(out$df_benchmark_geo)[1], "tbl_df")
  expect_equal(class(out$df_benchmark_sector)[1], "tbl_df")
  
  expect_false(any(is.na(out$df_portfolio$Marked_value)))
  expect_false(any(is.na(out$df_holdings_agg$Weight)))
  expect_false(any(is.na(out$df_sector$Marked_value)))
  expect_false(any(is.na(out$df_benchmark_geo$Portfolio)))
  
})
