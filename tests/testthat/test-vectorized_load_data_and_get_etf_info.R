test_that("vectorized_load_data_and_get_etf_info works", {
  
  ticker <- c("NOVO-B.CO", "SPIC25KL.CO")
  stock_name <- c("NOVO", "Sparindex INDEX OMX C25 KL")
  from <- c("2022-03-17", "2022-03-17")
  rate <- c(1, 1)
  
  res1 <- vectorized_load_data_and_get_etf_info(
    ticker = ticker,
    stock_name = stock_name,
    from = from, 
    rate = rate
  )
  
  res2 <- vectorized_load_data_and_get_etf_info(
    ticker = rev(ticker),
    stock_name = rev(stock_name),
    from = from, 
    rate = rate
  )
  
  testthat::expect_true(!is.na(res1$df_marked_value$NOVO_B_CO[1]))
  
  testthat::expect_true(!is.na(res2$df_marked_value$Date[1]))
  
})
