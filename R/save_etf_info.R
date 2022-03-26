#' Save ETF info
#' @param obj object to save
#' @param stock_name stock name
#' 
save_etf_info <- function(obj, stock_name) {
  
  file_name <- get_file_name(stock_name = stock_name)
  
  if (file.exists(file_name)) {
    return()
  }
  
  saveRDS(object = obj, file = file_name)
  
}