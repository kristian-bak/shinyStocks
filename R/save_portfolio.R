#' Save portfolio
#' @param df_portfolio data.frame to save
#' @param id id used to uniquely identify row in portfolio log
save_portfolio <- function(df_portfolio, id) {
  
  file_name_rda <- paste0(id, ".rda")
  
  file_rda <- paste0("./data/portfolios/", file_name_rda)
  
  save(df_portfolio, file = file_rda)
  
}