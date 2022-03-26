#' Generate ID
#' 
generate_id <- function() {
  
  l <- sample(x = c(letters, LETTERS), size = 10, replace = TRUE)
  d <- sample(x = 0:9, size = 4, replace = TRUE)
  x <- c(l, d)
  
  z <- sample(x = x, size = length(x), replace = FALSE)
  
  z %>% paste0(collapse = "")
  
}
