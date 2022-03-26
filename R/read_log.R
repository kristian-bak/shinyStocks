#' Read log
#' 
read_log <- function() {
  
  if (!file.exists("./data/shinyStocksLog.txt")) {
    return(NULL)
  }
  
  read.table(file = "./data/shinyStocksLog.txt", header = TRUE, sep = ";")
  
}
