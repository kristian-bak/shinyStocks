#' Vectorized convert to dkk
#' @param from character vector with currencies
#' 
vectorized_convert_to_dkk <- function(from) {
  
  n <- length(from)
  
  y <- rep(NA, n)
  
  for (i in 1:n) {
    
    if (from[i] == "DKK") {
      y[i] <- 1
    } else {
      y[i] <- convert_to_dkk_with_constant(x = 1, currency = from[i])
    }
    
  }
  
  return(y)
  
}