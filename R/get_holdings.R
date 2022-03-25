#' Get holdings
#' @param df_portfolio df_portfolio
#' @param eft_info etf_info
#' 
get_holdings <- function(df_portfolio, etf_info) {
  
  n <- nrow(df_portfolio)
  id <- 1:n
  etf_id <- which(is_etf(stock_name = df_portfolio$Stock))
  stock_id <- id[!id%in% etf_id]
  
  df_list_holdings <- list()
  
  for (i in etf_id) {
    
    Marked_value_etf <- df_portfolio$Marked_value[i]
    
    df_list_holdings[[i]] <- etf_info[[i]]$holdings_info %>% 
      dplyr::mutate(Marked_value = Marked_value_etf * Weight) %>% 
      dplyr::select(Stock, Ticker, Sector, Location, Marked_value) %>% 
      dplyr::mutate(Region = map_country_to_region(x = Location)) %>% 
      dplyr::select(-Location) %>% 
      dplyr::relocate(Region, .before = Marked_value)
      
    
  }
  
  df_holdings <- do.call("rbind", df_list_holdings)
  
  df_stock <- df_portfolio %>% 
    dplyr::slice(stock_id) %>% 
    dplyr::select(Stock, Ticker, Sector, Region, Marked_value)
  
  df_holdings <- rbind(df_holdings, df_stock) %>% 
    dplyr::filter(Stock != "" & Region != "-")
  
  total_marked_value <- df_holdings %>% 
    dplyr::filter(Stock != "") %>% 
    dplyr::pull(Marked_value) %>% 
    sum()
  
  remove_everything_after <- function(pattern, x) {
  
    gsub(paste0(pattern, ".*"), "", x)
    
  }
  
  df_holdings_agg <- df_holdings %>%
    dplyr::mutate(str_ticker = remove_everything_after(pattern = "\\.", x = Ticker), 
                  str_ticker = gsub(pattern = "\\-", " ", str_ticker)) %>% 
    dplyr::group_by(str_ticker) %>% 
    dplyr::summarise(Stock = which.max.length(Stock), 
                     Marked_value = round(sum(Marked_value), 2)) %>% 
    dplyr::arrange(dplyr::desc(Marked_value)) %>% 
    dplyr::mutate(Weight = 100 * (Marked_value / sum(Marked_value)), 
                  Weight = round(Weight, 2)) %>% 
    dplyr::select(Stock, Marked_value, Weight)
  
  out <- list(
    "df_holdings_agg" = df_holdings_agg,
    "df_holdings" = df_holdings
  )
  
  return(out)
  
}
