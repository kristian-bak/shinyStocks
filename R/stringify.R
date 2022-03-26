#' Stringify
#' @param x character vector with stock name or ticker that should be modified into a string not having any dots, spaces or dashes
#' 
stringify <- function(x) {
  
  gsub("\\.|-| ", "_", x)
  
}