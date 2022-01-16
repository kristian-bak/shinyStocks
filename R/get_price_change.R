#' Get price change
#' @param obj object to calculate price change on
#' @export
get_price_change <- function(obj, ...) {
  UseMethod("get_price_change")
}

# Get price change default method
get_price_change.default <- function(obj) {
  
  get_price_change.numeric(obj = obj)
  
}

#' Method for getting price change for data.frame
#' @param obj object
#' @export
#' 
get_price_change.data.frame <- function(obj, var_name) {
  
  x <- obj %>% 
    dplyr::pull(var_name)
  
  get_price_change.numeric(obj = x)
  
}

#' Method for getting price change for numeric vector
#' @param obj object
#' @export
#' 
get_price_change.numeric <- function(obj) {
  
  price_start <- obj[1]
  price_end   <- obj[length(obj)]
  
  price_change <- 100 * ((price_end - price_start) / price_start)
  
  return(round(price_change, digits = 2))
  
}

#' Method for getting price change for integer vector
#' @param obj object
#' @export
get_price_change.integer <- get_price_change.numeric
