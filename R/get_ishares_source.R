#' Get iShares source
#' @details 
#' Ticker is used to get marked value today
#' Ticker_approx is used to get historical market value approximation
#' iShares_url is used to get holdings and sector information (url is found under Holdings table: Detailed Holdings and Analytics)
#' Skip is the parameter used in read.csv for the specific url (Skipping rows before header appear)
#' 
get_ishares_source <- function() {
  
  dplyr::tribble(
    ~Stock,                                                       ~Ticker, ~Ticker_approx, ~Currency_approx, ~Skip, ~iShares_url,
    "iShares Global Clean Energy UCITS ETF",                      "ICLN",  "ICLN",         "USD",            9,     "https://www.ishares.com/us/products/239738/ishares-global-clean-energy-etf/1467271812596.ajax?fileType=csv&fileName=ICLN_holdings&dataType=fund",
    "iShares Automation & Robotics UCITS ETF",                    "RBOT",  "RBOT",         "USD",            2,     "https://www.ishares.com/uk/professional/en/products/284219/fund/1506575576011.ajax?fileType=csv&fileName=RBOT_holdings&dataType=fund",
    "iShares Digitalisation UCITS ETF",                           "DGTL",  "DGTL",         "USD",            2,     "https://www.ishares.com/uk/individual/en/products/284217/fund/1506575576011.ajax?fileType=csv&fileName=DGTL_holdings&dataType=fund",
    "iShares Electric Vehicles and Driving Technology UCITS ETF", "ECAR",  "ECAR",         "USD",            2,     "https://www.ishares.com/ch/institutional/en/products/307130/fund/1495092304805.ajax?fileType=csv&fileName=ECAR_holdings&dataType=fund"
  )
  
}




