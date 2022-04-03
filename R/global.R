
global <- quote({
  
  df_stocks <- get_stock_name_and_ticker()
  
  all_stocks  <- df_stocks$Stock
  all_tickers <- df_stocks$Ticker
  
  info_diff_col <- as.character(
    add_info_circle(
      label = "Difference", 
      placement = "right", 
      content = "Green = buy and red = sell"
    )
  )
  
  info_benchmark_col <- as.character(
    add_info_circle(
      label = "Benchmark", 
      placement = "right", 
      content = "The benchmark is MSCI All Countries World Index (ACWI)"
    )
  )
  
  info_region_other <- as.character(
    add_info_circle(
      label = "Other", 
      placement = "right", 
      content = "Canada, Australia and other countries"
    )
  )
  
  colors_sector <- colors_geo <- list(
    Difference = formattable::color_tile("lightgreen", "pink")
  )
  
  names(colors_sector) <- info_diff_col
  names(colors_geo)    <- info_diff_col
  
})