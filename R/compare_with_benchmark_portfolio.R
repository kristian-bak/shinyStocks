#' Compare with benchmark portfolio
#' @param df_holdings data.frame with holdings for your portfolio
#' @param benchmark_info benchmark information obtained from load_benchmark_info
#' @param var variable name (string) used to compare your portfolio with benchmark
#' @return Summarised data.frame with marked value proportion grouped by `var`
#' 
compare_with_benchmark_portfolio <- function(df_holdings, benchmark_info, var) {
  
  df_summary <- df_holdings %>% 
    dplyr::group_by(dplyr::across(var)) %>% 
    dplyr::summarise(Portfolio = sum(Marked_value)) %>%
    dplyr::mutate(Portfolio = Portfolio / sum(Portfolio)) %>% 
    dplyr::full_join(benchmark_info %>% dplyr::rename(Benchmark = Pct), by = var) %>% 
    dplyr::mutate(Portfolio = round(100 * Portfolio, 2), 
                  Benchmark = round(100 * Benchmark, 2),
                  Difference = round(Portfolio - Benchmark, 2)) %>% 
    dplyr::arrange(dplyr::desc(Portfolio))
  
  return(df_summary)
  
}