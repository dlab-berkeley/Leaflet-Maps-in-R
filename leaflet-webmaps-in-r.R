## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----global_options, include=FALSE---------------------------------------
knitr::opts_chunk$set(fig.width=8, echo=TRUE, warning=FALSE, message=FALSE)

## ---- message=FALSE, warning=FALSE---------------------------------------
library(leaflet)
library(RColorBrewer)
library(sp)
library(rgdal)
library(htmlwidgets)
library(magrittr) # or dplyr

## ---- eval=FALSE---------------------------------------------------------
## # install.packages("leaflet")
## # install.packages("RColorBrewer")
## # install.packages("sp")
## # install.packages("rgdal")
## # install.packages("htmlwidgets")
## # install.packages("magrittr") # or dplyr

## ----eval=F--------------------------------------------------------------
## map1 <- leaflet()       # Initialize the map object
## map1 <- addTiles(map1)  # Add basemap tiles
## map1                    # Display the map

## ------------------------------------------------------------------------
map1 <- leaflet()       # Initialize the map object
map1 <- addTiles(map1)  # Add basemap tiles - default is OpenStreetMap
map1                    # Display the map


## ---- message=FALSE, results="hide"--------------------------------------
map1 <- leaflet() %>%
        addTiles() %>%  
        setView(lat=37.870044, lng=-122.258169, zoom = 15)
map1  

## ------------------------------------------------------------------------
map1  # setView(lat=37.870044, lng=-122.258169, zoom = 15)

## ---- results="hide"-----------------------------------------------------
map2 <- leaflet() %>%
        addTiles() %>%  
        setView(lat=37.870044, lng=-122.258169, zoom = 15)
map2   

## ------------------------------------------------------------------------
map2

## ---- message=F----------------------------------------------------------
leaflet() %>% addTiles() %>% 
           setView(lat=37.870, lng=-122.258, zoom = 15)

## ------------------------------------------------------------------------
map2 <- leaflet() %>%
        addProviderTiles("Esri.WorldStreetMap") %>% 
        setView(lat=37.870044, lng=-122.258169, zoom = 12)
 

## ------------------------------------------------------------------------
map2   #Using ESRI WorldStreetMap basemap

## ------------------------------------------------------------------------
leaflet() %>% addProviderTiles("CartoDB.Positron") %>% 
    setView(lat=37.870044, lng=-122.258169, zoom = 12)

## ---- eval=F-------------------------------------------------------------
## ?addProviderTiles

## ---- echo=F-------------------------------------------------------------
map3 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  #setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  addMarkers(lat=37.870044, lng=-122.258169, popup="Go Bears!")
map3


## ---- eval=F-------------------------------------------------------------
## map3 <- leaflet() %>%
##   addTiles() %>%
##   addMarkers(lat=37.870044, lng=-122.258169, popup="Go Bears!")
## map3

## ---- echo=F-------------------------------------------------------------
map3

## ---- eval=F-------------------------------------------------------------
## map3 <- leaflet() %>%
##   addTiles() %>%
##   #setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
##   addMarkers(lat=37.870044, lng=-122.258169, popup="Go Bears!")
## map3

## ---- eval=F-------------------------------------------------------------
## addMarkers(map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
##   icon = NULL, popup = NULL, popupOptions = NULL, label = NULL,
##   labelOptions = NULL, options = markerOptions(), clusterOptions = NULL,
##   clusterId = NULL, data = getMapData(map))

## ------------------------------------------------------------------------
map3 <- leaflet() %>%
  addTiles() %>%
  addMarkers(lat=37.870044, lng=-122.258169, popup="Go Bears!") %>%
  addMarkers(lat=37.868641, lng=-122.258537, popup="Cafe Milano")
map3

## ------------------------------------------------------------------------
map3 <- leaflet() %>%
  addTiles() %>%
  addMarkers(lat = c(37.870044,37.868641), 
             lng = c(-122.258169,-122.258537),
             popup = c("Go Bears", "Cafe Milano"))

map3

## ------------------------------------------------------------------------
bart <- read.csv('data/bart.csv', stringsAsFactors = FALSE)  
str(bart)

## ---- results="hide"-----------------------------------------------------
map4 <- leaflet() %>%
         addTiles() %>%   
         addMarkers(lat=bart$Y, lng=bart$X, 
         popup= paste("Station:", bart$STATION))
map4

## ------------------------------------------------------------------------
map4

## ------------------------------------------------------------------------
dir("data/BART_13/")

## ------------------------------------------------------------------------
library(rgdal)
bart_lines <- readOGR(dsn="data/BART_13",layer="BART_13")

## ------------------------------------------------------------------------
summary(bart_lines)

## ---- results="hide"-----------------------------------------------------
map4 <- leaflet() %>%
         addTiles() %>%   
         addMarkers(lat=bart$Y, lng=bart$X, 
         popup= paste("Station:", bart$STATION)) %>%   
         addPolylines(data=bart_lines, color="red", weight=3)
map4

## ------------------------------------------------------------------------
map4


## ------------------------------------------------------------------------
dir("data/Transit_Service_Areas_2016")

## ------------------------------------------------------------------------
bart_service <- readOGR(dsn="data/Transit_Service_Areas_2016",layer="bart_service_area")

## ------------------------------------------------------------------------
summary(bart_service)

## ---- results="hide"-----------------------------------------------------
map4 <- leaflet() %>%
         addTiles() %>%   
         addMarkers(lat=bart$Y, lng=bart$X, 
         popup= paste("Station:", bart$STATION)) %>%   
         addPolylines(data=bart_lines, color="red", weight=3) %>%
         addPolygons(data=bart_service, color="blue", opacity = 0.6)
map4

## ------------------------------------------------------------------------
map4


## ------------------------------------------------------------------------
#library(htmlwidgets)
saveWidget(map4, file="bartmap.html")

## ------------------------------------------------------------------------
sfhomes <- read.csv('data/sfhomes15.csv', stringsAsFactors = FALSE)  
str(sfhomes)

## ------------------------------------------------------------------------
head(sfhomes)

## ------------------------------------------------------------------------
map4 <- leaflet() %>%
  addTiles() %>%   
  addMarkers(lat=sfhomes$lat, lng=sfhomes$lon, 
            popup= paste("Address:", sfhomes$Address,
                         "<br>", # add line break
                         "Property Value: ", sfhomes$Value))


## ------------------------------------------------------------------------
map4    

## ------------------------------------------------------------------------
popup_content <- paste("<b>Address:</b>", sfhomes$Address,"<br>", 
                       "<b>Property Value</b>: ", sfhomes$Value, "<br>",
                       "<b>Neighborhood:</b> ", sfhomes$Neighborhood, "<br>",
                       "<b>Num Bedrooms: </b>", sfhomes$NumBeds, "<br>",
                       "<b>Num Bathrooms:</b>", sfhomes$NumBaths
                       )

## ------------------------------------------------------------------------

map4 <- leaflet() %>%
          addTiles() %>%   
          addMarkers(lat=sfhomes$lat, lng=sfhomes$lon, 
                     popup= popup_content)

## ------------------------------------------------------------------------
map4

## ---- eval=F-------------------------------------------------------------
## leaflet() %>%
##   addTiles() %>%
##   addMarkers(lat=sfhomes$lat, lng=sfhomes$lon, popup= popup_content)

## ---- eval=F-------------------------------------------------------------
## leaflet(sfhomes) %>%
##   addTiles() %>%
##   addMarkers(~lon, ~lat, popup = popup_content)

## ---- eval=FALSE---------------------------------------------------------
## 
## addMarkers(map, lng = NULL, lat = NULL, layerId = NULL,
##            group = NULL, icon = NULL, popup = NULL,
##            options = markerOptions(),
##            clusterOptions = NULL, clusterId = NULL,
##            data = getMapData(map))

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addTiles() %>%   
  addMarkers(~lon, ~lat, popup= popup_content,
            ###<b>
            clusterOptions = 1)
            ###</b>
 

## ------------------------------------------------------------------------
map4  # Explore the Map - hover over a cluster marker, zoom in.

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addTiles() %>%   
  addCircleMarkers(~lon, ~lat, popup = popup_content)
 

## ------------------------------------------------------------------------

map4 

## ---- eval=F-------------------------------------------------------------
## addCircleMarkers(map, lng = NULL, lat = NULL, radius = 10,
##     layerId = NULL, group = NULL, stroke = TRUE, color = "#03F",
##     weight = 5, opacity = 0.5,
##     fill = TRUE, fillColor = color, ....)

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addTiles() %>%   
  addCircleMarkers(~lon, ~lat, popup = popup_content,
             color="white", radius=6, weight=2,   # stroke
             fillColor="red",fillOpacity = 0.75   # fill
             )

## ------------------------------------------------------------------------
map4 

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
             fillColor= NA, color="Red", weight=1, fillOpacity = 0,
             ###<b>
             radius= ~NumBeds+2
             ###</b>
             )

## ------------------------------------------------------------------------
map4  # Size is a function of what variable?

## ------------------------------------------------------------------------
map4b <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircles(~lon, ~lat, popup=popup_content,
             fillColor= NA, color="Red", 
             weight=1, fillOpacity = 0,
             ###<b>
             radius= ~NumBeds*10
             ###</b>
             )

## ------------------------------------------------------------------------
map4b  # Compare map4 and map4b at different zoom levels

## ------------------------------------------------------------------------
 
display.brewer.all(type="qual") 
display.brewer.pal(7, "Set3" )  # Try a different number of colors

## ------------------------------------------------------------------------
display.brewer.all(type="seq")


## ------------------------------------------------------------------------
display.brewer.all(type="div")

## ------------------------------------------------------------------------
display.brewer.all(type="qual")

## ---- message=T, warning=T-----------------------------------------------
# Create a qualitative color palette
myColor_function <- colorFactor("Paired", sfhomes$Neighborhood) 

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat,  
             popup= popup_content,
             ###<b>
             fillColor= ~myColor_function(Neighborhood),
             ###</b>
             radius=6, color=NA, weight=2, fillOpacity = 1
             )

## ------------------------------------------------------------------------
map4  # what neighborhood had the most 2015 transactions?

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
             fillColor= ~myColor_function(Neighborhood),
             radius=6, color=NA, weight=2,fillOpacity = 1
             ) %>%
      ### <b>
      addLegend(title = "Neighborhood", pal =  myColor_function,
                values = ~Neighborhood, opacity = 1, 
                position="bottomleft")
      ### </b>

## ------------------------------------------------------------------------
map4 

## ---- eval =F------------------------------------------------------------
## colorFactor(palette, domain, levels = NULL, ordered = FALSE,
##   na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ------------------------------------------------------------------------
display.brewer.all(type="seq")

## ------------------------------------------------------------------------
numColor_function <- colorNumeric("Reds", sfhomes$Value)

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~numColor_function(Value),
            ### </b>
             radius=6, color="grey", weight=1, fillOpacity = 1
             ) %>%
      addLegend(title = "Property Values", pal =  numColor_function,
                values = ~Value, opacity = 1, 
                position="bottomleft")
      

## ------------------------------------------------------------------------
map4  # proportional color map

## ---- eval=F-------------------------------------------------------------
## colorNumeric(palette, domain, na.color = "#808080", alpha = FALSE,
##   reverse = FALSE)

## ------------------------------------------------------------------------
quantColor_function <- colorQuantile("Reds", sfhomes$Value, n=5)

## ------------------------------------------------------------------------
map4b <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~quantColor_function(Value),
            ### </b>
             radius=6, color="grey", weight=1,fillOpacity = 1
             ) 



## ------------------------------------------------------------------------
map4b  # Graduated color map

## ---- eval=F-------------------------------------------------------------
## colorQuantile(palette, domain, n = 4,
##   probs = seq(0, 1, length.out = n + 1),
##   na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ------------------------------------------------------------------------
map4b %>%  addLegend(title = "Value", pal =  quantColor_function,
                values = ~Value, opacity = 1, 
                position="bottomleft")

## ------------------------------------------------------------------------

map5 <-map4b %>%   addLegend(pal = quantColor_function, values = ~Value,
                     title = "Property Value, 2015",
                     position="bottomleft",
                     opacity=1,
                     labFormat = function(type, cuts, p) {
                      n = length(cuts)
                      cuts = paste0("$", format(cuts[-n], big.mark=","), 
                              " - ", "$",format(cuts[-1], big.mark=","))
                      }
                   )

## ------------------------------------------------------------------------
map5  # Graduated Color Map

## ------------------------------------------------------------------------
sf_md_hhi <- readOGR(dsn="data",layer="sf_medhhincome_acs5y_16")


## ------------------------------------------------------------------------
summary(sf_md_hhi)

## ------------------------------------------------------------------------
map6 <- leaflet() %>%
  addTiles() %>%
  addPolygons(data=sf_md_hhi)


## ------------------------------------------------------------------------
map6 # using addPolygons to map sf_md_hhi

## ---- eval=F-------------------------------------------------------------
## addPolygons(map, lng = NULL, lat = NULL, layerId = NULL, group = NULL,
##             stroke = TRUE, color = "#03F", weight = 5, opacity = 0.5,
##             fill = TRUE, fillColor = color, fillOpacity = 0.2,
##             dashArray = NULL, smoothFactor = 1, noClip = FALSE,
##             popup = NULL, popupOptions = NULL, label = NULL,
##             labelOptions = NULL, options = pathOptions(),
##             highlightOptions = NULL, data = getMapData(map))

## ------------------------------------------------------------------------
map6 <- leaflet() %>%
  setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
  addProviderTiles("CartoDB.Positron") %>%
  
  # Customize the symbology of the polygons
  addPolygons(data=sf_md_hhi, color="grey", weight=1,
              fillColor="Orange", fillOpacity = 0.25)


## ------------------------------------------------------------------------
map6  # color="grey", weight=1, fillColor="Orange", fillOpacity = 0.25

## ------------------------------------------------------------------------
#display.brewer.all(type="seq") 

## ------------------------------------------------------------------------
##
quantColor_function <- colorQuantile("YlOrRd", sf_md_hhi$estimate, n=5)

## ------------------------------------------------------------------------
map6 <- leaflet() %>%
  setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
  addProviderTiles("CartoDB.Positron") %>%
  # 
  ### <b>
  addPolygons(data=sf_md_hhi, 
              color="white", 
              weight=1, 
              opacity=0.5,
              fillColor=~quantColor_function(estimate), 
              fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate))
   ### </b>

## ------------------------------------------------------------------------
map6  # choropleth map of median household income by census tract

## ------------------------------------------------------------------------
map6 <- map6 %>% addLegend(pal = quantColor_function, 
                   values = sf_md_hhi$estimate,
                   title = "Median HH Income",
                   position="bottomleft",
                   opacity=1,
                   labFormat = function(type, cuts, p) {
                     n = length(cuts)
                     cuts = paste0("$", format(cuts[-n], big.mark=","), 
                             " - ", "$",format(cuts[-1], big.mark=","))
                   }
)

## ------------------------------------------------------------------------
map6

## ------------------------------------------------------------------------
cheap <- sfhomes[sfhomes$Value < 1000000,]

map7 <- leaflet() %>%
  setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
  addProviderTiles("CartoDB.Positron") %>%
  
  # Median household income polygons
  addPolygons(data=sf_md_hhi, color="white", weight=1, opacity=0.5,
              fillColor=~quantColor_function(estimate), fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate)) %>%
  
  # sfhomes points
  addCircleMarkers(data=cheap, popup=paste0("$",cheap$Value),
              color="black",weight=1, radius=6, 
              fillColor="white", fillOpacity = 0.75)


## ------------------------------------------------------------------------
map7  # sfhomes and median household income


## ---- eval=F-------------------------------------------------------------
## ?addLayersControl

## ------------------------------------------------------------------------
map8 <- leaflet() %>%
          setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
          addProviderTiles("CartoDB.Positron") %>%
          addPolygons(data=sf_md_hhi, color="white", weight=1, opacity=0.5,
              fillColor=~quantColor_function(estimate), fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate),
              ### <b>
              group="Median HH Income"
              ### </b>
          ) %>%
          addCircleMarkers(data=cheap, popup=paste0("$",cheap$Value),
              color="black",weight=1, radius=6, 
              fillColor="white", fillOpacity = 0.75,
              ### <b>
              group="Property Values"
              ### </b>
          ) %>%
          ### <b>
          addLayersControl(
            overlayGroups = c("Property Values","Median HH Income"),
            options = layersControlOptions(collapsed = FALSE)
          ### </b>
        )


## ------------------------------------------------------------------------
map8

## ------------------------------------------------------------------------
map8 <- leaflet() %>%
          setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
          addProviderTiles("CartoDB.Positron", group="Simple Basemap") %>%
          addProviderTiles("Esri.WorldStreetMap", group="Streets Basemap")  %>%
          addTiles("", group="No Basemap") %>%  
          #
          addPolygons(data=sf_md_hhi, color="white", weight=1, opacity=0.5,
              fillColor=~quantColor_function(estimate), fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate),
              group="Median HH Income"
          ) %>%
          addCircleMarkers(data=cheap, popup=paste0("$",cheap$Value),
              color="black",weight=1, radius=6, 
              fillColor="white", fillOpacity = 0.75,
              group="Property Values"
          ) %>%
          addLayersControl(
            baseGroups = c("Simple Basemap", "Streets Basemap", "No Basemap"),
            overlayGroups = c("Property Values","Median HH Income"),
            options = layersControlOptions(collapsed = FALSE)
        )


## ------------------------------------------------------------------------
map8

## ------------------------------------------------------------------------
#library(htmlwidgets)
saveWidget(map7, file="testmap.html")

## ---- eval=T, results='hide'---------------------------------------------
mapurl <- "https://mapwarper.net/maps/tile/25477/{z}/{x}/{y}.png"

map2 <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addTiles(mapurl) %>%  # custom map image
  setView(lat=37.870044, lng=-122.258169, zoom = 13)
   

## ------------------------------------------------------------------------
map2  # Map of Berkeley, 1880 overlaid on the CartoDB basemap

