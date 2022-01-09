#' Map country to currency
#' @param x character vector with countries
#' @param currency optional, if currency is supplied then the currency is simply returned
map_country_to_currency <- function(x, currency = rep(NA, length(x))) {
  
  supported_countries <- c("USA", "Germany", "Denmark", "Sweden")
  
  if (any(!x %in% supported_countries)) {
    stop("Supported countries are: USA, Germany, Denmark and Sweden")
  }
  
  x[x == "USA"]     <- "USD"
  x[x == "Denmark"] <- "DKK"
  x[x == "Germany"] <- "EUR"
  x[x == "Sweden"]  <- "SEK"
  
  ## Apply currency inputs whenever supplied
  x[!is.na(currency)] <- currency[!is.na(currency)]
  
  return(x)
  
}