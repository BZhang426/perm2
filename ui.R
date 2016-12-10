library(shiny)
library(shinythemes)
library(tidyr)
library(dplyr)
library(plyr)
library(readr)
library(ggplot2)
library(sqldf)
library(leaflet)
require(leaflet)

shinyUI(fluidPage(
  theme = shinytheme("superhero"),
  ## title
  titlePanel(title=div(img(src="logo.png",height=80,width=160),
                       "MS in Statistical Practice: Homeless People of Boston")),
  
  ## all panels
  tabsetPanel(              
    ## Home page
    tabPanel(title = "Home Page",img(src="cover2.png",width="100%",height="100%"),
             style = "background-color: #BCC6CC;"
    ),
    
    ## spatial panel      
    tabPanel(title = "Spatial",
             tabsetPanel(
               tabPanel("911"),
               
               tabPanel("311"),
               
               tabPanel("Police",titlePanel("Page's title"),
                        column(3,wellPanel(radioButtons("plotType", label = h3("Choose the plot"),
                                                        choices = list(Density = "spatial.density.plot",
                                                                       Dot = "spatial.dot.plot",
                                                                       Weather = "spatial.weather"), 
                                                        selected = "spatial.density.plot"),
                                           conditionalPanel(
                                             condition = "input.plotType == 'spatial.weather'",
                                             selectInput("select.weather", label = h5("Choose the weather condition"), 
                                                         choices = list(Low = "low", Medium = "medium", High = "high"), 
                                                         selected = F)
                                             
                                           ),
                                           
                                           conditionalPanel(
                                             condition = "input.plotType == 'spatial.dot.plot'",
                                             selectInput("bg", label = h5("Choose the map type"), 
                                                         c("Positron" = "CartoDB.Positron",
                                                           "Open Street Map" = "OpenStreetMap"), 
                                                         selected = F),
                                             selectInput("et", "Event Types:",
                                                         c("Assault" = "1", "Assembly or Gathering Violations" = "2",
                                                           "Disorderly Conduct" = "3","Drug Violation" = "4", 
                                                           "Harassment" = "5", "Liquor Violation" = "6",
                                                           "Medical Assistance" = "7", "Property Damage" = "8", 
                                                           "Prostitution" = "09", "Vandalism" = "10", 
                                                           "Verbal Disputes" = "11"))
                                            
                                             
                                           )
                  
                        )),
                        mainPanel(plotOutput("spatial"),hr(),leafletOutput(outputId="dot"))
                      ))),
    
    ## temporal panel
    tabPanel(title = "Temporal",
             tabsetPanel(
               tabPanel("911",titlePanel("add this page's title"),
                        column(3,wellPanel(selectInput("9",
                                                       "911 data",choices = c("a","b",selected="a")),
                                           checkboxGroupInput("radio","title",
                                                              c("a","b","c","d"),inline = T)
                                           
                        ))
               ),
               
               tabPanel("311"),
               
               tabPanel("Police")
               
             ),
             plotOutput("Weather"))
    
  )))
