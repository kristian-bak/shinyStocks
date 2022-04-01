#' Delete portfolio
#' 
delete_portfolio <- function() {
  
  out <- list("df_portfolio" = NULL, 
              "df_holdings" = NULL, 
              "df_benchmark_geo" = NULL, 
              "df_benchmark_sector" = NULL, 
              "df_sector" = NULL)
  
  return(out)
  
}

#' Delete rows from portfolio
#' @param df_portfolio data.frame with stocks
#' @param df_marked_value data.frame with marked_value for each stock
#' @param etf_info list with ETF info (NULL for stocks)
#' @param rows_selected index vector corresponding to rows to delete
#' 
delete_rows_from_portfolio <- function(df_portfolio, df_marked_value, etf_info, rows_selected) {
  
  n_rows_init <- nrow(df_portfolio)
  ticker_selected <- df_portfolio$Ticker[rows_selected]
  
  ## If data has been loaded, then update marked value
  if (is_not_null(df_marked_value)) {
    
    ticker_selected <- stringify(ticker_selected)
    df_marked_value <- df_marked_value %>% 
      dplyr::select(-ticker_selected)
    
    id <- 1:n_rows_init
    preserved_rows <- id[id %notin% rows_selected]
    
    etf_info <- subset_list(
      l = etf_info, 
      element = preserved_rows
    )
    
  }
  
  df_portfolio <- df_portfolio[-rows_selected, ]
  
  # Update row numbers (provided the table contains at least one row)
  if (nrow(df_portfolio) > 0) {
    
    rownames(df_portfolio) <- 1:nrow(df_portfolio)
    
  }
  
  out <- list("df_portfolio" = df_portfolio, 
              "df_marked_value" = df_marked_value, 
              "etf_info" = etf_info)
  
  return(out)
  
}

#' Delete it all
#' @param df_portfolio data.frame with stocks
#' @param rows_selected integer vector with rows to delete
#' @return logical, TRUE if entire portfolio should be deleted
#' 
delete_it_all <- function(df_portfolio, rows_selected) {
  
  entire_table_selected <- is.null(rows_selected)
  all_rows_selected <- length(rows_selected) == nrow(df_portfolio)
  
  if (entire_table_selected | all_rows_selected) {
    
    return(TRUE)
    
  } else {
    
    return(FALSE)
    
  }
  
}