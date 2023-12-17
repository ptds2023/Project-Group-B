#' Launch the Shiny App
#' @export
launch_shiny_app <- function() {
  app_path <- system.file("shiny_app", package = "immoswiss")
  shiny::runApp(appDir = app_path)
}