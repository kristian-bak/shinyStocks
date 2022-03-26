#' Add rates
#' @param data
#' 
add_rates <- function(data) {
  
  currency <- data %>% 
    dplyr::pull(Currency) %>% 
    unique()
  
  ## Finding the conversion rates
  currency_rates <- vectorized_convert_to_dkk(from = currency)
  
  df_currency <- dplyr::tibble(
    Currency = currency, 
    Rate = currency_rates
  )
  
  data <- data %>% 
    dplyr::select(-Rate) %>%                           ## Rate is NA in initial portfolio
    dplyr::left_join(df_currency, by = "Currency") %>% ## so dropping it to avoid Rate.x and Rate.y
    dplyr::relocate(Rate, .before = Marked_value)
  
  return(data)
  
}