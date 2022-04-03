#' Get ETF info
#' @param stock_name stock name
#' @param ticker ticker code
#' 
get_etf_info <- function(stock_name, ticker, max_days = 3) {
  
  file_name <- get_file_name(stock_name = stock_name)
  
  if (check_file_in_db(file = file_name, max_days = max_days)) {
    
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
  
  df_url <- get_url_source() %>% 
    dplyr::filter(Ticker == ticker) %>% 
    dplyr::select(iShares_url, Skip)
  
  if (nrow(df_url) == 0) {
    stop("URL and skip value not found based on ticker code. Rember to update get_url_source")
  }
  
  read.csv(df_url$iShares_url, skip = df_url$Skip) %>% 
    dplyr::as_tibble() %>% 
    dplyr::select(Name, Ticker, Sector, Location, `Weight....`) %>% 
    dplyr::rename(Stock = Name, 
                  Weight = `Weight....`) %>% 
    dplyr::filter(!Weight %in% c("", "Weight (%)")) %>% 
    dplyr::mutate(Weight = as.numeric(Weight), 
                  Weight = Weight / 100)
  
}

#' Get URL source
#' 
get_url_source <- function() {
  
  df <- list()
  
  df[[1]] <- get_sparindex_source()
  df[[2]] <- get_ishares_source()
  df[[3]] <- get_danske_source()
  
  df_out <- do.call("rbind", df)
  
  return(df_out)
  
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
#' @param top_n number of rows to return. Default is all
#' 
get_holdings_info <- function(data, ticker, top_n) {
  
  if (missing(top_n)) {
    top_n <- nrow(data)
  }
  
  data %>% 
    dplyr::slice(1:top_n)
  
}