#' Get stock name
#' @param ticker ticker code
#' @param df data.frame stored using readRDS(file = "./data/df_stock_name_and_ticker.RDS")
#' @param shiny logical indicating if the first element should be blank
#' 
get_stock_name <- function(ticker, df, shiny = FALSE) {
  
  if (missing(df)) {
    df <- get_stock_name_and_ticker()
  }
  
  if (missing(ticker) || ticker == "") {
    
    all_stocks <- df %>% 
      dplyr::pull(Stock)
    
    if (shiny) {
      all_stocks <- c("", all_stocks)
    }
    
    return(all_stocks)
    
  }
  
  df %>% 
    dplyr::filter(Ticker == ticker) %>% 
    dplyr::pull(Stock)
  
}