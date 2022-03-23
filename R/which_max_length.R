#' Which max length
#' 
which.max.length <- function(x) {
  
  id <- nchar(x) %>% which.max()
  
  x[id]
  
}
