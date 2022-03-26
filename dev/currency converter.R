library(dplyr)

devtools::load_all()

convert_to_dkk_with_constant <- function(x, currency) {

  if (currency == "USD") {
    ticker <- "DKK=X"
  } else if (currency == "EUR") {
    ticker <- "EURDKK=X"
  } else if (currency == "SEK") {
    ticker <- "SEKDKK=X"
  }

  data <- load_data(ticker = ticker, from = Sys.Date() - 7)

  exchange_rate <- data %>%
    dplyr::filter(Date == max(Date)) %>%
    dplyr::pull(Close)

  return(x * exchange_rate)

}

replace_na_with_previous_value <- function(x) {

  first_non_na_id <- (!x %>% is.na()) %>% which() %>% dplyr::nth(1)

  missing_id <- x[first_non_na_id:length(x)] %>% is.na() %>% which()
  missing_id <- missing_id + first_non_na_id - 1

  for (i in missing_id) {

    x[i] <- x[i - 1]

  }

  return(x)

}

convert_data_to_dkk_with_variable <- function(data, currency) {

  start_date <- data %>%
    dplyr::pull(Date) %>%
    min()

  if (currency == "USD") {
    ticker <- "DKK=X"
  } else if (currency == "EUR") {
    ticker <- "EURDKK=X"
  } else if (currency == "SEK") {
    ticker <- "SEKDKK=X"
  }

  data_currency <- load_data(ticker = "DKK=X", from = start_date) %>%
    dplyr::select(Date, Close) %>%
    dplyr::rename(Currency = Close)

  data_out <- data %>%
    dplyr::left_join(data_currency, by = "Date")

  data_out <- data_out %>%
    dplyr::mutate(Currency = replace_na_with_previous_value(Currency),
                  Open = Open * Currency,
                  High = High * Currency,
                  Low = Low * Currency,
                  Close = Close * Currency,
                  Adjusted = Adjusted * Currency)

  return(data_out)

}

get_yield <- function(data, n_days, digits = 2) {

  n <- length(n_days)
  yield <- rep(NA, n)
  standard_error <- rep(NA, n)

  for (i in 1:n) {

    close_start_data <- data %>%
      dplyr::filter(Date == min(Date)) %>%
      dplyr::pull(Close)

    data_period <- data %>%
      dplyr::mutate(Change_from_start = round(100 * ((Close - close_start_data) / close_start_data), 4)) %>%
      dplyr::filter(Date >= Sys.Date() - n_days[i])

    close_end <- data_period %>%
      dplyr::filter(Date == max(Date)) %>%
      dplyr::pull(Close)

    close_start <- data_period %>%
      dplyr::filter(Date == min(Date)) %>%
      dplyr::pull(Close)

    change_vec <- data_period %>%
      dplyr::pull(Change_from_start)

    standard_error[i] <- sd(change_vec, na.rm = TRUE) %>%
      round(2)

    yield[i] <- round(100 * (close_end - close_start) / close_start, digits = digits)

  }

  sharp_ratio <- round(yield / standard_error, 2)

  df_yield <- matrix(c(yield, standard_error, sharp_ratio), nrow = 1) %>%
    as.data.frame()

  str_n_days <- c(n_days[-length(n_days)],
                  "my_entrance")

  names(df_yield) <- c(paste0("Yield_", str_n_days),
                       paste0("Standard_error_", str_n_days),
                       paste0("Sharp_ratio_", str_n_days))

  return(df_yield)

}

get_ticker <- function(data_investments) {

  ticker            <- data_investments$Ticker
  first_buy_day     <- data_investments$First_buy_day
  currency          <- data_investments$Ticker_currency

  data_list <- list()
  data_yield <- list()
  n <- nrow(data_investments)

  data_investments$Antal_ticker <- rep(NA, n)

  str_instrument <- gsub(" ", "_", data_investments$Instrument)

  one_year_ago <- Sys.Date() - 365

  for (i in 1:n) {

    from <- min(one_year_ago, first_buy_day[i])

    data <- load_data(ticker = ticker[i], from = from) %>%
      convert_data_to_dkk_with_variable(data = ., currency = currency[i])

    n_days_my_entrance <- (Sys.Date() - first_buy_day[i]) %>% as.numeric()

    df_yield <- get_yield(data = data, n_days = c(7, 30, 90, 180, 365, n_days_my_entrance))
    data_yield[[i]] <- cbind(data.frame(Instrument = str_instrument[i]),
                             df_yield)

    Antal_ticker <- data_investments$Original_value[i] / data$Close[1]

    data_list[[i]] <- data %>%
      dplyr::mutate(Holding = 1 * (first_buy_day[i] <= Date),
                    Marked_value = Close * Antal_ticker * Holding) %>%
      dplyr::rename(!!str_instrument[i] := Marked_value) %>%
      dplyr::select(c("Date", str_instrument[i]))

    data_investments$Antal_ticker[i] <- Antal_ticker

    cat("\r", i, "of", n)
    flush.console()

  }

  data_marked_value <- plyr::join_all(data_list, by = "Date", type = "full") %>%
    dplyr::as_tibble() %>%
    dplyr::arrange(Date) %>%
    dplyr::mutate(
      dplyr::across(str_instrument, ~replace_na_with_previous_value(.))
    ) %>%
    replace(is.na(.), 0) %>%
    dplyr::mutate(Marked_value = rowSums(dplyr::across(where(is.numeric))))

  data_yield <- do.call("rbind", data_yield)

  out <- list("data_marked_value" = data_marked_value,
              "data_investments" = data_investments,
              "data_yield" = data_yield)

  return(out)

}

data_investments <- dplyr::tribble(
  ~Instrument,                  ~Antal, ~First_buy_day, ~Average_price_buy_currency, ~Buy_currency, ~Ticker,     ~Ticker_currency, ~Approx,
  "Sparindex Dow Jones",        96,     "2020-03-03",   180.09,                      "DKK",         "IGSG.AS",   "EUR",            1,
  "Sparindex Europa Small Cap", 59,     "2021-05-01",   207.72,                      "DKK",         "IEUS",      "EUR",            1,
  "Sparindex Europa Value",     225,    "2021-03-01",   92.91,                       "DKK",         "EMSV.DE",   "EUR",            1,
  "Sparindex OMXC25",           115,    "2020-03-16",   311.01,                      "DKK",         "^OMX",      "DKK",            1,
  "Sparindex US Growth",        189,    "2020-08-25",   187.49,                      "DKK",         "IUSG",      "USD",            1,
  "Sparindex US Value",         246,    "2020-09-03",   90.35,                       "DKK",         "IUSV",      "USD",            1,
  "Sparindex US Small Cap",     80,     "2020-12-14",   158,                         "DKK",         "ISCB",      "USD",            1,
  "Epiroc",                     25,     "2020-12-29",   151.55,                      "SEK",         "EPI-A.ST",  "SEK",            0,
  "GomSpace",                   580,    "2021-03-02",   17.87,                       "SEK",         "GOMX.ST",   "SEK",            0,
  "Lundbeck",                   14,     "2020-01-15",   242.8,                       "DKK",         "LUN.CO",    "DKK",            0,
  "Hexagon",                    42,     "2021-05-18",   108.29,                      "SEK",         "HEXA-B.ST", "SEK",            0,
  "Matas",                      35,     "2020-12-18",   84.6,                        "DKK",         "MATAS.CO",  "DKK",            0,
  "Riot",                       22,     "2021-12-07",   28.875,                      "USD",         "RIOT",      "USD",            0,
  "Vestas",                     45,     "2021-04-27",   140.8,                       "DKK",         "VWS.CO",    "DKK",            0,
  "Ørsted",                     6,      "2020-05-27",   826.53,                      "DKK",         "ORSTED.CO", "DKK",            0
)

data_investments <- data_investments %>%
  dplyr::mutate(First_buy_day = as.Date(First_buy_day),
                Original_value = Antal * Average_price_buy_currency)

is_integer <- function(x) {
  (x %% 1) == 0
}

data_investments %>%
  dplyr::pull(Antal) %>%
  is_integer() %>%
  all()

ticker_info <- get_ticker(data_investments = data_investments)

current_marked_value <- ticker_info$data_marked_value %>%
  dplyr::filter(Date == max(Date)) %>%
  dplyr::pull(Marked_value)

data_current_values <- ticker_info$data_marked_value %>%
  dplyr::filter(Date == max(Date)) %>%
  dplyr::select(str_instrument) %>%
  t() %>%
  as.data.frame()

data_current_values$Instrument <- rownames(data_current_values)

data_current_values <- data_current_values %>%
  dplyr::rename(Marked_value = V1) %>%
  dplyr::as_tibble() %>%
  dplyr::mutate(Proportion = 100 * (Marked_value / current_marked_value) %>% round(4)) %>%
  dplyr::relocate(Instrument) %>%
  dplyr::inner_join(ticker_info$data_yield %>%
                      dplyr::select(Instrument, Yield_365, Standard_error_365, Sharp_ratio_365,
                                    Yield_my_entrance, Standard_error_my_entrance, Sharp_ratio_my_entrance),
                    by = "Instrument")

data_current_values %>%
  dplyr::summarise(Mean_sharp_ratio = weighted.mean(x = Sharp_ratio_365, w =  Proportion))

profvis::profvis({
  get_ticker(data_investments = data_investments)
})

plotly::plot_ly(
  data = ticker_info$data_marked_value,
  x = ~Date,
  y = ~Marked_value,
  type = "scatter",
  mode = "lines"
)

data_cash <- dplyr::tribble(
  ~Date,      ~DKK, ~USD, ~EUR, ~SEK,
  Sys.Date(), 5000, 150,  5,    2
)

data_cash %>%
  dplyr::mutate(
    USD_in_DKK = convert_to_dkk_with_constant(x = USD, currency = "USD"),
    EUR_in_DKK = convert_to_dkk_with_constant(x = EUR, currency = "EUR"),
    SEK_in_DKK = convert_to_dkk_with_constant(x = SEK, currency = "SEK"),
    Total_cash = DKK + USD_in_DKK + EUR_in_DKK + SEK_in_DKK
  )

convert_to_dkk_with_constant(data =, currency = "USD")



data_constant <- data %>%
  dplyr::mutate(Open = convert_to_dkk_with_constant(Open, currency = "USD"))

data_variable <- convert_data_to_dkk_with_variable(data = data, currency = "USD")

cor(data_constant$Close, data_variable$Close)

Close_start <- data_constant$Close[1]

data_constant <- data_constant %>%
  dplyr::mutate(Yield = 100 * ((Close - Close_start) / Close_start))

Close_start <- data_variable$Close[1]

data_variable <- data_variable %>%
  dplyr::mutate(Yield_variable = 100 * ((Close - Close_start) / Close_start))

plot_data <- data_constant %>%
  dplyr::inner_join(data_variable %>% dplyr::select(Date, Yield_variable), by = "Date")

plotly::plot_ly(data = plot_data, x = ~Date, y = ~Yield, type = "scatter", mode = "lines", name = "Constant") %>%
  plotly::add_trace(y = ~Yield_variable, name = "Variable")
