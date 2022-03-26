#' Get file name
#' @param stock_name stock name
#' 
get_file_name <- function(stock_name) {
  
  str_date <- Sys.Date() %>% 
    gsub("-", "_", x = .)
  
  str_stock_name <- stringify(x = stock_name)
  file_name <- paste0("./data/etf_info/", str_stock_name, "_", str_date, ".RDS")
  
  return(file_name)
  
}