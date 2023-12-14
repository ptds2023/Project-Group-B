library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Add Postal Code and Number of Rooms"),
  sidebarLayout(
    sidebarPanel(
      textInput("postal_code", "Enter Postal Code:", ""),
      numericInput("num_rooms", "Enter Number of Rooms:", 0),
      actionButton("calculate", "Calculate")
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

