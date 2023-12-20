library(shiny)
library(dplyr)
library(ggplot2)
# library(immoswiss)

lausanne <- read.csv("immoswiss/data/lausanne.csv")

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
  log_predicted_price <- predict(model, newdata = new_data, interval = "confidence", level = 0.95)
  predicted_price <- exp(log_predicted_price)
  # print(summary(model))
  return(predicted_price)
}










































# Define UI
ui <- fluidPage(
  
  # titlePanel(
  #   "# app title/description"
  # ),
  # 
  #Set the theme
  theme = bslib::bs_theme(bootswatch = "flatly"),
  
  #Create the main page
  navbarPage(
    "Lausanne - Real Estate Market Analysis",
    
    # Define the first panel (title)
    tabPanel("Estimate the price",
      
      #Specify input button for the first panel
      sidebarLayout(
        sidebarPanel(
          selectInput("selected_loc_sel", "Select the postal code of your proprety:",
                      choices = sort(unique(lausanne$location)), 
                      selected = "1000"),
          
          numericInput("rooms_sel", "Number of rooms:", 2.5 , min = 1),
          
          numericInput("meter_sel", "Square Meter:", 50 , min = 5),
          
          actionButton("calc_sel", "Calculate the estimated price of your house."), 
        ),
        
        #Specify the output of the first panel
        mainPanel(
          h4("Results:"),
          uiOutput("estimation"),
          plotOutput("plot", click = "plot_click"),
          tableOutput("data")

        )
      )
    ),
    
    
    #Define the second panel (title)
    tabPanel("Explore your option",
      
      #Specify input button for the second panel
      sidebarLayout(
        sidebarPanel(
          selectInput("selected_loc_buy", "Test the postal code of your proprety:",
                      choices = sort(unique(lausanne$location)), 
                      selected = "1000"),
          
          sliderInput("room_slide", "Select the number of rooms:", min = 1, max = 10,
                      value = 2.5, step = 0.5),
          
          sliderInput("square_slide", "Select the squares meters:", min = 10, max = 600,
                      value = 50, step = 10),
          
          sliderInput("k", "Select how many options should be given:", min = 1, max = 20,
                      value = 5, step = 1)
          
        ),
        
        #Specify the output of the second panel
        mainPanel(
          DT::dataTableOutput("table")
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output) {

 #Table for knn
  output$table <- DT::renderDataTable({
    
    table_knn <- find_nearest_neighbors(input$room_slide, input$square_slide, input$selected_loc_buy, lausanne, input$k)
    
    table_knn
  })
  
  
  
  #Price estimation
  
 
  rooms <- reactive(input$rooms_sel) %>% bindEvent(input$calc_sel)
  meters <- reactive(input$meter_sel) %>% bindEvent(input$calc_sel)
  loc <- reactive(input$selected_loc_sel) %>% bindEvent(input$calc_sel)
  
  output$estimation <- renderPrint({
    estimate <- estimate_price(rooms(), meters(), loc())
    results <- paste0("<p>The estimated rent of your desired house/flat is: <strong>", round(estimate[1],3), " </strong>CHF.")
    results2 <- paste0("This estimation ranges from <strong>", round(estimate[2],3), "</strong>CHF to <strong>", round(estimate[3],3), "</strong>CHF.</p><br><br><p>
                       Below you will find the change in rent per location for your desired house features <br>You can click on any point to get rent details.</p>")
   
    # Use HTML tags to create a line break
    HTML(paste(results, results2, sep = "<br><br>"))
    
  })
  
  
  
  
  #Price estimation with all param fixed but Location
  
  unique_loc <- sort(unique(lausanne$location))
  
  
  # Set empty data frame for price estimation
  price_loc <- data.frame("Location" = as.factor(unique_loc), "Estimate" = numeric(length(unique_loc)),
                          "Lower" = numeric(length(unique_loc)), "Upper" = numeric(length(unique_loc)))
  


  #Plot the 
  output$plot <- renderPlot({
    
    #Loop through all location to get estimate and update price_loc
    for (loc in unique_loc) {
      
      index <- which(price_loc$Location == loc)
      
      estimate <- estimate_price(rooms(), meters(), location = loc)
      price_loc$Estimate[index] <- estimate[1]
      price_loc$Lower[index] <- estimate[2]
      price_loc$Upper[index] <- estimate[3]
      
      
      
    }
    
    
    ggplot(price_loc, aes(x = Location, y = Estimate, group = 1)) +
      geom_point(aes(color = "Rent estimation"), size = 4, shape = 20) +
      geom_line(linetype = "dashed", linewidth = 0.5) +
      geom_ribbon(aes(fill = "95% rent range", ymin = Lower, ymax = Upper), alpha = 0.1) +
      labs(title = "",
           x = "Postal Code", y = "Estimated Rent (CHF)",
           color = "Legend", fill = "Legend") +
      scale_color_manual(values = c("Rent estimation" = "red")) +
      scale_fill_manual(values = c("95% rent range" = "blue")) +
      theme_minimal()
  
  }, res = 96)
  #end output$plot
  
  
  output$data <- renderTable({
    
    #Loop through all location to get estimate and update price_loc
    for (loc in unique_loc) {
      
      index <- which(price_loc$Location == loc)
      
      estimate <- estimate_price(rooms(), meters(), location = loc)
      price_loc$Estimate[index] <- estimate[1]
      price_loc$Lower[index] <- estimate[2]
      price_loc$Upper[index] <- estimate[3]
   
    }
    
    nearPoints(price_loc, input$plot_click)
    
    })
    #end output$data
  
}



# Run the app
shinyApp(ui, server)