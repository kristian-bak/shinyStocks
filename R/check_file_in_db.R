#' Check file in database
#' @param file path to file
#' @param max_days integer indicating maximum number days allowed before new data load is needed
#' 
check_file_in_db <- function(file, max_days) {
  
  if (!file.exists(file)) {
    return(FALSE)
  }
  
  last_mod_time <- file.mtime(file)
  now <- Sys.time()
  
  difftime(now, last_mod_time, units = "days") %>% 
    as.numeric() %>% 
    {.} <= max_days
  
}