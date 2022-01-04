#' Convert data frame to vector
#' @param data
#' 
convert_data_frame_to_vector <- function(data) {
  
  data %>% 
    as.list() %>% 
    unlist()
  
}