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
  } else {
    stop("Only USD, EUR and SEK are supported currencies to convert to DKK. If another currency is needed, then find the relevant ticker code.")
  }
  
  data <- kb.yahoo::load_data(ticker = ticker, from = Sys.Date() - 7)
  
  exchange_rate <- data %>%
    dplyr::filter(Date == max(Date)) %>%
    dplyr::slice(nrow(x = .)) %>% ## Sometimes there can be two rows for the same day
    dplyr::pull(Close)
  
  return(x * exchange_rate)
  
}