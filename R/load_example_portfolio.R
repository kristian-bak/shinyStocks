#' Load example portfolio
#'
load_example_portfolio <- function() {
  
  dplyr::tribble(
    ~Stock,                 ~Ticker,     ~Date,        ~Price, ~Stocks, ~Country,  ~Currency, ~ETF, ~Type,   ~Sector,                   ~Cap,   ~Broker,        ~Rate, ~Marked_value, ~Weight,    
    "TESLA INC",            "TSLA",      "2021-11-15", 1018,   10,      "USA",     "USD",     "No", "Growth", "Consumer Discretionary", "Large", "Saxo Bank",   NA,    NA,            NA,
    "JOHNSON & JOHNSON",    "JNJ",       "2021-12-14", 168,    50,      "USA",     "USD",     "No", "Value",  "Health Care",            "Large", "Nordnet",     NA,    NA,            NA,
    "NOVO NORDISK CLASS B", "NOVO-B.CO", "2022-01-03", 747,    100,     "Denmark", "DKK",     "No", "Growth", "Health Care",            "Large", "Danske Bank", NA,    NA,            NA,
    "ADIDAS N AG	",        "ADS.DE",    "2022-01-03", 254,    10,      "Germany", "EUR",     "No", "Value",  "Consumer Discretionary", "Large", "Saxo Bank",   NA,    NA,            NA,
    "VOLVO CLASS B",        "VOLV-B.ST", "2022-01-03", 210,    100,     "Sweden",  "SEK",     "No", "Value",  "Consumer Discretionary", "Large", "Saxo Bank",   NA,    NA,            NA
  ) %>% 
    dplyr::mutate(Date = as.Date(Date))
  
}