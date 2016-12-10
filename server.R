library(shiny)
library(tidyr)
library(dplyr)
library(plyr)
library(readr)
library(ggplot2)
library(sqldf)
library(ggmap)
library(rgdal)
library(scales)
library(ggthemes)
library(leaflet)
require(leaflet)


boston_map <- get_map(location = "Mass Ave/Albany st.", zoom = 12)
save(boston_map,police,file="boston_map.Rdata")
load("boston_map.Rdata")
# density plot
police_density <- ggmap(boston_map, extent = "device") + geom_density2d(data = police, aes(x = LONG, y = LAT), size = 0.3) + 
  stat_density2d(data = police, 
                 aes(x = LONG, y = LAT, fill = ..level.., alpha = ..level..), size = 0.01, 
                 bins = 16, geom = "polygon") + scale_fill_gradient(low = "green", high = "red") + 
  scale_alpha(range = c(0, 0.3), guide = FALSE)


# dot plot
library(leaflet)

### Background : Boston
m=leaflet() %>% addTiles() %>% setView( lng = -71.073689, lat = 42.333539,  zoom = 10 ) %>% addTiles()
pal <- colorFactor(c("navy", "red"), domain = c("0", "1"))
police_ij <- subset(police, eventindex=="1" & extremday=="0") #for shinny, i=c(1:11), j=c(0,1,2)
pm <- leaflet(data = police_ij) %>% addTiles() %>% #addProviderTiles("CartoDB.Positron") %>% # Stamen.Toner/CartoDB.Positron
  setView( lng = -71.073689, lat = 42.333539,  zoom = 11 )  %>%
  addCircles(~-71.073689, ~42.333539, radius=380, 
             color="grey", stroke = TRUE, fillOpacity = 0.3) %>%
  addCircles(~LONG, ~LAT, radius = ~ifelse(within.25 == "0", 30, 30),  
             color = ~pal(within.25), stroke = FALSE, fillOpacity = 0.5) 
#Serve body

shinyServer(function(input, output) {
  
  
  output$spatial <- renderPlot({
    switch(input$plotType,
           "spatial.density.plot" = police_density)})
  
  output$dot = renderLeaflet({
    pal <- colorFactor(c("navy", "red"), domain = c("0", "1"))
    switch(input$plotType,
          "spatial.dot.plot"=leaflet(data = subset(police, eventindex==input$et)) %>% addProviderTiles(input$bg) %>%
               setView( lng = -71.073689, lat = 42.333539,  zoom = 11 )  %>%
               addCircles(~-71.073689, ~42.333539, radius=380, 
                          color="grey", stroke = TRUE, fillOpacity = 0.3) %>%
               addCircles(~LONG, ~LAT, radius = ~ifelse(within.25 == "0", 30,30),  
                          color = ~pal(within.25), stroke = FALSE, fillOpacity = 0.5) 
          )})
    
  })
  