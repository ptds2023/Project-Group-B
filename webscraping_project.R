library(rvest)
library(dplyr)

# Function to scrape a single page and extract required information
scrap_page <- function(page_num) {
  url <- paste0("https://www.immoscout24.ch/en/real-estate/rent/city-lausanne?pn=", page_num)
  webpage <- read_html(url)
  
  flats <- webpage %>% html_nodes("h3:first-child") %>% html_text()
  flats <- flats[-c((length(flats)-5):length(flats))] # Remove the last six elements
  
  # Extracting rooms, square meters, and price
  rooms <- gsub(pattern = " room.*", "", flats) %>% as.numeric()
  meter_square <- gsub(".*rooms?, | m².*","",flats) %>% as.numeric()
  price <- gsub(".*CHF |.—.*", "", flats) %>%
    gsub(pattern = ",", replacement = "") %>%
    as.numeric()
  location_with_map <- webpage %>% html_nodes("#root > div.Box-cYFBPY.Flex-feqWzG.icgscM.dCDRxm > main > div > div.Box-cYFBPY.Content-d6uy11-0.gDehxi.caJNRl > div.Box-cYFBPY.Flex-feqWzG.cJSTpL.dCDRxm > article > a > div.Body-jQnOud.bjiWLb > div > div.Box-cYFBPY.Flex-feqWzG.MetaBody-iCkzuU.JVKAR.dCDRxm.dUKbXG > div > address > button > span
") %>% html_text()
  location_without_map <- webpage %>% html_nodes("#root > div.Box-cYFBPY.Flex-feqWzG.icgscM.dCDRxm > main > div > div.Box-cYFBPY.Content-d6uy11-0.gDehxi.caJNRl > div.Box-cYFBPY.Flex-feqWzG.cJSTpL.dCDRxm > article > a > div.Body-jQnOud.bjiWLb > div > div.Box-cYFBPY.Flex-feqWzG.MetaBody-iCkzuU.JVKAR.dCDRxm.dUKbXG > div > address > span > span
") %>% html_text()
  
  # Combine both sets of locations
  locations <- c(location_with_map, location_without_map)
  locations <- as.numeric(sub(".*(\\d{4}).*", "\\1", locations))
  

  # Create a data frame for this page's data
  page_data <- data.frame(
    rooms = rooms,
    meter_square = meter_square,
    price = price,
    location = locations
  )
  
  return(page_data)
}

# Initialize an empty list to store data frames for each page
all_pages_data_lausanne <- list()

# Loop through pages 1 to 12 and scrape data
for (page_num in 1:12) {
  page_data <- scrap_page(page_num)
  all_pages_data_lausanne[[page_num]] <- page_data
  rm(page_data)
}

# Combine data from all pages into a single data frame
lausanne <- do.call(rbind, all_pages_data_lausanne) %>% na.omit()

