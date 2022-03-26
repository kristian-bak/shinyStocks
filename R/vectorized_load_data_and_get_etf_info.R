#' Vectorized load data and get etf info
#' @param ticker ticker code
#' @param stock_name optional. Used to asses if load function for ETFs should be called.
#' @param from from date
#' @param rate rate which is used to calculate closing price in DKK
#' @param updateProgress progress function
#' @export
vectorized_load_data_and_get_etf_info <- function(ticker, stock_name = rep(NA, length(ticker)), from,
                                                  rate = rep(1, length(ticker)), updateProgress = NULL) {
  
  n <- length(ticker)
  
  if (length(stock_name) != n) {
    stop("Length of stock_name should match length of ticker")
  }
  
  if (length(from) != n) {
    stop("Length of from should match length of ticker")
  }
  
  if (length(rate) != n) {
    stop("Length of rate should match length of ticker")
  }
  
  data_list <- list()
  data_list_final <- list()
  etf_list <- list()
  
  str_ticker <- stringify(x = ticker)
  
  etf <- is_etf(stock_name)
  
  for (i in 1:n) {
    
    ## Loading data for sparindex means getting the latest stock price and 
    ## downloading ETF info from ishares
    if (etf[i]) {
      
      if (i > 1) {
        
        ## If the information already has been loaded, then don't load again
        if (ticker[i] %in% ticker[1:(i - 1)]) {
          
          id <- which(ticker[i] == ticker[1:(i - 1)])[1]
          
          data_list[[i]] <- data_list[[id]]
          etf_list[[i]]  <- etf_list[[id]]
          
        } else {
          
          data_list[[i]] <- kb.yahoo::load_stock_price(ticker = ticker[i])
          
          etf_list[[i]] <- get_etf_info(stock_name = stock_name[i], ticker = ticker[i])
          
        } 
        
      } else {
        
        data_list[[i]] <- kb.yahoo::load_stock_price(ticker = ticker[i])
        
        etf_list[[i]] <- get_etf_info(stock_name = stock_name[i], ticker = ticker[i])
        
      }
      
    } else {
      
      data_list[[i]] <- kb.yahoo::load_data(
        ticker = ticker[i], 
        from = from[i]
      )
      
    }
    
    data_list_final[[i]] <- data_list[[i]] %>% 
      dplyr::select(Date, Close) %>% 
      dplyr::mutate(Close_dkk = Close * rate[i]) %>% 
      dplyr::select(-Close)
    
    names(data_list_final[[i]]) <- c("Date", str_ticker[i])
    
    if (is.function(updateProgress)) {
      text <- paste("Stock ", i, "of", n)
      updateProgress(detail = text)
    }

  }
  
  df_marked_value <- full_join_list(.l = data_list_final, by = "Date")
  
  out <- list(
    "df_marked_value" = df_marked_value,
    "etf_list"        = etf_list
  )
  
  return(out)
  
}