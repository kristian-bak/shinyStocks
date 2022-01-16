#' Vectorized load data and get etf info
#' @param ticker ticker code
#' @param stock_name optional. Used to asses if load function for ETFs should be called.
#' @param from from date
#' @param rate currency conversion rate to DKK. Use rate = 1 if no conversion should be applied
#' @param updateProgress progress function
#' 
vectorized_load_data_and_get_etf_info <- function(ticker, stock_name = rep(NA, length(ticker)), from,
                                 rate = rep(1, length(ticker)), updateProgress = NULL) {
  
  n <- length(ticker)
  
  if (length(from) != n) {
    stop("Length of from should match length of ticker")
  }
  
  data_list <- list()
  etf_list <- list()
  
  str_ticker <- stringify(x = ticker)
  
  sparindex <- is_sparindex(stock_name)
  
  for (i in 1:n) {
    
    if (sparindex[i]) {
      
      data_list[[i]] <- kb.yahoo::load_stock_price(ticker = ticker[i])
      
      etf_list[[i]] <- get_etf_info(stock_name = stock_name[i], ticker = ticker[i])
      
    } else {
      
      data_list[[i]] <- kb.yahoo::load_data(
        ticker = ticker[i], 
        from = from[i]
      )
      
    }
    
    data_list[[i]] <- data_list[[i]] %>% 
      dplyr::select(Date, Close) %>% 
      dplyr::mutate(Close = Close * rate[i])
    
    names(data_list[[i]]) <- c("Date", str_ticker[i])
    
    if (is.function(updateProgress)) {
      text <- paste("Stock ", i, "of", n)
      updateProgress(detail = text)
    }
    
  }
  
  df_marked_value <- full_join_list(.l = data_list, by = "Date")
  
  out <- list(
    "df_marked_value" = df_marked_value,
    "etf_list"        = etf_list
  )
  
  return(out)
  
}