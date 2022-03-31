#' Get file name
#' @param stock_name stock name
#' 
get_file_name <- function(stock_name, folder_name = "etf_info") {
  
  str_date <- Sys.Date() %>% 
    gsub("-", "_", x = .)
  
  str_stock_name <- stringify(x = stock_name)
  subfolder <- paste0("./data/", folder_name, "/")
  file_name <- paste0(subfolder, str_stock_name, ".RDS")
  
  return(file_name)
  
}