test_that("Test: load_portfolio", {
  
  file_name <- read_log() %>% 
    dplyr::filter(Portfolio == "Danske Bank") %>% 
    dplyr::pull(ID)
  
  df <- load_portfolio(
    file_name = file_name, 
    overwrite_portfolio = TRUE
  )
  
  expect_equal(class(df), "data.frame")
  
  expect_true(all(c("Stock", "Ticker", "Price", "Stocks") %in% names(df)))
  
  df2 <- load_portfolio(
    file_name = file_name, 
    overwrite_portfolio = FALSE, 
    df = df
  )
  
  expect_equal(nrow(df), 6)
  expect_equal(nrow(df2), 12)
  
})
