#' Starts with digit
#' 
starts_with_digit <- function(x) {
  
  z <- substring(x, 1, 1)
  
  grepl("[0-9]", z)
  
}