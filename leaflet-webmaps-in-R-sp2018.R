## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ---- echo=FALSE, fig.height=3, fig.width=10.25, message=FALSE, warning=FALSE----
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(htmlwidgets)
library(magrittr)

leaflet() %>% addTiles()

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

## ---- message=FALSE, results="hide"--------------------------------------
map1 <- leaflet()       # Initialize the map object
map1 <- addTiles(map1)  # Add basemap tiles
map1                    # Display the map

## ---- echo=F-------------------------------------------------------------
# map1 <- leaflet()       # Initialize the map object
# map1 <- addTiles(map1)  # Add basemap tiles - default is OpenStreetMap
map1                    # Display the map


## ---- message=FALSE, results="hide"--------------------------------------
map1 <- setView(map1, lat=37.870044, lng=-122.258169, zoom = 15)
map1

## ---- echo=F-------------------------------------------------------------
map1

## ---- results="hide"-----------------------------------------------------
map2 <- leaflet() %>%
        addTiles() %>%  
        setView(lat=37.870044, lng=-122.258169, zoom = 15)
map2   

## ------------------------------------------------------------------------
map2

## ------------------------------------------------------------------------
map2 <- leaflet() %>%
        addProviderTiles("Esri.WorldStreetMap") %>% 
        setView(lat=37.870044, lng=-122.258169, zoom = 12)
 

## ------------------------------------------------------------------------
map2

## ------------------------------------------------------------------------
mapurl <- "https://mapwarper.net/maps/tile/25477/{z}/{x}/{y}.png"

map2 <- leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addTiles(mapurl) %>%  # custom
  setView(lat=37.870044, lng=-122.258169, zoom = 13)
   

## ------------------------------------------------------------------------
map2  

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
                         "<br>", 
                         "Property Value: ", sfhomes$Value))


## ------------------------------------------------------------------------
map4    # Thoughts?

## ------------------------------------------------------------------------
popup_content <- paste("<b>Address:</b>", sfhomes$Address,"<br>", 
                       "<b>Property Value</b>: ", sfhomes$Value, "<br>",
                       "<b>Neighborhood:</b> ", sfhomes$Neighborhood, "<br>",
                       "<b>Num Bedrooms: </b>", sfhomes$NumBeds, "<br>",
                       "<b>Num Bathrooms:</b>", sfhomes$NumBaths
                       )

## ------------------------------------------------------------------------
 
map4 <- leaflet(sfhomes) %>%
  addTiles() %>%   
  addMarkers(~lon, ~lat, popup = popup_content)

## ------------------------------------------------------------------------
map4   # - check out the popups now

## ---- eval=FALSE---------------------------------------------------------
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
map4

## ------------------------------------------------------------------------
map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircles(~lon, ~lat, popup=popup_content,
             fillColor= NA, color="Red", 
             weight=1, fillOpacity = 0,
             ###<b>
             radius= ~NumBeds*10
             ###</b>
             )

## ------------------------------------------------------------------------
map4

## ------------------------------------------------------------------------
 
display.brewer.all(type="qual") 
display.brewer.pal(7, "Set3" )  # Try a different number of colors

## ------------------------------------------------------------------------
display.brewer.all(type="seq")


## ------------------------------------------------------------------------
display.brewer.all(type="div")

## ---- eval =F------------------------------------------------------------
## colorFactor(palette, domain, levels = NULL, ordered = FALSE,
##   na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ---- eval=F-------------------------------------------------------------
## colorNumeric(palette, domain, na.color = "#808080", alpha = FALSE,
##   reverse = FALSE)

## ---- eval=F-------------------------------------------------------------
## colorQuantile(palette, domain, n = 4,
##   probs = seq(0, 1, length.out = n + 1),
##   na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ---- eval=F-------------------------------------------------------------
## colorBin(palette, domain, bins = 7, pretty = TRUE,
##          na.color = "#808080", alpha = FALSE, reverse = FALSE)

## ------------------------------------------------------------------------
display.brewer.all(type="qual")

## ---- message=T, warning=T-----------------------------------------------
# Create a qualitative color palette
myColors <- colorFactor("Paired", sfhomes$Neighborhood) 

## ------------------------------------------------------------------------
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
map4  # what neighborhood had the most sales?

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
#display.brewer.all(type="seq")
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
map4

## ------------------------------------------------------------------------
#display.brewer.all(type="div")
quantColors <- colorQuantile("Reds", sfhomes$Value, n=5)

map4 <- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~quantColors(Value),
            ### </b>
             radius=6, color="grey", weight=1,fillOpacity = 1
             ) 



## ------------------------------------------------------------------------
map4

## ------------------------------------------------------------------------
map4 %>%  addLegend(title = "Value", pal =  quantColors,
                values = ~Value, opacity = 1, 
                position="bottomleft")

## ------------------------------------------------------------------------

map5 <-map4 %>%   addLegend(pal = quantColors, values = ~Value,
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
map5

## ------------------------------------------------------------------------
sfhomes_low2high <- sfhomes[order(sfhomes$Value, decreasing = FALSE),]

map4 <- leaflet(sfhomes_low2high) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, popup=popup_content,
            ### <b>
             fillColor= ~quantColors(Value),
            ### </b>
             radius=6, color="grey", weight=1,fillOpacity = 1
             ) 


## ------------------------------------------------------------------------
map4

## ------------------------------------------------------------------------
sf_md_hhi <- readOGR(dsn="data",layer="sf_medhhincome_acs5y_16")


## ------------------------------------------------------------------------
class(sf_md_hhi)
head(sf_md_hhi)

## ------------------------------------------------------------------------
map6 <- leaflet() %>%
  addTiles() %>%
  addPolygons(data=sf_md_hhi)


## ------------------------------------------------------------------------
map6

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
  addPolygons(data=sf_md_hhi, color="grey", weight=1,
              fillColor="Orange", fillOpacity = 0.25)


## ------------------------------------------------------------------------
map6

## ------------------------------------------------------------------------
##display.brewer.all(type="seq")
quantColors <- colorQuantile("YlOrRd", sf_md_hhi$estimate, n=5)

## ------------------------------------------------------------------------
map6 <- leaflet() %>%
  setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data=sf_md_hhi, color="white", weight=1, opacity=0.5,
              fillColor=~quantColors(estimate), fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate))


## ------------------------------------------------------------------------
map6

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
  addPolygons(data=sf_md_hhi, color="white", weight=1, opacity=0.5,
              fillColor=~quantColors(estimate), fillOpacity = 0.65,
              popup = paste0("$",sf_md_hhi$estimate)) %>%
  addCircleMarkers(data=cheap, popup=paste0("$",cheap$Value),
              color="black",weight=1, radius=6, 
              fillColor="white", fillOpacity = 0.75)


## ------------------------------------------------------------------------
map7

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
          addLayersControl(
            overlayGroups = c("Property Values","Median HH Income"),
            options = layersControlOptions(collapsed = FALSE)
        )


## ------------------------------------------------------------------------
map8

## ------------------------------------------------------------------------
map8 <- leaflet() %>%
          setView(lng=-122.448889, lat=37.764645, zoom=12) %>%
          addProviderTiles("CartoDB.Positron", group="Simple") %>%
          addProviderTiles("Esri.WorldStreetMap", group="Streets")  %>%
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
          addLayersControl(
            baseGroups = c("Simple", "Streets"),
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

