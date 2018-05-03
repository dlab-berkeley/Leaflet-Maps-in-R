# Load packages
library(shiny)
#library(ggplot2)
library(tidyverse)
library(DT)
library(leaflet)

#setwd("~/Documents/Dlab/workshops/2018/r-leaflet-workshop/leaflet-shiny-test")

# Load data
sfhomes<-read.csv('sfhomes15.csv')

# Define UI for application that plots features of movies
ui <- fluidPage(
  
  titlePanel("San Franciso Property Values, 2015 Tax Assessor Data"),
  
  br(),
  
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    # Inputs
    sidebarPanel(

      sliderInput("valRange", label = h3("Property value:"),
                  min = min(sfhomes$Value), 
                  max = max(sfhomes$Value), 
                  value=range(sfhomes$Value)),
      
      br(),
      h4("References"),
      p("Data: SFData.gov"),
      p("Demo for D-Lab workshop")
    ),
    
    # Output:
    mainPanel(
      # Show scatterplot with brushing capability
      #leafletOutput(outputId = "mymap", hover = "plot_hover"),
      leafletOutput(outputId = "mymap"),
      
      # Show data table
      dataTableOutput(outputId = "sfhomestable"),
      br()
    )
)
)


# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create reactive data frame based on property value
   sfhomes_selected <- reactive({
      sfhomes[sfhomes$Value >= input$valRange[1] & sfhomes$Value < input$valRange[2],]
      
      })

  # Create scatterplot object the plotOutput function is expecting
  output$mymap <- renderLeaflet({
    popup_content <- paste("<b>Address:</b>", sfhomes_selected()$Address,"<br>", 
                           "<b>Property Value</b>: ", sfhomes_selected()$Value, "<br>",
                           "<b>Neighborhood:</b> ", sfhomes_selected()$Neighborhood, "<br>",
                           "<b>Num Bedrooms: </b>", sfhomes_selected()$NumBeds, "<br>",
                           "<b>Num Bathrooms:</b>", sfhomes_selected()$NumBaths
    )
    
    #leaflet(sfhomes) %>%
    leaflet(sfhomes_selected()) %>%
      addTiles() %>%   
      addCircleMarkers(~lon, ~lat, popup = popup_content,
                       color="white", radius=6, weight=2,
                       fillColor="red",fillOpacity = 0.75)
    
  })
  
  # Create data table
  output$sfhomestable <- DT::renderDataTable({
       sfhomes_selected() %>% select(Address, Neighborhood, Value,YrBuilt)
   })
  
}

# Create a Shiny app object
shinyApp(ui = ui, server = server)