
global <- quote({
  
  df_stocks <- get_stock_name_and_ticker()
  
  all_stocks  <- df_stocks$Stock
  all_tickers <- df_stocks$Ticker
  
})