#' Load benchmark info
#' @param df_portfolio df_portfolio
#' @param etf_info etf_info obtained from get_etf_info
#' 
load_benchmark_info <- function(df_portfolio, etf_info) {
  
  benchmark_name   <- "Sparindex INDEX Globale Aktier KL"
  benchmark_ticker <- "SPVIGAKL.CO"
  
  if (benchmark_name %in% df_portfolio$Stock) {
    
    benchmark_id <- which(benchmark_name == df_portfolio$Stock)[1]
    
    out <- etf_info[[benchmark_id]]
    
  } else {
    
    out <- get_etf_info(
      stock_name = benchmark_name, 
      ticker = benchmark_ticker
    )
    
  }
  
  return(out)
  
}