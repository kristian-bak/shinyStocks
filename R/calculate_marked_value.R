#' Calculate marked value
#' @param df_portfolio data.frame with stocks
#' @param etf_info list with ETF info
#' @param df_closing_price data.frame with Date and and a column for each stock 
#' with closing price in DKK
#' @param benchmark_name character string with benchmark name
#' @param benchmark_ticker character string with benchmark ticker
#' 
calculate_marked_value <- function(df_portfolio, etf_info, df_closing_price, 
                                   benchmark_name = "iShares MSCI ACWI UCITS ETF", 
                                   benchmark_ticker = "IUSQ.DE") {
  
  str_ticker        <- stringify(x = df_portfolio$Ticker)
  closing_price_dkk <- df_closing_price %>% dplyr::select(-Date)
  n_stocks          <- df_portfolio$Stocks
  
  marked_value_today <- sapply(
    X = closing_price_dkk, 
    FUN = get_market_value_today
  ) * n_stocks
  
  total_marked_value <- sum(marked_value_today)
  
  df_portfolio <- df_portfolio %>% 
    dplyr::mutate(Region = map_country_to_region(x = Country),
                  Marked_value = marked_value_today, 
                  Weight = round(Marked_value / total_marked_value, 3))
  
  res <- get_holdings(
    df_portfolio = df_portfolio, 
    etf_info = etf_info
  )
  
  df_holdings <- res$df_holdings
  df_holdings_agg <- res$df_holdings_agg
  
  df_portfolio <- df_portfolio %>% 
    dplyr::select(-Region)
  
  df_sector <- df_holdings %>% 
    remove_cash(var = Sector)
  
  list_benchmark <- load_benchmark_info(
    df_portfolio = df_portfolio, 
    etf_info = etf_info, 
    benchmark_name = benchmark_name, 
    benchmark_ticker = benchmark_ticker
  )
  
  df_benchmark_geo <- compare_with_benchmark_portfolio(
    df_holdings    = df_holdings, 
    benchmark_info = list_benchmark$country_info, 
    var = "Region"
  )
  
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
  
  names(df_benchmark_geo) <- c("Region", "Portfolio", info_benchmark_col, info_diff_col)
  
  df_benchmark_geo$Region[df_benchmark_geo$Region == "Other"] <- info_region_other
  
  df_benchmark_sector <- compare_with_benchmark_portfolio(
    df_holdings    = df_sector, 
    benchmark_info = list_benchmark$sector_info %>% remove_cash(var = Sector), 
    var = "Sector"
  )
  
  names(df_benchmark_sector) <- c("Sector", "Portfolio", info_benchmark_col, info_diff_col)
  
  out <- list(
    "df_portfolio" = df_portfolio,
    "df_holdings" = df_holdings,
    "df_holdings_agg" = df_holdings_agg,
    "df_sector" = df_sector,
    "list_benchmark" = list_benchmark,
    "df_benchmark_geo" = df_benchmark_geo,
    "df_benchmark_sector" = df_benchmark_sector
  )
  
  return(out)
  
  
}