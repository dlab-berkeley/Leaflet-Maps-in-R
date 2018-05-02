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

## ---- eval=F-------------------------------------------------------------
## ?addProviderTiles

## ------------------------------------------------------------------------
leaflet() %>% addProviderTiles("CartoDB.Positron") %>% 
    setView(lat=37.870044, lng=-122.258169, zoom = 12)

## ---- eval=T, results='hide'---------------------------------------------
mapurl <- "https://mapwarper.net/maps/tile/25477/{z}/{x}/{y}.png"

map2 <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addTiles(mapurl) %>%  # custom map image
  setView(lat=37.870044, lng=-122.258169, zoom = 13)
   

## ------------------------------------------------------------------------
map2  # Map of Berkeley, 1880 overlaid on the CartoDB basemap

## ------------------------------------------------------------------------
map3 <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  #setView(lat=37.870044, lng=-122.258169, zoom = 17) %>%
  addMarkers(lat=37.870044, lng=-122.258169, popup="Go Bears!")


## ------------------------------------------------------------------------
map3  # Display the map  - Click on the marker

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
map4    # How did we map the data frame?

## ------------------------------------------------------------------------
popup_content <- paste("<b>Address:</b>", sfhomes$Address,"<br>", 
                       "<b>Property Value</b>: ", sfhomes$Value, "<br>",
                       "<b>Neighborhood:</b> ", sfhomes$Neighborhood, "<br>",
                       "<b>Num Bedrooms: </b>", sfhomes$NumBeds, "<br>",
                       "<b>Num Bathrooms:</b>", sfhomes$NumBaths
                       )



map4 <- leaflet() %>%
          addTiles() %>%   
          addMarkers(lat=sfhomes$lat, lng=sfhomes$lon, 
                     popup= popup_content)

## ------------------------------------------------------------------------
leaflet() %>%  addTiles() %>%   
      addMarkers(lat=sfhomes$lat, lng=sfhomes$lon, popup= popup_content)

## ---- eval=F-------------------------------------------------------------
## leaflet() %>%
##   addTiles() %>%
##   addMarkers(lat=sfhomes$lat, lng=sfhomes$lon, popup= popup_content)

## ---- eval=F-------------------------------------------------------------
## leaflet(sfhomes) %>%
##   addTiles() %>%
##   addMarkers(~lon, ~lat, popup = popup_content)

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

## ---- eval =F------------------------------------------------------------
## colorFactor(palette, domain, levels = NULL, ordered = FALSE,
##   na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ---- message=T, warning=T-----------------------------------------------
# Create a qualitative color palette
myColors <- colorFactor("Paired", sfhomes$Neighborhood) 

## ---- message=F----------------------------------------------------------
myColors <- colorFactor("Paired", sfhomes$Neighborhood) 
the_color_values <- myColors(sfhomes$Neighborhood)
length(the_color_values)
length(the_color_values) == length(sfhomes$Neighborhood)
unique(the_color_values)


## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat,  
             popup= popup_content,
             ###<b>
             fillColor= ~myColors(Neighborhood),
             ###</b>
             radius=6, color=NA, weight=2, fillOpacity = 1
             )

## ------------------------------------------------------------------------
map4  # what neighborhood has the most 2015 transactions?

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
             fillColor= ~myColors(Neighborhood),
             radius=6, color=NA, weight=2,fillOpacity = 1
             ) %>%
      ### <b>
      addLegend(title = "Neighborhood", pal =  myColors,
                values = ~Neighborhood, opacity = 1, 
                position="bottomleft")
      ### </b>

## ------------------------------------------------------------------------
map4 

## ------------------------------------------------------------------------
display.brewer.all(type="seq")

## ---- eval=F-------------------------------------------------------------
## colorNumeric(palette, domain, na.color = "#808080", alpha = FALSE,
##   reverse = FALSE)

## ------------------------------------------------------------------------
numColors <- colorNumeric("Reds", sfhomes$Value)

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~numColors(Value),
            ### </b>
             radius=6, color="grey", weight=1, fillOpacity = 1
             ) %>%
      addLegend(title = "Property Values", pal =  numColors,
                values = ~Value, opacity = 1, 
                position="bottomleft")
      

## ------------------------------------------------------------------------
map4  # proportional color map

## ---- eval=F-------------------------------------------------------------
## colorQuantile(palette, domain, n = 4,
##   probs = seq(0, 1, length.out = n + 1),
##   na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ------------------------------------------------------------------------
# Use colorQuantile to create a color function for the data
quantColors <- colorQuantile("Reds", sfhomes$Value, n=5)

# Use the color function in the leaflet map
map4b <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~quantColors(Value),
            ### </b>
             radius=6, color="grey", weight=1,fillOpacity = 1
             ) 



## ------------------------------------------------------------------------
map4b  # Graduated color map

## ------------------------------------------------------------------------
map4b %>%  addLegend(title = "Value", pal =  quantColors,
                values = ~Value, opacity = 1, 
                position="bottomleft")

## ------------------------------------------------------------------------

map5 <-map4b %>%   addLegend(pal = quantColors, values = ~Value,
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

## ---- echo=F-------------------------------------------------------------
leaflet(sfhomes, width="300px", height="300px") %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
             fillColor= ~numColors(Value),
             radius=6, color="grey", weight=1, fillOpacity = 1
             ) 

leaflet(sfhomes, width="300px", height="300px") %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
             fillColor= ~quantColors(Value),
             radius=6, color="grey", weight=1,fillOpacity = 1
             ) 

## ------------------------------------------------------------------------
sfhomes_low2high <- sfhomes[order(sfhomes$Value, decreasing = FALSE),]

map5 <- leaflet(sfhomes_low2high) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~quantColors(Value),
            ### </b>
             radius=6, color="grey", weight=1,fillOpacity = 1
             ) 


## ------------------------------------------------------------------------
map5  # points reordered from low to high value

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
quantColors <- colorQuantile("YlOrRd", sf_md_hhi$estimate, n=5)

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
              fillColor=~quantColors(estimate), 
              fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate))
   ### </b>

## ------------------------------------------------------------------------
map6  # choropleth map of median household income by census tract

## ------------------------------------------------------------------------
map6 <- map6 %>% addLegend(pal = quantColors, 
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
              fillColor=~quantColors(estimate), fillOpacity = 0.65,
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
              fillColor=~quantColors(estimate), fillOpacity = 0.65,
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
              fillColor=~quantColors(estimate), fillOpacity = 0.65,
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

## ---- eval=F, echo=F-----------------------------------------------------
## ## Output code to script
## library(knitr)
## purl("leaflet-webmaps-in-R_sp2018-slides.Rmd", output = "leaflet-webmaps-in-r-sp2018.R", documentation = 1)
## 

