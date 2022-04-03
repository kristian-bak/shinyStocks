#' Replace scandinavian letters
#' @param x character vector
#' 
replace_scandinavian_letters <- function(x) {
  
  x <- gsub("ø", "o", x)
  x <- gsub("å", "aa", x)
  x <- gsub("æ", "ae", x)
  
  return(x)
  
}

#' Check if vector contains scandinavian letters
#' @param x character vector
#' 
contains_scandinavian_letters <- function(x) {
  
  any(grepl("æ|ø|å", x))
  
}