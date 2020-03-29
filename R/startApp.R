#' The openPrimeR Shiny Application.
#'
#' Starts the openPrimeR Shiny application. 
#' A new tab should open in your default
#' browser. If no browser is opened, please consider the console
#' output to identify the local port on which the server is running
#' and manually open the shown URL.
#'
#' @note
#' The Shiny app can be started only if you fulfill all 
#' of the suggested package dependencies for the Shiny framework,
#' so please ensure that you've installed openPrimeR including
#' all suggested dependencies.
#'
#' @import shiny shinyBS
#' @export
#' @return Opens the Shiny app in a web browser.
#' @examples
#' # Start the shiny app
#' \dontrun{
#' startApp()
#' }
#' # Only run this example in interactive R sessions:
#' if (interactive()) {
#'  startApp()
#' }
startApp <- function() {
    appDir <- system.file("shiny", package = "openPrimeRui")
    if (appDir == "") {
        stop(paste("Could not find the directory containing the shiny app: ",
        appDir, "\n", 
        "Try re-installing the 'openPrimeR' package.", call. = FALSE))
    }
    options(shiny.jquery.version = 1) # shinyBS does not support jQuery 3.4.1
    shiny::runApp(appDir, display.mode = "normal", launch.browser = TRUE)
} 
