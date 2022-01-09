
global <- quote({
  
  df_stocks <- readRDS(file = "./data/df_stock_name_and_ticker.RDS")
  
  all_stocks  <- df_stocks$Stock
  all_tickers <- df_stocks$Ticker
  
})