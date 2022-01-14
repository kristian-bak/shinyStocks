#' Map country to region
#' @param country character vector with countries
#' 
map_country_to_region <- function(x) {
  
  us <- c("Canada", "United States")
  eu <- c("Austria", "Belgium", "European Union", "Finland", "France", "Germany", 
          "Hungary", "Ireland", "Italy", "Netherlands", "Norway", "Portugal", 
          "Russian Federation", "Spain", "Sweden", "Switzerland", "United Kingdom")
  em <- c("Argentina", "Australia", "Brazil", "Chile", "China", "Colombia", "Hong Kong", 
          "India", "Israel", "Korea (South)", "Malaysia", "Mexico", "New Zealand", 
          "Philippines", "Singapore", "South Africa", "Taiwan", "Thailand", "Turkey")
  jp <- c("Japan")
  dk <- c("Denmark")
  
  x[x %in% us] <- "USA"
  x[x %in% eu] <- "Europe"
  x[x %in% em] <- "Emerging Markets"
  x[x %in% jp] <- "Japan"
  x[x %in% dk] <- "Denmark"
  
  return(x)
  
}