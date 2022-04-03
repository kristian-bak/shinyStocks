#' Database load stock price
#' @param ticker ticker code
#' @param folder_name name of folder used as database
db_load_stock_price <- function(ticker, folder_name = "stocks", max_days = 3) {
  
  file_name <- get_file_name(stock_name = ticker, folder_name = folder_name)
  
  if (check_file_in_db(file = file_name, max_days = max_days)) {
    
    out <- readRDS(file = file_name)
    
    return(out)
    
  }
  
  obj <- kb.yahoo::load_stock_price(ticker = ticker)
  
  saveRDS(object = obj, file = file_name)
  
  return(obj)
  
}