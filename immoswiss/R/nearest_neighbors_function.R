#' Find Nearest Neighbors based on rooms and square meters
#' @param nb_rooms Number of rooms specified by the user
#' @param meter_square Number of square meters specified by the user
#' @param location Location (postal code) specified by the user
#' @param lausanne The dataset containing information on rooms, meter_square, price, and location
#' @param k Number of nearest neighbors to retrieve (default is 5)
#' @return A data frame with the k nearest neighbors matching the query
find_nearest_neighbors <- function(nb_rooms, meter_square, location, data, k = 5) {
  # Scale the numerical features (rooms and meter_square)
  scaled_data <- scale(data[, c("rooms", "meter_square")])
  
  # Scale the query numerical parameters using mean and standard deviation of dataset columns
  scaled_query <- c((nb_rooms - mean(data$rooms)) / sd(data$rooms),
                    (meter_square - mean(data$meter_square)) / sd(data$meter_square))
  
  # One-hot encode the location column for the query
  unique_locations <- unique(data$location)
  encoded_location <- ifelse(unique_locations == location, 1, 0)
  
  # Prepare encoded location for comparison with dataset
  scaled_query <- c(scaled_query, encoded_location)
  
  # One-hot encode the location column for the dataset
  encoded_locations <- t(sapply(data$location, function(x) ifelse(unique_locations == x, 1, 0)))
  
  # Calculate distances based on scaled features and encoded location
  distances <- apply(cbind(scaled_data, encoded_locations), 1, function(x) sqrt(sum((x - scaled_query)^2)))
  
  # Combine distances with the original dataset
  data_with_distances <- cbind(data, distance = distances)
  
  # Sort the dataset by distance in ascending order
  sorted_data <- data_with_distances[order(data_with_distances$distance), ]
  
  # Return the top k nearest neighbors
  return(sorted_data[1:k, ])
}

# Find 5 nearest neighbors for a query with 3 rooms and 120 square meters
#nearest_neighbors <- find_nearest_neighbors(5, 300, "1004", lausanne, k = 5)

# Display the result
#print(nearest_neighbors)
