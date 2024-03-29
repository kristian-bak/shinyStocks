library(shinyBS)

#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "Shiny Stocks"),
      shinydashboard::dashboardSidebar(
        
        show_version_number(),
        
        shinydashboard::sidebarMenu(
          shinydashboard::menuItem("Overview", tabName = "overview", icon = icon("chart-line"))
        )
        
      ),
      
      shinydashboard::dashboardBody(
        shinydashboard::tabItems(
          # First tab content
          shinydashboard::tabItem(tabName = "overview",
                  
                  mod_overview_ui("overview_ui_1")
                  
          )
        )
      )
      
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'shinyStocks'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

