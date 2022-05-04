#' Compare with benchmark portfolio
#' @param df_holdings data.frame with holdings for your portfolio
#' @param benchmark_info benchmark information obtained from load_benchmark_info
#' @param var variable name (string) used to compare your portfolio with benchmark
#' @param df_performance data.frame with performance statistics
#' @return Summarised data.frame with marked value proportion grouped by `var`
#' 
compare_with_benchmark_portfolio <- function(df_holdings, benchmark_info, var, df_performance) {
  
  df_summary <- df_holdings %>% 
    dplyr::group_by(dplyr::across(var)) %>% 
    dplyr::summarise(Portfolio = sum(Marked_value)) %>%
    dplyr::mutate(Portfolio = Portfolio / sum(Portfolio)) %>% 
    dplyr::full_join(benchmark_info %>% dplyr::rename(Benchmark = Pct), by = var) %>% 
    dplyr::mutate(Portfolio = dplyr::if_else(is.na(Portfolio), 0, Portfolio),
                  Benchmark = dplyr::if_else(is.na(Benchmark), 0, Benchmark),
                  Portfolio = round(100 * Portfolio, 2), 
                  Benchmark = round(100 * Benchmark, 2),
                  Difference = round(Portfolio - Benchmark, 2)) %>% 
    dplyr::arrange(dplyr::desc(Portfolio)) %>% 
    dplyr::left_join(df_performance, by = var)
  
  return(df_summary)
  
}