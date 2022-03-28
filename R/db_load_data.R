#' Database load data
#' @param ticker ticker code
#' @param from from date
#' @param folder_name name of folder used as database
db_load_data <- function(ticker, from, folder_name = "stocks") {
  
  file_name <- get_file_name(stock_name = ticker, folder_name = folder_name)
  
  if (file.exists(file_name)) {
    
    out <- readRDS(file = file_name)
    
    return(out)
    
  }
  
  obj <- kb.yahoo::load_data(ticker = ticker, from = from)
  
  saveRDS(object = obj, file = file_name)
  
  return(obj)
  
}