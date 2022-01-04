#' Map country to currency
#' @param x character vector with countries
#' 
map_country_to_currency <- function(x) {
  
  supported_countries <- c("USA", "Germany", "Denmark", "Sweden")
  
  if (any(!x %in% supported_countries)) {
    stop("Supported countries are: USA, Germany, Denmark and Sweden")
  }
  
  x[x == "USA"]     <- "USD"
  x[x == "Denmark"] <- "DKK"
  x[x == "Germany"] <- "EUR"
  x[x == "Sweden"]  <- "SEK"
  
  return(x)
  
}