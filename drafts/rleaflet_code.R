# install.packages("tidyverse")
# library(tidyverse)


library(leaflet)

setwd("~/Documents/Dlab/workshops/2018/rleaflet")

# Our first map - 3 components
map1 <- leaflet()
map1 <- addTiles(map1)
map1 

## Setting the view
map1 <- setView(map1, lat=37.870044, lng=-122.258169, zoom = 17)
map1

# Piping Syntax
#Requires dplyr or magrittr
map2 <- leaflet() %>%
        addTiles() %>%  # Add default OpenStreetMap map tiles
        setView(lat=37.870044, lng=-122.258169, zoom = 12)
map2  # Display the map

## Zoom in closer

# Rerun the code with larger zoom level
# What specifically is the map centered on?


###Check out `?addProviderTiles`

# Try a few
map2 <- leaflet() %>%
        addProviderTiles("Esri.WorldStreetMap") %>%  # Add  map tiles
        setView(lat=37.870044, lng=-122.258169, zoom = 12)
map2  # Display the ma

## Customize the basemap
## more custom
mapurl <- "https://mapwarper.net/maps/tile/16198/{z}/{x}/{y}.png"
mapurl2 <- "https://mapwarper.net/maps/tile/25477/{z}/{x}/{y}.png"

map2 <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addTiles(mapurl2) %>%  # custom
  setView(lat=37.870044, lng=-122.258169, zoom = 12)
map2  # Display the ma

## Add a marker

map2 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  #setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  addMarkers(lat=37.870044, lng=-122.258169, popup="Go Bears!")
map2  # Display the map

## Add a lot of markers!
# https://datasf.org/opendata/
# https://data.sfgov.org/Public-Safety/Police-Department-Incidents/tmnf-yvry
# https://data.sfgov.org/Public-Safety/Police-Department-Incidents-Current-Year-2018-/956q-2t7k
#library(jsonlite)
#crimes <- fromJSON("https://data.sfgov.org/resource/956q-2t7k.json")
crimes <- read.csv("data/Police_Department_Incidents_-_Current_Year__2018_.csv", stringsAsFactors = F, strip.white = T)
str(crimes)

## map it
map4 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  #setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  addMarkers(lat=as.numeric(crimes$Y), lng=as.numeric(crimes$X), popup= crimes$Descript)
map4  # Display the map

## addMarkers syntax

## map it
map4 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  #setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  addMarkers(lat=as.numeric(crimes2$Y), lng=as.numeric(crimes2$X), popup= crimes2$Descript)
map4  # Display the map

## Circles
library(dplyr)
crimesub <- sample_n(crimes,500)
map5 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  # setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  # addMarkers(lat=as.numeric(crimes2$Y), lng=as.numeric(crimes2$X), popup= crimes2$Descript)
  addCircleMarkers(lat=as.numeric(crimesub$Y), lng=as.numeric(crimesub$X), popup= crimesub$Descript)
map5  # Display the map

## addCirleMarker syntax

## Cluster
map5 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  # setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  # addMarkers(lat=as.numeric(crimes2$Y), lng=as.numeric(crimes2$X), popup= crimes2$Descript)
  addCircleMarkers(lat=as.numeric(crimesub$Y), lng=as.numeric(crimesub$X), popup= crimesub$Descript,
                   clusterOptions=1)
map5  # Display the map

## Change the data
table(crimesub$Category)
ckeep <- c("ASSAULT","BURGLARY","DRUG/NARCOTIC","LARCENY/THEFT","MISSING PERSON","ROBBERY","VANDALISM","VEHICLE THEFT","FRAUD","OTHER OFFENSES","SEX OFFENSES, FORCIBLE")
crimesub2 <- crimesub[crimesub$Category %in% ckeep,]
violent <- c("ASSAULT","BURGLARY","ROBBERY","VEHICLE THEFT","SEX OFFENSES, FORCIBLE") 
crimesub2$group <-"Non-violent"
crimesub2[crimesub2$Category %in% violent,]$group <- "Violent"
table(crimesub2$Category)
table(crimesub2$group)

## Category mapping
library(RColorBrewer)
display.brewer.all(type="qual")
#offenseColor <- colorFactor(rainbow(25), crimesub$Category)
offenseColor <- colorFactor("Paired", as.factor(crimesub2$Category))

offenseColor

leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(
    data=crimesub2,
    lat=as.numeric(crimesub2$Y), 
    lng=as.numeric(crimesub2$X),
    stroke = FALSE, fillOpacity = 1, radius=4,
    color = offenseColor(crimesub2$Category),
    popup = paste("<strong>Offense:</strong>",crimesub2$Category,
                   "<br>",
                   "<strong>Date:</strong>",crimesub2$Date,
                   "<br>",
                   "<strong>Time:</strong>",crimesub2$Time)
  ) %>%
  addLegend(title = "Type of Offense", pal = offenseColor,
            values = crimesub2$Category, opacity = 1, position="bottomleft")

## Day of week
dayColor <- colorFactor("Paired", as.factor(crimesub2$DayOfWeek))
leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(
    data=crimesub2,
    lat=as.numeric(crimesub2$Y), 
    lng=as.numeric(crimesub2$X),
    stroke = FALSE, fillOpacity = 1, radius=4,
    color = dayColor(crimesub2$DayOfWeek),
    popup = paste("<strong>Offense:</strong>",crimesub2$Category,
                  "<br>",
                  "<strong>Date:</strong>",crimesub2$Date,
                  "<br>",
                  "<strong>Time:</strong>",crimesub2$Time)
  ) %>%
  addLegend(title = "Day of Week", pal = dayColor,
            values = crimesub2$DayOfWeek, opacity = 1, position="bottomleft")




## Crime groups

## Layer Switcher

## Shapefiles
# Read in
# plot
# style
# choropleth

# overlay clustered crimes?

# Rpub

# Shiny

# tmap

#install.packages("tidycensus")
library(tidycensus)
options(tigris_use_cache = TRUE)
census_api_key("f2d6f4f743545d3a42a67412b05935dc7712c432")
sanfran <- get_acs(geography = "tract", 
              variables = "B19013_001",  #median household income
              state = "CA", 
              county = "San Francisco", 
              geometry = TRUE,
              cb=TRUE)

map2 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  setView(lat=37.768687, lng=-122.443437, zoom = 12)
map2  # Display the map

map2 %>%
  addPolygons(data=sanfran)

popup <- paste0("GEOID: ", income_merged$GEOID, "<br>", "Percent of Households above $200k: ", round(income_merged$percent,2))
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = sanfran$estimate
)

map2 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  setView(lat=37.768687, lng=-122.443437, zoom = 12) %>%
  addPolygons(data=sanfran,
              fillColor = ~pal(estimate), 
              color = "#b2aeae", # Outline color - you need to use hex values 
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = as.character(estimate) ) %>%
  addLegend(pal = pal, 
          values = sanfran$estimate, 
          position = "bottomright", 
          title = "Median HH Income") 
map2

library(sp)
med_hh_inc <-as(sanfran, 'Spatial')

library(sf)
st_write(sanfran, "sf_medhhincome_acs5y_16.shp")
