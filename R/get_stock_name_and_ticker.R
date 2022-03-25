#' Get stock name and ticker
#' @export
get_stock_name_and_ticker <- function() {
  
  df <- list()
  
  df[[1]] <- get_stock_name_and_ticker_sparindex()
  df[[2]] <- get_stock_name_and_ticker_ishares()
  df[[3]] <- get_stock_name_and_ticker_danske()
  df[[4]] <- get_stock_name_and_ticker_single_stocks()
  #df[[x]] <- get_stock_name_and_ticker_usa()
  
  df_out <- do.call("rbind", df)
  
  return(df_out)
  
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

#' Get stock name and ticker for danske invest
#' 
get_stock_name_and_ticker_danske <- function() {
  
  get_danske_source() %>% 
    dplyr::select(Stock, Ticker)
  
}


#' Get stock name and ticker for single stocks
#' 
get_stock_name_and_ticker_single_stocks <- function() {
  
  get_single_stock_source() %>% 
    dplyr::select(Stock, Ticker)
  
}

