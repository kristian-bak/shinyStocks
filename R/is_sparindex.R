#' Is sparindex
#' @param stock_name character vector with stock names
#'
is_sparindex <- function(stock_name) {
  
  stock_name <- tolower(stock_name)
  
  ifelse(grepl("sparindex", stock_name), TRUE, FALSE)
  
}

#' Is ETF
#' @param stock_name character vector with stock names
#'
is_etf <- function(stock_name) {
  
  stock_name <- tolower(stock_name)
  
  ifelse(grepl("sparindex|ishares|danske invest", stock_name), TRUE, FALSE)
  
}