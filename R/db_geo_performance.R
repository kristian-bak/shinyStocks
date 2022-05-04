#' Database geography performance
#' @param updateProgress updateProgress function
#' @param folder_name name of folder (default is performance)
#' @param max_days integer specifying maximum number of days before data is considered too old
#' 
db_geo_performance <- function(updateProgress = NULL, folder_name = "performance", max_days = 3) {
  
  file_name <- get_file_name(stock_name = "geography", folder_name = "performance")
  
  if (check_file_in_db(file = file_name, max_days = max_days)) {
    
    out <- readRDS(file = file_name)
    
    return(out)
    
  }
  
  obj <- get_geo_and_stock_type_performance(updateProgress = updateProgress)
  
  saveRDS(object = obj, file = file_name)
  
  return(obj)
  
}