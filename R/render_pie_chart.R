#' Plot pie chart
#' @param data data.frame
#' @param labels labels as string
#' 
plot_pie_chart <- function(data, labels) {
  
  if (is.null(data$Marked_value)) {
    return()
  }
  
  fig <- plotly::plot_ly(
    data = data, 
    labels = ~get(labels), 
    values = ~Marked_value, 
    type = "pie"
  )
  
  return(fig)
  
}