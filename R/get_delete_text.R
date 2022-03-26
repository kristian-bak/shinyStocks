#' Get delete text
#' @param rows_selected integer vector
get_delete_text <- function(rows_selected) {
  
  n_rows_selected <- length(rows_selected)
  
  if (is.null(rows_selected)) {
    
    str_text <- "This will permantly delete the table. Do you want to continue?"
    
  } else if (n_rows_selected == 1) {
    
    str_text <- paste0("This will permantly delete row ", rows_selected, 
                       ". Do you want to continue? If you wanted to delete the entire table, then press delete without having any rows highlighted")
    
  } else {
    
    rows_selected <- sort(rows_selected)
    
    id <- paste0(rows_selected[1:(n_rows_selected - 1)], collapse = ", ")
    id <- paste0(id, " and ", rows_selected[n_rows_selected])
    
    str_text <- paste0("This will permantly delete the following rows: ", id, 
                       ". Do you want to continue?")
    
  }
  
  return(str_text)
  
}