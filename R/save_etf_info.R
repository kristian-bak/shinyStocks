#' Save ETF info
#' @param obj object to save
#' @param stock_name stock name
#' @param max_days max days (i.e. expiry days) before saving again
save_etf_info <- function(obj, stock_name, max_days = 3) {
  
  file_name <- get_file_name(stock_name = stock_name)
  
  if (check_file_in_db(file = file_name, max_days = max_days)) {
    return()
  }
  
  saveRDS(object = obj, file = file_name)
  
}