# Project-Group-B

## Overview 🇨🇭

`immoswiss` designed for estimating property prices in Lausanne using a Multiple Linear Regression model and K-Nearest Neighbors to find the most similar properties on the market 🏠. Additionally, the package allows users to visualize the effect of each criterion on the estimated price.

## Methodology 

The package includes four functions : 

1. `estimate_price` predicts properties prices based on :
    - 🛌 the number of rooms
    - 🏠square meters
    - 📍 location (zip code)
using a multiple linear regression model. The model, built on webscrapped data from Lausanne, treats location as a categorical variable, with zip code 1004 serving as the reference level.The function uses this model to estimate prices for the specified input values, considering the unique impact of each variable. 

2. `nearest_neighbor`🏠 function identifies the k nearest neighbors in a dataset based on : the number of rooms (nb_rooms), the number of square meters (meter_square), and the location (location). This function is useful for finding similar properties in terms of rooms, square meters, and location, aiding in property comparison and recommendation.

3. `plot`📈 function provides a visualization of the effect of every variable on the estimated price of properties in Lausanne. 

4. `launch_shiny_app`💻 function facilitates the launch of a Shiny web application. It does so by specifying the path to the Shiny app directory within the "immoswiss" package.It provides a convenient interface for interacting with the functionalities offered by the "immoswiss" package.

## Installation 

```r
devtools::install_github("ptds2023/Project-Group-B")
```

## Dependencies 

- `shiny` 
- `ggplot`

## Website 

Here is the website of our shinyapp : https://ptds2023.github.io/Project-Group-B/


