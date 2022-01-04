#' Convert to dkk with constant
#' @param x numeric vector
#' @param currency currency to convert from ("USD", "EUR" or "SEK")
#' 
convert_to_dkk_with_constant <- function(x, currency) {
  
  if (currency == "USD") {
    ticker <- "DKK=X"
  } else if (currency == "EUR") {
    ticker <- "EURDKK=X"
  } else if (currency == "SEK") {
    ticker <- "SEKDKK=X"
  }
  
  data <- yahoo::load_data(ticker = ticker, from = Sys.Date() - 7)
  
  exchange_rate <- data %>%
    dplyr::filter(Date == max(Date)) %>%
    dplyr::pull(Close)
  
  return(x * exchange_rate)
  
}