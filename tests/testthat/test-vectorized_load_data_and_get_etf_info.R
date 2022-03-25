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
  
  t1a <- Sys.time()
  res3 <- vectorized_load_data_and_get_etf_info(
    ticker = c("SPIC25KL.CO", "SPIC25KL.CO"),
    stock_name = c("Sparindex INDEX OMX C25 KL", "Sparindex INDEX OMX C25 KL"),
    from = from, 
    rate = rate
  )
  t2a <- Sys.time()
  
  tadiff <- as.numeric(t2a - t1a)
  
  t1b <- Sys.time()
  res4 <- vectorized_load_data_and_get_etf_info(
    ticker = "SPIC25KL.CO",
    stock_name = "Sparindex INDEX OMX C25 KL",
    from = from[1], 
    rate = rate[1]
  )
  t2b <- Sys.time()
  
  tbdiff <- as.numeric(t2b - t1b)
  
  ## Loading the same twice should be slower than reusing loads
  testthat::expect_true(tbdiff * 2 > tadiff)
  
})
