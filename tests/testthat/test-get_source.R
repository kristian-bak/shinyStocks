test_that("Test: get_sparindex_source", {
  
  df <- get_sparindex_source()
  
  expect_true(c("Stock", "Ticker", "Skip", "iShares_url") %in% names(df) %>% all())
  
  str_ticker <- df %>% 
    dplyr::filter(grepl("C25", Stock)) %>% 
    dplyr::pull(Ticker)
  
  expect_equal(str_ticker, "SPIC25KL.CO")
  
})
