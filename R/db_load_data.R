#' Database load data
#' @param ticker ticker code
#' @param from from date
#' @param folder_name name of folder used as database
#' @param max_days max days since last load (default: 3)
db_load_data <- function(ticker, from, folder_name = "stocks", max_days = 3) {
  
  file_name <- get_file_name(stock_name = ticker, folder_name = folder_name)
  
  if (check_file_in_db(file = file_name, max_days = max_days)) {
    
    out <- readRDS(file = file_name)
    
    return(out)
    
  }
  
  obj <- kb.yahoo::load_data(ticker = ticker, from = from)
  
  saveRDS(object = obj, file = file_name)
  
  return(obj)
  
}