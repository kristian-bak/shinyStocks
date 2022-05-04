test_that("Test: get_sector_performance", {
  
  res <- get_sector_performance()
  
  expect_equal(class(res)[1], "tbl_df")
  
  expect_false(
    res$ytd %>% 
      is.na() %>% 
      any()
  )
  
  expect_true(
    "Information Technology" %in% res$Sector
  )
  
})
