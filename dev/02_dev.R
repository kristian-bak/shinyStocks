## Document
devtools::document()

## Load all functions
devtools::load_all()

# Document and reload your package
golem::document_and_reload()

# Run the application
run_app()

devtools::check()

## Bump version number
usethis::use_version()

## Add test:
usethis::use_test("vectorized_load_data_and_get_etf_info")

## Renv
renv::status()
renv::snapshot()

usethis::use_package("shinydashboard")
usethis::use_package("htmltools")
usethis::use_package("DT")
usethis::use_package("shinyWidgets")
usethis::use_package("dplyr")
usethis::use_package("shinyjs")
usethis::use_package("shinyBS")
usethis::use_package("kb.yahoo")
usethis::use_package("shinycssloaders")
usethis::use_package("plotly")
usethis::use_package("TTR")
usethis::use_package("purrr")
usethis::use_package("formattable")

remotes::install_github(repo = "https://github.com/kristian-bak/kb.yahoo/")

golem::add_module(name = "overview") # Name of the module
golem::add_module(name = "name_of_module2") # Name of the module

golem::add_fct( "helpers" ) 
golem::add_utils("is")

## Tests ----
## Add one line by test you want to create
usethis::use_test( "app" )

## Add pipe operator
usethis::use_pipe()

usethis::use_news_md()

## Code Coverage----
## Set the code coverage service ("codecov" or "coveralls")
usethis::use_coverage()

# Create a summary readme for the testthat subdirectory
covrpage::covrpage()

## CI ----
## Use this part of the script if you need to set up a CI
## service for your application
## 
## (You'll need GitHub there)
usethis::use_github()

# GitHub Actions
usethis::use_github_action() 
# Chose one of the three
# See https://usethis.r-lib.org/reference/use_github_action.html
usethis::use_github_action_check_release() 
usethis::use_github_action_check_standard() 
usethis::use_github_action_check_full() 
# Add action for PR
usethis::use_github_action_pr_commands()

# Travis CI
usethis::use_travis() 
usethis::use_travis_badge() 

# AppVeyor 
usethis::use_appveyor() 
usethis::use_appveyor_badge()

# Circle CI
usethis::use_circleci()
usethis::use_circleci_badge()

# Jenkins
usethis::use_jenkins()

# GitLab CI
usethis::use_gitlab_ci()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")

