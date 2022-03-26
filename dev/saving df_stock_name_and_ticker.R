devtools::load_all()

data <- get_stock_name_and_ticker()

saveRDS(object = data, file = "./data/df_stock_name_and_ticker.RDS")

data <- readRDS(file = "./data/df_stock_name_and_ticker.RDS")

data
