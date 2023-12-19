#' Estimate the price through a multiple linear regression
#' @param num_rooms The number of rooms.
#' @param meter_square The number of square meters.
#' @param location The location (postal code).
#' @param lausanne The dataset containing information on rooms, meter_square, price, and location
#' @return The estimated prices of apartments with confidence intervals.
#' @export
#' @importFrom stats lm predict
#' @examples
#' estimate_price(2, 100, 1000, lausanne) # 2 is the number of rooms, 100 is the number of meter square and 1000 is the location
estimate_price <- function(rooms, meter_square, location, data) {
  # Assuming 'model' is your linear regression model
  model <- lm(log(price) ~ rooms +meter_square + as.factor(location) + meter_square:as.factor(location) + rooms:as.factor(location), data = data)
  summary(model)
  # Create a new data frame with the provided input
  new_data <- data.frame(rooms = rooms, meter_square = meter_square, location = as.factor(location))
  # Predict the price using the model
  log_predicted_price <- predict(model, newdata = new_data, interval = "confidence", level = 0.95)
  predicted_price <- exp(log_predicted_price)
  print(summary(model))
  return(predicted_price)
}

