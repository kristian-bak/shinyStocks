#' React on stock input
#' @param df_stocks data.frame with auto filled stock name and ticker codes
#' @param stock_name name of stock
#' @param ticker ticker code
#' @return character string with ticker code based on stock input
#' 
react_on_stock_input <- function(df_stocks, stock_name, ticker) {
  
  if (is.null(stock_name)) {
    return()
  }
  
  str_ticker <- get_ticker(
    stock_name = stock_name, 
    df = df_stocks, 
    shiny = TRUE
  )
  
  if (length(str_ticker) == 0) {
    return(ticker)
  } else {
    return(str_ticker)
  }
  
}

#' React on ticker input
#' @param df_stocks data.frame with auto filled stock name and ticker codes
#' @param stock_name name of stock
#' @param ticker ticker code
#' @return character string with stock name based on ticker input
#' 
react_on_ticker_input <- function(df_stocks, stock_name, ticker) {
  
  if (is.null(ticker)) {
    return()
  }
  
  str_stock_name <- get_stock_name(
    ticker = ticker, 
    df = df_stocks, 
    shiny = TRUE
  )
  
  if (length(str_stock_name) == 0) {
    return(stock_name)
  } else {
    return(str_stock_name)
  }
  
}