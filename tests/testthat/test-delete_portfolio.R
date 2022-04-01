test_that("Test: delete_portfolio", {
  
  out <- delete_portfolio()
  
  expect_equal(names(out), c("df_portfolio", 
                             "df_holdings",
                             "df_benchmark_geo",
                             "df_benchmark_sector",
                             "df_sector"))
  
})
