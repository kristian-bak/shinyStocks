#' Read log
#' 
read_log <- function() {
  
  if (!file.exists("./data/portfolios/shinyStocksLog.txt")) {
    return(NULL)
  }
  
  read.table(file = "./data/portfolios/shinyStocksLog.txt", header = TRUE, sep = ";")
  
}
