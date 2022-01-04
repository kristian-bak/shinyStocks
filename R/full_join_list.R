#' Full join list
#' @param .l list
#' @param by by arrgument
#' 
full_join_list <- function(.l, by) {
  
  merge_two_lists <- function(.l1, .l2) {
    merge(.l1, .l2, by = by, all.x = TRUE)
  }
  
  Reduce(f = merge_two_lists, x = .l)
  
}