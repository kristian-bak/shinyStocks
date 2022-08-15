#' Get sparindex source
#' @details 
#' Ticker is used to get marked value today
#' Ticker_approx is not used in the code. It is only used to keep track of which ETF is used as approximation when loading holding analytics from iShares
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

#' Get iShares source
#' @details 
#' Ticker is used to get marked value today
#' Ticker_approx is not used in the code. It is only used to keep track of which ETF is used as approximation when loading holding analytics from iShares
#' iShares_url is used to get holdings and sector information (url is found under Holdings table: Detailed Holdings and Analytics)
#' Skip is the parameter used in read.csv for the specific url (Skipping rows before header appear)
#' 
get_ishares_source <- function() {
  
  dplyr::tribble(
    ~Stock,                                                       ~Ticker, ~Ticker_approx, ~Currency_approx, ~Skip, ~iShares_url,
    "iShares Global Clean Energy UCITS ETF",                      "IQQH.DE",  "ICLN",         "USD",            9,  "https://www.ishares.com/us/products/239738/ishares-global-clean-energy-etf/1467271812596.ajax?fileType=csv&fileName=ICLN_holdings&dataType=fund",
    "iShares Automation & Robotics UCITS ETF",                    "2B76.DE",  "RBOT",         "USD",            2,  "https://www.ishares.com/uk/professional/en/products/284219/fund/1506575576011.ajax?fileType=csv&fileName=RBOT_holdings&dataType=fund",
    "iShares Digitalisation UCITS ETF",                           "DGTL.MI",  "DGTL",         "USD",            2,  "https://www.ishares.com/uk/individual/en/products/284217/fund/1506575576011.ajax?fileType=csv&fileName=DGTL_holdings&dataType=fund",
    "iShares Electric Vehicles and Driving Technology UCITS ETF", "ECAR.MI",  "ECAR",         "USD",            2,  "https://www.ishares.com/ch/institutional/en/products/307130/fund/1495092304805.ajax?fileType=csv&fileName=ECAR_holdings&dataType=fund",
    "iShares MSCI ACWI UCITS ETF",                                "IUSQ.DE",  "SSAC",         "USD",            2,  "https://www.ishares.com/uk/individual/en/products/251850/ishares-msci-acwi-ucits-etf/1506575576011.ajax?fileType=csv&fileName=SSAC_holdings&dataType=fund"
  )
  
}

#' Get Danske Invest source
#' @details 
#' Ticker is used to get marked value today
#' Ticker_approx is not used in the code. It is only used to keep track of which ETF is used as approximation when loading holding analytics from iShares
#' iShares_url is used to get holdings and sector information (url is found under Holdings table: Detailed Holdings and Analytics)
#' Skip is the parameter used in read.csv for the specific url (Skipping rows before header appear)
#' 
get_danske_source <- function() {
  
  dplyr::tribble(
    ~Stock,                                   ~Ticker,               ~Ticker_approx, ~Currency_approx, ~Skip, ~iShares_url,
    "Danske Invest Global Indeks KL",         "DKIGI.CO",            "URTH",         "USD",            9,     "https://www.ishares.com/us/products/239696/ishares-msci-world-etf/1467271812596.ajax?fileType=csv&fileName=URTH_holdings&dataType=fund",
    "Danske Invest Fjernøsten Indeks",        "DKIFJIX.CO",          "EEM",          "USD",            9,     "https://www.ishares.com/us/products/239637/ishares-msci-emerging-markets-etf/1467271812596.ajax?fileType=csv&fileName=EEM_holdings&dataType=fund",
    "Danske Invest Danmark Indeks KL",        "DKIDKIX.CO",          "EDEN",         "USD",            9,     "https://www.ishares.com/us/products/239621/ishares-msci-denmark-capped-etf/1467271812596.ajax?fileType=csv&fileName=EDEN_holdings&dataType=fund",
    "Danske Invest Danmark Indeks ex OMXC20", "DKIDKIEXOMXC20D.CO",  "EDEN",         "USD",            9,     "https://www.ishares.com/us/products/239621/ishares-msci-denmark-capped-etf/1467271812596.ajax?fileType=csv&fileName=EDEN_holdings&dataType=fund",
    "Danske Invest Teknologi Indeks KL",      "0P00000KRH.CO",       "CNDX",         "USD",            2,     "https://www.ishares.com/uk/individual/en/products/253741/ishares-nasdaq-100-ucits-etf/1506575576011.ajax?fileType=csv&fileName=CNDX_holdings&dataType=fund"
  )
  
}

#' Get single stock source
#' @description Single stock information regarding stock name and ticker code
#' @details Add stocks by searching for the name on iShares and find the ticker code
#' If a new source category should be added, remember to include the new function to get_stock_name_and_ticker
#' on yahoo
#' 
get_single_stock_source <- function() {
  
  dplyr::tribble(
    ~Stock,                    ~Ticker,     ~Country, ~Sector,                   ~Broker,
    "DANSKE BANK",             "DANSKE.CO", "Denmark", "Financials",             "Danske Bank", 
    "EPIROC CLASS A",          "EPI-A.ST",  "Sweden",  "Industrials",            "Saxo Bank",
    "H LUNDBECK",              "LUN.CO",    "Denmark", "Health Care",            "Saxo Bank",
    "HEXAGON CLASS B",         "HEXA-B.ST", "Sweden",  "Information Technology", "Saxo Bank",
    "GOMSPACE GROUP",          "GOMX.ST",   "Sweden",  "Information Technology", "Saxo Bank",
    "MATAS",                   "MATAS.CO",  "Denmark", "Consumer Discretionary", "Saxo Bank",
    "NIBE INDUSTRIER CLASS B", "NIBE-B.ST", "Sweden",  "Industrials",            "Saxo Bank",
    "RIOT BLOCKCHAIN INC",     "RIOT",      "USA",     "Information Technology", "Saxo Bank", 
     "DEMANT",                  "DEMANT.CO", "Denmark", "Health Care",           "Saxo Bank",
    "ROCKWOOL B",              "ROCK-B.CO", "Denmark", "Industrials",            "Saxo Bank",
    "VESTAS WIND SYSTEMS",     "VWS.CO",    "Denmark", "Industrials",            "Saxo Bank",
    "ØRSTED",                  "ORSTED.CO", "Denmark", "Utilities",              "Saxo Bank"
  )
  
}
