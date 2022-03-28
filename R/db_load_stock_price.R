#' Database load stock price
#' @param ticker ticker code
#' @param folder_name name of folder used as database
db_load_stock_price <- function(ticker, folder_name = "stocks") {
  
  file_name <- get_file_name(stock_name = ticker)
  
  if (file.exists(file_name)) {
    
    out <- readRDS(file = file_name)
    
    return(out)
    
  }
  
  obj <- kb.yahoo::load_stock_price(ticker = ticker)
  
  saveRDS(object = obj, file = file_name)
  
  return(obj)
  
}