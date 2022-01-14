#' Get file name
#' @param stock_name stock name
#' 
get_file_name <- function(stock_name) {
  
  month <- Sys.Date() %>% 
    substring(1, 7) %>% 
    gsub("-", "_", x = .)
  
  str_stock_name <- stringify(x = stock_name)
  file_name <- paste0("./data/etf_info/", str_stock_name, "_", month, ".RDS")
  
  return(file_name)
  
}