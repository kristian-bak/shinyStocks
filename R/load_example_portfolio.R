#' Load example portfolio
#'
load_example_portfolio <- function() {
  
  dplyr::tribble(
    ~Stock,              ~Ticker,     ~Date,        ~Price, ~Stocks, ~Country,  ~ETF, ~Type,    ~Cap,
    "Tesla, Inc.",       "TSLA",      "2021-11-15", 1018,   10,      "USA",     "No", "Growth", "Large",
    "Johnson & Johnson", "JNJ",       "2021-12-14", 168,    50,      "USA",     "No", "Value",  "Large",
    "Novo Nordisk A/S",  "NOVO-B.CO", "2022-01-03", 747,    100,     "Denmark", "No", "Growth", "Large",
    "Adidas AG",         "ADS.DE",    "2022-01-03", 254,    10,      "Germany", "No", "Value",  "Large",
    "AB Volvo",          "VOLV-B.ST", "2022-01-03", 210,    100,     "Sweden",  "No", "Value",  "Large" 
  ) %>% 
    dplyr::mutate(Date = as.Date(Date))
  
}