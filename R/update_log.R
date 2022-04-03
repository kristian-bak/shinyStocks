#' Update log
#' @param df_log data.frame with log table
#' @param id row that should be updated identified using id
#' @param new_date the new date used when updating the date column
update_log <- function(df_log, id, new_date) {
  
  df_log_new <- df_log %>% 
    dplyr::mutate(Date = dplyr::if_else(ID == id, as.character(new_date), Date))
                  
  file_name_txt <- "shinyStocksLog.txt"
  
  file_txt <- paste0("data/portfolios/", file_name_txt)
  
  write.table(x = df_log_new, file = file_txt,  
              append = FALSE, quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ";")
  
  return(invisible(TRUE))

}
