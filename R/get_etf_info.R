#' Get ETF info
#' @param stock_name stock name
#' @param ticker ticker code
#' 
get_etf_info <- function(stock_name, ticker) {
  
  file_name <- get_file_name(stock_name = stock_name)
  
  if (file.exists(file_name)) {
    
    out <- readRDS(file = file_name)
    
    return(out)
    
  }
  
  data_etf      <- load_etf_info(ticker = ticker)
  sector_info   <- get_sector_info(data = data_etf)
  country_info  <- get_country_info(data = data_etf)
  holdings_info <- get_holdings_info(data = data_etf)
  
  out <- list(
    "sector_info"   = sector_info, 
    "country_info"  = country_info,
    "holdings_info" = holdings_info,
    "stock_name"    = stock_name,
    "ticker"        = ticker
  )
  
  save_etf_info(obj = out, stock_name = stock_name)
  
  return(out)
  
}

#' Load ETF info
#' @param ticker ticker code
#' 
load_etf_info <- function(ticker) {
  
  df_url <- get_sparindex_source() %>% 
    dplyr::filter(Ticker == ticker) %>% 
    dplyr::select(iShares_url, Skip)
  
  read.csv(df_url$iShares_url, skip = df_url$Skip) %>% 
    dplyr::as_tibble() %>% 
    dplyr::select(Name, Ticker, Sector, Location, `Weight....`) %>% 
    dplyr::rename(Stock = Name, 
                  Weight = `Weight....`) %>% 
    dplyr::mutate(Weight = Weight / 100)
  
}

#' Get sector info
#' @param data data.frame from load_etf_info
#' 
get_sector_info <- function(data) {
  
  data %>% 
    dplyr::filter(Sector != "") %>% 
    dplyr::group_by(Sector) %>% 
    dplyr::summarise(Pct = sum(Weight))
  
}

#' Get sector info
#' @param data data.frame from load_etf_info
#' 
get_country_info <- function(data) {
  
  data %>% 
    dplyr::filter(!is.na(Weight) & Location != "-") %>% 
    dplyr::mutate(Region = map_country_to_region(Location)) %>% 
    dplyr::group_by(Region) %>% 
    dplyr::summarise(Pct = sum(Weight))
  
}

#' Get holdings info
#' @param data data.frame from load_etf_info
#' @param top_n number of rows to return. Default is top 100
#' 
get_holdings_info <- function(data, ticker, top_n = 100) {
  
  data %>% 
    dplyr::slice(1:top_n)
  
}