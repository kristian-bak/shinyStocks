test_that("Test: initialize_log_table + read_log", {
  
  initialize_log_table()
  
  expect_true("shinyStocksLog.txt" %in% list.files("data/portfolios", pattern = ".txt"))
  
  df <- read_log()
  
  cols <- c("Date", "Username", "Portfolio", "ID")
  
  expect_true(all(cols == names(df)))

})
