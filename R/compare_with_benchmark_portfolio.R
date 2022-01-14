#' Compare with benchmark portfolio
#' @param df_holdings data.frame with holdings for your portfolio
#' @param benchmark_info benchmark information obtained from load_benchmark_info
#' @param var variable name (string) used to compare your portfolio with benchmark
#' @return Summarised data.frame with marked value proportion grouped by `var`
#' 
compare_with_benchmark_portfolio <- function(df_holdings, benchmark_info, var) {
  
  total_marked_value <- df_holdings %>% 
    dplyr::pull(Marked_value) %>% 
    sum()
  
  df_summary <- df_holdings %>% 
    dplyr::group_by(dplyr::across(var)) %>% 
    dplyr::summarise(Portfolio = sum(Marked_value) / total_marked_value) %>% 
    dplyr::full_join(benchmark_info %>% dplyr::rename(Benchmark = Pct), by = var) %>% 
    dplyr::mutate(Portfolio = 100 * Portfolio %>% round(3), 
                  Benchmark = 100 * Benchmark %>% round(3),
                  Difference = Portfolio - Benchmark %>% round(3)) %>% 
    dplyr::arrange(dplyr::desc(Portfolio))
  
  return(df_summary)
  
}