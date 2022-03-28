#' Subset list
#' @param l list
#' @param element integer or character for named list
subset_list <- function(l, element) {
  lapply(element, FUN = function(x) l[[x]])
}