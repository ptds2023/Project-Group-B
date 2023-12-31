---
editor_options: 
  markdown: 
    wrap: sentence
---

# Project-Group-B

## Overview 🇨🇭

`immoswiss` is designed for estimating property prices in Lausanne using a Multiple Linear Regression model and K-Nearest Neighbors to find the most similar properties on the market 🏠.
Additionally, the package allows users to visualize the effect of each criterion on the estimated price.

## Methodology

The package includes three functions :

1.  `estimate_price` predicts properties prices based on :

    -   🛌 the number of rooms
    -   🏠 square meters
    -   📍 location (Postal code) using a multiple linear regression model. The model, built on webscrapped data from Lausanne, treats location as a categorical variable, with zip code 1004 serving as the reference level.The function uses this model to estimate prices for the specified input values, considering the unique impact of each variable. This is an example :

2.  `nearest_neighbor`🏠 function identifies the k nearest neighbors in a dataset based on : the number of rooms (nb_rooms), the number of square meters (meter_square), and the location (location).
    This function is useful for finding similar properties in terms of rooms, square meters, and location, aiding in property comparison and recommendation.

3.  `launch_shiny_app`💻 function facilitates the launch of a Shiny web application.
    It does so by specifying the path to the Shiny app directory within the "immoswiss" package.
    It provides a convenient interface for interacting with the functionalities offered by the "immoswiss" package.
    The Shiny app, 'Lausanne Real Estate Market Analysis,' provides users with two interactive tabs:

    -   `Estimate the price` allows users to input the postal code, number of rooms, and square meters to calculate the estimated house price.
        Additionally, a plot is created.
        In this plot, we visualize the estimated rent prices for different postal codes in Lausanne based on a fixed set of input parameters (number of rooms and square meters).
        The points on the plot represent the estimated rent for each postal code, with a dashed line connecting them.
        Additionally, a shaded area around each point represents a 95% confidence interval for the estimated rent.
        The color legend indicates whether it's a point for rent estimation or the confidence interval range.
        As you interact with the plot, clicking on points will provide you with details about the estimated rent and confidence interval for the selected postal code.
        The table below the plot dynamically updates to display the nearest data frame entry based on your interactions.
        This visualization helps users understand how estimated rent prices vary across different postal codes in Lausanne, providing insights into the real estate market.

    -   `Explore your options` allows users to use `nearest_neighbor` based on their requirements.
        In this table, we present the top K nearest neighbors for a property with specified characteristics.
        The user inputs the desired number of rooms, square meters, location postal code and the number K of neighbors.
        The table then displays the K properties from the dataset that are most similar to the user's input, providing a convenient way to explore and compare properties based on these criteria.

The data comes from the immoscout website.
We have scraped the data from Lausanne properties and stored it in the `lausanne` dataset.
The `lausanne` dataset is included in our package and is the dataset that should be used by users.

## Installation

You can install immoswiss from GitHub using the devtools package.
If you don't have devtools installed, you can install it by running:

``` r
install.packages("devtools")
devtools::install_github("ptds2023/Project-Group-B/immoswiss")
```

## Usage of the package

These are simple example that demonstrates how to use the functions of our package.
Keep in mind that the main goal is to use those functions in the shiny app.

``` r
#Find the 10 properties that are most similar to this hypothetical property with 5 rooms, 210 meter squares in location (Postal code) 1004:
find_nearest_neighbors(5, 210, "1004", lausanne, k = 10)

#Estimate the rental price of a property with 2 rooms, 100 meter squares and a postal code equal to 1000
estimate_price(2, 100, 1000, lausanne)

#Launch the app 
launch_shiny_app()
```

The 4th argument `lausanne` is the name of the dataset that is already loaded in the package.

## Website

Here is the website of our package :

[Visit the Website]( https://ptds2023.github.io/immoswiss1/)

