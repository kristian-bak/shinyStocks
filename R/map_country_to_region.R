#' Map country to region
#' @param country character vector with countries
#' 
map_country_to_region <- function(x) {
  
  y <- x
  
  us <- "United States"
  
  eu <- c("Austria", "Belgium", "European Union", "Finland", "France", "Germany", 
          "Ireland", "Italy", "Netherlands", "Norway", "Portugal", 
          "Spain", "Sweden", "Switzerland", "United Kingdom",
          "Greece", "Czech Republic")
  
  em <- c("Argentina", "Brazil", "Chile", "China", "Colombia", "Hungary", 
          "Hong Kong", "India", "Israel", "Indonesia", 
          "Korea (South)", "Malaysia", "Mexico", "Morocco",
          "Russian Federation",
          "Philippines", "Poland",
          "Singapore", "South Africa", "Taiwan", "Thailand", "Turkey", 
          "Saudi Arabia", "United Arab Emirates", "Qatar", "Kuwait", "Peru", "Egypt")
  
  jp <- c("Japan")
  dk <- c("Denmark")
  other <- c("Canada", "Australia", "New Zealand")
  
  y[x %in% us] <- "USA"
  y[x %in% eu] <- "Europe"
  y[x %in% em] <- "Emerging Markets"
  y[x %in% jp] <- "Japan"
  y[x %in% dk] <- "Denmark"
  y[x %in% other] <- "Other"
  
  return(y)
  
}