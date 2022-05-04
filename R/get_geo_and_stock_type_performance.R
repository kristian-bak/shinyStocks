#' Get performance
#' @param updateProgress updateProgress function
get_geo_and_stock_type_performance <- function(updateProgress = NULL) {
  
  str_stocks <- c("Sparindex INDEX Europa Growth KL", 
                  "Sparindex INDEX Europa Small Cap KL",
                  "Sparindex INDEX Europa Value KL", 
                  #"Sparindex INDEX Globale Aktier KL", 
                  #"Sparindex INDEX DJSI World KL",
                  "Sparindex INDEX OMX C25 KL",                    
                  "Sparindex INDEX USA Growth KL",                     
                  "Sparindex INDEX USA Small Cap KL",    
                  "Sparindex INDEX USA Value KL", 
                  "Sparindex INDEX Emerging Markets KL", 
                  "Sparindex INDEX Japan Growth KL", 
                  "Sparindex INDEX Japan Small Cap KL", 
                  "Sparindex INDEX Japan Value KL")
  
  df_geo <- get_sparindex_source() %>% 
    dplyr::filter(Stock %in% str_stocks) %>% 
    dplyr::mutate(Region = map_stock_name_to_region(x = Stock), 
                  stock_type = map_stock_name_to_stock_type(x = Stock))
  
  n <- nrow(df_geo)
  
  dates <- get_performance_dates()
  
  from <- dates$y1
  
  data_summary <- list()
  
  for (i in 1:n) {
    
    data <- kb.yahoo::load_data(ticker = df_geo$Ticker_approx[i], from = from)
    
    data_summary[[i]] <- summarise_performance(
      data = data, 
      dates = dates, 
      name = df_geo$Stock[i]
    )
    
    if (is.function(updateProgress)) {
      text <- paste("Index ", i, "of", n)
      updateProgress(detail = text)
    }
    
  }
  
  df <- do.call("rbind", data_summary) %>% 
    dplyr::left_join(df_geo %>% dplyr::select(Stock, Region, stock_type), 
                     by = c("name" = "Stock"))
  
  df_region <- df %>% 
    dplyr::group_by(Region) %>% 
    dplyr::summarise(ytd = round(mean(ytd), 2),
                     m1  = round(mean(m1), 2),
                     m3  = round(mean(m3), 2),
                     m6  = round(mean(m6), 2),
                     y1  = round(mean(y1), 2))
  
  df_stock_type <- df %>% 
    dplyr::group_by(stock_type) %>% 
    dplyr::summarise(ytd = round(mean(ytd), 2),
                     m1  = round(mean(m1), 2),
                     m3  = round(mean(m3), 2),
                     m6  = round(mean(m6), 2),
                     y1  = round(mean(y1), 2))
  
  out <- list("df" = df, 
              "df_region" = df_region, 
              "df_stock_type" = df_stock_type)
  
  return(out)
  
}

#' Map stock name to region
#' @param x character string with sparindex stock 
#' 
map_stock_name_to_region <- function(x) {
  
  x[x == "Sparindex INDEX OMX C25 KL"]          <- "Denmark"
  x[x == "Sparindex INDEX Globale Aktier KL"]   <- "Global"
  x[x == "Sparindex INDEX DJSI World KL"]       <- "Global"
  x[x == "Sparindex INDEX Emerging Markets KL"] <- "Emerging Markets"
  x[grepl("Europa", x)]                         <- "Europe"
  x[grepl("USA", x)]                            <- "USA"
  x[grepl("Japan", x)]                          <- "Japan"
  
  return(x)
  
}

#' Map stock name to stock type
#' @param x character string with sparindex stock 
#' 
map_stock_name_to_stock_type <- function(x) {
  
  x[x == "Sparindex INDEX OMX C25 KL"]          <- "Growth"
  x[x == "Sparindex INDEX Globale Aktier KL"]   <- "Blend"
  x[x == "Sparindex INDEX DJSI World KL"]       <- "Blend"
  x[x == "Sparindex INDEX Emerging Markets KL"] <- "Blend"
  x[grepl("Growth", x)]                         <- "Growth"
  x[grepl("Value", x)]                          <- "Value"
  x[grepl("Small", x)]                          <- "Blend"
  
  return(x)
  
}