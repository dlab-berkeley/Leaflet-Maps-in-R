library(leaflet)
library(RColorBrewer)
#library(sp)
#library(rgdal)
library(htmlwidgets)
library(dplyr)
setwd("~/Documents/Dlab/workshops/2019/r-leaflet-workshop")
map1 <- leaflet(options=leafletOptions(minZoom=15, maxZoom=18)) %>%
  addTiles() %>%  
  setView(lat=37.87004, lng=-122.25817, zoom = 16) %>%
  setMaxBounds(-122.2570, 37.866458, -122.2553,37.877167)
 
map1  


#sf 37.761750, -122.447074
leaflet() %>%  addTiles() %>%  setView(lat=37.76175, lng=-122.4470, zoom = 17)

map1 

leaflet() %>%
  addTiles() %>%
  addMarkers(lat=37.87004, lng=-122.25817, popup="Barrows Hall") %>%
  addMarkers(lat=37.86850, lng=-122.25830, popup="Cafe Milano")

37.868622, -122.258536


sfhomes <- read.csv('data/sfhomes15.csv', stringsAsFactors = FALSE)  
####
# Made a new data frame with lat, long, and the value
library(raster)
pts <- sfhomes[c('lon','lat','Value')]
coordinates(pts) <- ~lon+lat
crs(pts) = sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
rast <- raster(ncol = 30, nrow = 30)
extent(rast) <- extent(pts)
rast2<-rasterize(pts, rast, field=pts$Value, fun=mean)
plot(rast2)

# Set up the colors
val = as.numeric(c(0:max(pts$Value)))
pal = colorNumeric(c("yellow", "orange", "red"), val,
                   na.color = "transparent")

# Made the map
leaflet() %>% addProviderTiles("CartoDB.Positron") %>%
  addRasterImage(rast2, colors = pal, opacity = 0.5) %>%
  addCircleMarkers(lat=pts$lat, lng=pts$lon, radius=1, color="black") %>%
  addLegend(pal = pal, values = val, title = "Number of Needs")


### Fetch earthquake data from USGS

quake_url <-"http://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime=1989-01-01&endtime=2019-01-31&minmagnitude=3.5"
bayminlat <- 36.433
baymaxlat <- 38.694
bayminlon <- -123.865
baymaxlon <- -120.951

quake_url <- paste0(quake_url, "&minlatitude=",bayminlat, "&maxlatitude=", baymaxlat, 
                    "&minlongitude=", bayminlon,"&maxlongitude=",baymaxlon)

print(quake_url)
quakes <- read.csv(quake_url)
#http://donsnotes.com/places/california/images/2008probabilities-lrg.jpg


leaflet(quakes) %>%
addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(~longitude, ~latitude, popup=paste0("Magnitude: ", quakes$mag, "<br>Date: ", quakes$time),
                   fillColor= "Red", color="Red", weight=1, fillOpacity = 0.25,
                   ###<b>
                   radius= 1.75^quakes$mag #exponential - 1.75 to the magnitude
                   ###</b>
  ) 

# Call the color function (colorNumeric) to create a new palette function
pal <- colorNumeric(c("red", "green", "blue"), 1:10)
pal
# Pass the palette function a data vector to get the corresponding colors
pal(c(1,6,9))


myColor_function <- colorFactor("Paired", sfhomes$Neighborhood)
leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat,  
                   #popup= popup_content,
                   ###<b>
                   fillColor= ~myColor_function(Neighborhood),
                   ###</b>
                   radius=6, color=NA, weight=2, fillOpacity = 1
  )

numColor_function <- colorNumeric("YlOrRd", sfhomes$Value)
map1<- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat,  
                   ### <b>
                   fillColor= ~numColor_function(Value),
                   ### </b>
                   radius=6, color="grey", weight=1, fillOpacity = 1
  ) %>%
  addLegend(title = "Property Values, 2015", pal =  numColor_function,
            values = ~Value, opacity = 1, 
            position="bottomleft")
map1
quantColor_function <- colorQuantile("YlOrRd", sfhomes$Value, n=5)
map2<- leaflet(sfhomes) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addCircleMarkers(~lon, ~lat, 
                   ### <b>
                   fillColor= ~quantColor_function(Value),
                   ### </b>
                   radius=6, color="grey", weight=1,fillOpacity = 1
  ) %>%
 addLegend(pal = quantColor_function, values = ~Value,
                               title = "Property Values, 2015",
                               position="bottomleft",
                               opacity=1,
                               labFormat = function(type, cuts, p) {
                                 n = length(cuts)
                                 cuts = paste0("$", format(cuts[-n], big.mark=","), 
                                               " - ", "$",format(cuts[-1], big.mark=","))
                               }
  )

 map2
 
# bart_lines <- readOGR(dsn="data/BART_13",layer="BART_13")
bart_lines <- readOGR(dsn="data/BART_13",layer="bart13_utm")
summary(bart_lines)
 