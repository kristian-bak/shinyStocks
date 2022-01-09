#' Add rates
#' @param data
#' 
add_rates <- function(data) {
  
  ## Extracting the unique countries in the portfolio
  countries <- data %>% 
    dplyr::pull(Country) %>% 
    unique()
  
  currency <- data %>% 
    dplyr::pull(Currency) %>% 
    unique()
  
  ## Getting the currency used
  currencies <- map_country_to_currency(x = countries, currency = currency)
  
  ## Finding the conversion rates
  currency_rates <- vectorized_convert_to_dkk(from = currencies)
  
  df_currency <- dplyr::tibble(
    Country = countries,
    Currency = currency, 
    Rate = currency_rates
  )
  
  df_rates <- data %>% 
    dplyr::select(Country, Currency) %>% 
    unique() %>% 
    dplyr::left_join(df_currency %>% dplyr::select(-Country), by = "Currency")
  
  data <- data %>% 
    dplyr::select(-Rate) %>%                                      ## Rate is NA in initial portfolio
    dplyr::left_join(df_rates, by = c("Country", "Currency")) %>% ## so dropping it to avoid Rate.x and Rate.y
    dplyr::relocate(Rate, .before = Marked_value)
  
  return(data)
  
}