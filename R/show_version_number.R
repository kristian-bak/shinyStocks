#' Show version number
#' @param package package name
show_version_number <- function(package = "shinyStocks") {
  
  version_number <- packageVersion(pkg = package) %>% as.character()
  version_number <- paste0("v", version_number)
  
  div(version_number, 
      style = "text-align:center")
  
}