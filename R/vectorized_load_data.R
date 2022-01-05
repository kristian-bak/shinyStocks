#' Vectorized load data
#' @param ticker ticker code
#' @param from from date
#' @param cbind logical indicating if output should column binded
#' @param rate currency conversion rate to DKK. Use rate = 1 if no conversion should be applied
#' @param updateProgress progress function
#' 
vectorized_load_data <- function(ticker, from, cbind = TRUE, 
                                 rate = rep(1, length(ticker)), updateProgress = NULL) {
  
  n <- length(ticker)
  
  if (length(from) != n) {
    stop("Length of from should match length of ticker")
  }
  
  data_list <- list()
  
  str_ticker <- gsub("\\.|-", "_", ticker)
  
  for (i in 1:n) {
    
    data_list[[i]] <- yahoo::load_data(
      ticker = ticker[i], 
      from = from[i]
    ) %>% 
      dplyr::select(Date, Close) %>% 
      dplyr::mutate(Close = Close * rate[i])
    
    names(data_list[[i]]) <- c("Date", str_ticker[i])
    
    if (is.function(updateProgress)) {
      text <- paste("Stock ", i, "of", n)
      updateProgress(detail = text)
    }
    
  }
  
  if (cbind) {
    
    out <- full_join_list(.l = data_list, by = "Date")
    
  } else {
    
    out <- data_list
    
  }
  
  return(out)
  
}