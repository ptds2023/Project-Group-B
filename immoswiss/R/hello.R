# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

#' @param num_rooms Numeric vector representing the number of rooms.
#' @param meter_square Numeric vector representing the number of square meters.
#' @param location Character vector representing the location (postal code).
#' @return Numeric vector representing the estimated prices of apartments.
#' @export
#' @importFrom stats lm predict
estimate_price <- function(rooms, meter_square, location) {

  # Fit a linear regression model using the entire dataset with location as a categorical variable
  lausanne$location <- factor(lausanne$location)
  lausanne$location <- relevel(lausanne$location, ref = "1004")
  # Assuming 'model' is your linear regression model
  model <- lm(log(price) ~ rooms +meter_square + as.factor(location) + meter_square:as.factor(location) + rooms:as.factor(location), data = lausanne)
  summary(model)

  # Create a new data frame with the provided input
  new_data <- data.frame(rooms = rooms, meter_square = meter_square, location = as.factor(location))

  # Predict the price using the model
  log_predicted_price <- predict(model, newdata = new_data, interval = "confidence", level = 0.75)

  predicted_price <- exp(log_predicted_price)

  print(summary(model))

  return(predicted_price)

}






