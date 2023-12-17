library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Find your selling price"),
  sidebarLayout(
    sidebarPanel(
      numericInput("location","Enter Zipcode :", ""),
      numericInput("meter_square", "Enter Number of square meters :", ""),
      numericInput("rooms","Enter Number of rooms :", ""),
      actionButton("", "Calculate")
    ),
    mainPanel(
      h4("Result:"),
      verbatimTextOutput("result")
    )
  )
)

# Define server logic
server <- function(input, output) {
  observeEvent(input$calculate, {
    postal_code <- input$postal_code
    num_rooms <- input$num_rooms
    
    # Validate postal code (you might want to improve this validation)
    if (!grepl("^\\d{4}$", postal_code)) {
      return(showNotification("Invalid postal code. Please enter a 4-digit code.", type = "warning"))
    }
    ############# Remplacer la function    ############# 
    result <- as.numeric(postal_code) + num_rooms
    #########################################################
    
    output$result <- renderText({
      paste("Sum: ", result)
    })
  })
}

# Run the app
shinyApp(ui, server)

