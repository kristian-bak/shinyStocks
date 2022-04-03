#' Load portfolio
#' @param file_name name of file placed in data/portfolios folder
#' @param overwrite_portfolio logical (TRUE/FALSE)
#' @param df data.frame with existing portfolio (only relevant if overwrite_portfolio = FALSE)
load_portfolio <- function(file_name, overwrite_portfolio, df) {
  
  n <- length(file_name)
  
  for (i in 1:n) {
    
    f_name <- paste0("data/portfolios/", file_name[i], ".rda")
    
    df_portfolio_loaded <- load(file = f_name)
    df_portfolio_loaded <- mget(df_portfolio_loaded)$df_portfolio
    
    if (overwrite_portfolio) {
      
      df_out <- df_portfolio_loaded
      
    } else {
      
      df_out <- rbind(
        df,
        df_portfolio_loaded
      )
      
    }
    
  }
  
  return(df_out)
  
}