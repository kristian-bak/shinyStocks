#' Remove cash
#' @param data data.frame
#' @param var variable name (tidy approach)
remove_cash <- function(data, var) {
  
  data %>% 
    dplyr::filter({{var}} != "Cash and/or Derivatives")
  
}
