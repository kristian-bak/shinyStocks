#' Get marked value today
#' @param x numeric vector
#' 
get_market_value_today <- function(x) {
  
  x <- x[!is.na(x)]
  
  y <- x[length(x)] %>% round(1)
  
  if (length(y) == 0) {
    return(NA)
  } else {
    return(y)
  }
  
}