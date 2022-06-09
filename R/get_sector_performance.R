#' Sector performance source
#' @export
#' 
get_sector_performance_source <- function() {
  
  dplyr::tribble(
    ~Stock,                                                              ~Ticker,  ~Sector,
    "iShares S&P 500 Communication Sector UCITS ETF",                    "IUCM.L", "Communication Services",
    "iShares S&P 500 Consumer Discretionary Sector UCITS ETF USD (Acc)", "IUCD.L", "Consumer Discretionary",
    "iShares S&P 500 Consumer Staples Sector UCITS ETF",                 "ICSU.L", "Consumer Staples",
    "iShares S&P 500 Energy Sector UCITS ETF USD (Acc)",                 "IUES.L", "Energy",
    "iShares S&P 500 Financials Sector UCITS ETF USD (Acc)",             "IUFS.L", "Financials",
    "iShares S&P 500 Health Care Sector UCITS ETF USD (Acc)",            "IUHC.L", "Health Care",
    "iShares S&P 500 Industrials Sector UCITS ETF",                      "IUIS.L", "Industrials",
    "iShares S&P 500 Information Technology Sector UCITS ETF USD (Acc)", "IUIT.L", "Information Technology",
    "iShares S&P 500 Materials Sector UCITS ETF",                        "IUMS.L", "Materials",
    "iShares S&P 500 Utilities Sector UCITS ETF",                        "IUUS.L", "Utilities", 
    "iShares U.S. Real Estate ETF",                                      "IYR",    "Real Estate"
  )
  
}

#' One year ago
#' 
one_year_ago <- function() {
  
  today <- Sys.Date()
  
  last_year <- substring(today, 1, 4) %>% 
    as.numeric() %>% 
    {.} - 1
  
  paste(last_year, substring(today, 6, 10), sep = "-") %>% 
    as.Date()
  
}

#' Year to date
#' 
year_to_date <- function() {
  
  today <- Sys.Date()
  
  this_year <- substring(today, 1, 4)
  
  ytd <- paste0(this_year, "-01-01") %>% as.Date()
  
  return(ytd)
  
}

#' x days ago
#' @param x integer (days)
#' 
x_days_ago <- function(x) {
  
  today <- Sys.Date()
  
  return(today - x)
  
}

#' Get performance dates
#' 
get_performance_dates <- function() {
  
  ytd <- year_to_date()
  m1  <- x_days_ago(x = 30)
  m3  <- x_days_ago(x = 60)
  m6  <- x_days_ago(x = 90)
  y1  <- one_year_ago()
  
  out <- list("ytd" = ytd, 
              "m1" = m1, 
              "m3" = m3, 
              "m6" = m6, 
              "y1" = y1)
  
  return(out)
  
}

#' Summarise performance
#' 
summarise_performance <- function(data, dates, name = NULL) {
  
  n <- length(dates)
  data_summary <- list()
  
  for (i in 1:n) {
    
    data_summary[[i]] <- data %>% 
      dplyr::filter(Date >= dates[[i]]) %>% 
      dplyr::summarise(name = name,
                       period = names(dates)[i],
                       start_price = dplyr::nth(x = Adjusted, n = 1), 
                       end_price = dplyr::nth(x = Adjusted, n = dplyr::n()), 
                       yield = round(100 * ((end_price - start_price) / start_price), 2)) %>% 
      dplyr::select(-start_price, -end_price)
    
  }
  
  df_out <- do.call("rbind", data_summary) %>% 
    tidyr::pivot_wider(names_from = period, values_from = yield)
  
  return(df_out)
  
}

#' Get sector performance
#' @param updateProgress updateProgress function
get_sector_performance <- function(updateProgress = NULL) {
  
  df_sectors <- get_sector_performance_source()
  
  n <- nrow(df_sectors)
  
  from <- one_year_ago()
  
  dates <- get_performance_dates()
  
  data_summary <- list()
  
  for (i in 1:n) {
    
    data <- kb.yahoo::load_data(ticker = df_sectors$Ticker[i], from = from)
    
    data_summary[[i]] <- summarise_performance(
      data = data, 
      dates = dates, 
      name = df_sectors$Sector[i]
    )
    
    if (is.function(updateProgress)) {
      text <- paste("Index ", i, "of", n)
      updateProgress(detail = text)
    }
    
  }
  
  df_out <- do.call("rbind", data_summary) %>% 
    dplyr::rename(Sector = name)
  
  return(df_out)
  
}