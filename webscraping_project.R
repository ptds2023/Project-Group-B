library(rvest)
library(dplyr)

url <- "https://www.immoscout24.ch/en/real-estate/rent/city-lausanne?pn="
webpage <- read_html(url)
location <- webpage %>% html_nodes("#root > div.Box-cYFBPY.Flex-feqWzG.icgscM.dCDRxm > main > div > div.Box-cYFBPY.Content-d6uy11-0.gDehxi.caJNRl > div.Box-cYFBPY.Flex-feqWzG.cJSTpL.dCDRxm > article > a > div.Body-jQnOud.bjiWLb > div > div.Box-cYFBPY.Flex-feqWzG.MetaBody-iCkzuU.JVKAR.dCDRxm.dUKbXG > div > address > button > span
") %>% html_text() 


# Function to scrape a single page and extract required information
scrap_page <- function(page_num) {
  url <- paste0("https://www.immoscout24.ch/en/real-estate/rent/city-lausanne?pn=", page_num)
  webpage <- read_html(url)
  
  flats <- webpage %>% html_nodes("h3:first-child") %>% html_text()
  flats <- flats[-c((length(flats)-5):length(flats))] # Remove the last six elements
  location <- webpage %>% html_nodes("#root > div.Box-cYFBPY.Flex-feqWzG.icgscM.dCDRxm > main > div > div.Box-cYFBPY.Content-d6uy11-0.gDehxi.caJNRl > div.Box-cYFBPY.Flex-feqWzG.cJSTpL.dCDRxm > article > a > div.Body-jQnOud.bjiWLb > div > div.Box-cYFBPY.Flex-feqWzG.MetaBody-iCkzuU.JVKAR.dCDRxm.dUKbXG > div > address > button > span
") %>% html_text()
  # Extracting rooms, square meters, and price
  rooms <- gsub(pattern = " room.*", "", flats) %>% as.numeric()
  meter_square <- gsub(".*rooms?, | m².*","",flats) %>% as.numeric()
  price <- gsub(".*CHF |.—.*", "", flats) %>%
    gsub(pattern = ",", replacement = "") %>%
    as.numeric()
  location <- location %>% gsub("\\D","", gsub("(\\d{4}).*","\\1", location)
  
  
  # Create a data frame for this page's data
  page_data <- data.frame(
    rooms = rooms,
    meter_square = meter_square,
    price = price,
    location = location
  )
  
  return(page_data)
}

# Initialize an empty list to store data frames for each page
all_pages_data <- list()

# Loop through pages 1 to 12 and scrape data
for (page_num in 1:12) {
  page_data <- scrape_page(page_num)
  all_pages_data[[page_num]] <- page_data
}

# Combine data from all pages into a single data frame
combined_data <- do.call(rbind, all_pages_data)

