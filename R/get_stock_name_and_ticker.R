#' Get stock name and ticker
#' @export
get_stock_name_and_ticker <- function() {
  
  rbind(
    get_stock_name_and_ticker_sparindex(),
    get_stock_name_and_ticker_ishares()
    #get_stock_name_and_ticker_usa()
  )
  
}


#' Get stock name and ticker for American stocks
#' 
get_stock_name_and_ticker_usa <- function() {
  
  TTR::stockSymbols() %>% 
    dplyr::select(Name, Symbol) %>% 
    dplyr::rename(Stock = Name, Ticker = Symbol) %>% 
    dplyr::as_tibble()
  
}

#' Get stock name and ticker for Sparindex products
#' 
get_stock_name_and_ticker_sparindex <- function() {
  
  get_sparindex_source() %>% 
    dplyr::select(Stock, Ticker)
  
}

#' Get stock name and ticker for iShares products
#' 
get_stock_name_and_ticker_ishares <- function() {
  
  get_ishares_source() %>% 
    dplyr::select(Stock, Ticker)
  
}

