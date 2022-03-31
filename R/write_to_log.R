#' Write to log
#' @param user_name character string with user name
#' @param character sring with portfolio name
#' @param id id used to uniquely identify row in portfolio log 
write_to_log <- function(user_name, portfolio_name, id) {
  
  df_log_new <- data.frame(
    Date = Sys.Date() %>% as.Date(),
    Username = user_name,
    Portfolio = portfolio_name,
    ID = id
  )
  
  file_name_txt <- "shinyStocksLog.txt"
  
  file_txt <- paste0("data/portfolios/", file_name_txt)
  
  write.table(x = df_log_new, file = file_txt,  
              append = TRUE, quote = FALSE, row.names = FALSE, col.names = FALSE, sep = ";")
  
  return(invisible(TRUE))
  
}