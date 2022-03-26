#' Is blank
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
#' @param x vector of any class
is_blank <- function(x) {
  
  x == ""
  
}

#' Is not blank
#' @param x vector of any class
#' 
is_not_blank <- function(x) {
  
  x != ""
  
}

#' Is not null
#' @param x vector of any class
#' 
is_not_null <- function(x) {
  
  !is.null(x)
  
}
