#' Initialize log table
#' 
initialize_log_table <- function() {
  
  file_name_txt <- "shinyStocksLog.txt"
  
  file_txt <- paste0("./data/", file_name_txt)
  
  if (file.exists(file_txt)) {
    return()
  }
  
  df_init <- data.frame(
    Date = as.Date(character(0)),
    Username = character(),
    Portfolio = character(),
    ID = character()
  )
  
  write.table(
    x = df_init, 
    file = file_txt,  
    append = TRUE, 
    quote = FALSE, 
    row.names = FALSE, 
    col.names = TRUE, 
    sep = ";"
  )
  
}