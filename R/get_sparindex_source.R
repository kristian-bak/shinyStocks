#' Get sparindex source
#' @details 
#' Ticker is used to get marked value today
#' Ticker_approx is used to get historical market value approximation
#' iShares_url is used to get holdings and sector information
#' Skip is the parameter used in read.csv for the specific url
#' 
get_sparindex_source <- function() {
  
  dplyr::tribble(
    ~Stock,                                ~Ticker,       ~Ticker_approx, ~Currency_approx, ~Skip, ~iShares_url,
    "Sparindex INDEX DJSI World KL",       "SPIDJWKL.CO", "IUSL.DE",      "EUR",            2,     "https://www.ishares.com/uk/individual/en/products/251768/ishares-dow-jones-global-sustainability-screened-ucits-etf/1506575576011.ajax?fileType=csv&fileName=IGSG_holdings&dataType=fund",
    "Sparindex INDEX Emerging Markets KL", "SPIEMIKL.CO", "EEM",          "USD",            9,     "https://www.ishares.com/us/products/239637/ishares-msci-emerging-markets-etf/1467271812596.ajax?fileType=csv&fileName=EEM_holdings&dataType=fund",
    "Sparindex INDEX Europa Growth KL",    "SPIEUGKL.CO", "CG9.PA",       "EUR",            2,     "https://www.ishares.com/uk/individual/en/products/251860/ishares-msci-europe-ucits-etf-inc-fund/1506575576011.ajax?fileType=csv&fileName=IMEU_holdings&dataType=fund", 
    "Sparindex INDEX Europa Small Cap KL", "SPIEUCKL.CO", "IEUS",         "USD",            9,     "https://www.ishares.com/us/products/239537/ishares-developed-smallcap-ex-north-america-etf/1467271812596.ajax?fileType=csv&fileName=IEUS_holdings&dataType=fund",
    "Sparindex INDEX Europa Value KL",     "SPIEUVKL.CO", "EMSV.DE",      "EUR",            2,     "https://www.ishares.com/uk/professional/en/products/272058/ishares-msci-europe-value-factor-ucits-etf/1506575576011.ajax?fileType=csv&fileName=IEVL_holdings&dataType=fund",
    "Sparindex INDEX Globale Aktier KL",   "SPVIGAKL.CO", "URTH",         "USD",            9,     "https://www.ishares.com/us/products/239696/ishares-msci-world-etf/1467271812596.ajax?fileType=csv&fileName=URTH_holdings&dataType=fund",
    "Sparindex INDEX Japan Growth KL",     "SPIJAGKL.CO", "EWJ",          "USD",            9,     "https://www.ishares.com/us/products/239665/ishares-msci-japan-etf/1467271812596.ajax?fileType=csv&fileName=EWJ_holdings&dataType=fund",
    "Sparindex INDEX Japan Small Cap KL",  "SPIJASKL.CO", "SCJ",          "USD",            9,     "https://www.ishares.com/us/products/239666/ishares-msci-japan-smallcap-etf/1467271812596.ajax?fileType=csv&fileName=SCJ_holdings&dataType=fund",
    "Sparindex INDEX Japan Value KL",      "SPIJAVKL.CO", "EWJV",         "USD",            9,     "https://www.ishares.com/us/products/307263/fund/1467271812596.ajax?fileType=csv&fileName=EWJV_holdings&dataType=fund",
    "Sparindex INDEX OMX C25 KL",          "SPIC25KL.CO", "EDEN",         "USD",            9,     "https://www.ishares.com/us/products/239621/ishares-msci-denmark-capped-etf/1467271812596.ajax?fileType=csv&fileName=EDEN_holdings&dataType=fund",
    "Sparindex INDEX USA Growth KL",       "SPIUSGKL.CO", "IUSG",         "USD",            9,     "https://www.ishares.com/us/products/239713/ishares-core-sp-us-growth-etf/1467271812596.ajax?fileType=csv&fileName=IUSG_holdings&dataType=fund",
    "Sparindex INDEX USA Small Cap KL",    "SPIUSSKL.CO", "ISCB",         "USD",            9,     "https://www.ishares.com/us/products/239586/ishares-morningstar-smallcap-etf/1467271812596.ajax?fileType=csv&fileName=ISCB_holdings&dataType=fund",
    "Sparindex INDEX USA Value KL",        "SPIUSVKL.CO", "IUSV",         "USD",            9,     "https://www.ishares.com/us/products/239715/ishares-core-sp-us-value-etf/1467271812596.ajax?fileType=csv&fileName=IUSV_holdings&dataType=fund"
  )
  
}




