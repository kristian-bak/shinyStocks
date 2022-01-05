#' Get saved portfolios
#' 
get_saved_portfolios <- function() {
  
  if (!file.exists("./data/shinyStocksLog.txt")) {
    return(NULL)
  }
  
  read.table(file = "./data/shinyStocksLog.txt", header = TRUE, sep = ";")
  
}
