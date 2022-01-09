#' Load example portfolio
#'
load_example_portfolio <- function() {
  
  dplyr::tribble(
    ~Stock,              ~Ticker,     ~Date,        ~Price, ~Stocks, ~Country,  ~Currency, ~ETF, ~Type,   ~Sector,                   ~Cap,   ~Broker,        ~Rate, ~Marked_value,     
    "Tesla, Inc.",       "TSLA",      "2021-11-15", 1018,   10,      "USA",     "USD",     "No", "Growth", "Consumer Discretionary", "Large", "Saxo Bank",   NA,    NA,
    "Johnson & Johnson", "JNJ",       "2021-12-14", 168,    50,      "USA",     "USD",     "No", "Value",  "Healthcare",             "Large", "Nordnet",     NA,    NA,
    "Novo Nordisk A/S",  "NOVO-B.CO", "2022-01-03", 747,    100,     "Denmark", "DKK",     "No", "Growth", "Healthcare",             "Large", "Danske Bank", NA,    NA,
    "Adidas AG",         "ADS.DE",    "2022-01-03", 254,    10,      "Germany", "EUR",     "No", "Value",  "Consumer Discretionary", "Large", "Saxo Bank",   NA,    NA,
    "AB Volvo",          "VOLV-B.ST", "2022-01-03", 210,    100,     "Sweden",  "SEK",     "No", "Value",  "Consumer Discretionary", "Large", "Saxo Bank",   NA,    NA
  ) %>% 
    dplyr::mutate(Date = as.Date(Date))
  
}