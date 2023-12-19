library(shiny)

lausanne <- read.csv("immoswiss/data/lausanne.csv")

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
    id = "main_navbar",
    
    # Define the first panel (title)
    tabPanel(
      "Estimate the price",
      id = "estimation",
      
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
          h4("Result:"),
          verbatimTextOutput("result"),
          plotOutput("result")
        )
      )
    ),
    #Define the second panel (title)
    tabPanel(
      "Explore your option",
      id = "explore",
      
      #Specify input button for the second panel
      sidebarLayout(
        sidebarPanel(
          selectInput("selected_loc_buy", "Test the postal code of your proprety:",
                      choices = sort(unique(lausanne$location)), 
                      selected = "1000"),
          
          sliderInput("room_slide", "Select the number of rooms:", min = 1, max = 10,
                      value = 2.5, step = 0.5),
          
          sliderInput("sqaure_slide", "Select the squares meters:", min = 10, max = 600,
                      value = 50, step = 10)
          
        ),
        
        #Specify the output of the second panel
        mainPanel(
          h4("Test:"),
          verbatimTextOutput("Test")
        )
      )
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