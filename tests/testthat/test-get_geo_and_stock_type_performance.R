test_that("Test: get_geo_and_stock_type_performance", {
  
  res <- get_geo_and_stock_type_performance()
  
  expect_equal(names(res), c("df", "df_region", "df_stock_type"))
  
  expect_false(
    res$df_region$ytd %>% 
      is.na() %>% 
      any()
  )
  
  expect_false(
    res$df_stock_type$ytd %>% 
      is.na() %>% 
      any()
  )
  
})
