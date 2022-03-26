#' Get ticker
#' @param stock_name Stock name
#' @param df data.frame stored using readRDS(file = "./data/df_stock_name_and_ticker.RDS")
#' @param shiny logical indicating if the first element should be blank
#' 
get_ticker <- function(stock_name, df, shiny = FALSE) {
  
  if (missing(df)) {
    df <- get_stock_name_and_ticker()
  }
  
  if (missing(stock_name) || stock_name == "") {
    
    all_tickers <- df %>% 
      dplyr::pull(Ticker)
    
    if (shiny) {
      all_tickers <- c("", all_tickers)
    }
    
    return(all_tickers)
    
  }
  
  df %>% 
    dplyr::filter(Stock == stock_name) %>% 
    dplyr::pull(Ticker)
  
}