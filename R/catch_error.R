#' An extension of tryCatch
#' @param expr expression to evalute
#' @return A list with value, warning and error message
#'
catch_error <- function(expr) {
  warn <- err <- NULL
  value <- withCallingHandlers(
    tryCatch(expr, error = function(e) {
      err <<- e
      NULL
    }), warning=function(w) {
      warn <<- w
      invokeRestart("muffleWarning")
    })
  list(value = value, warning = warn, error = err)
}
