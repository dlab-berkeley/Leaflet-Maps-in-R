 

#
sfhomes2 <- read.csv('data/sf_properties_25ksample.csv', stringsAsFactors = F)

sf15<-subset(sfhomes2,SalesYear == 2015)
 
 
View(sf15)
sf15new <- sf15[c("SalesDate","Address","YearBuilt","NumBedrooms","NumBathrooms","NumUnits","AreaSquareFeet","Neighborhood","totvalue","lat","lon")]
newnames2 <-c("SalesDate","Address","YrBuilt","NumBeds","NumBaths","NumUnits","AreaSqFt","Neighborhood","Value","lat","lon" )
colnames(sf15new) <- newnames2

sf15new[sf15new$Neighborhood=='Presidio Heights',]$Neighborhood <- "Presidio"
sf15new[sf15new$Neighborhood=='Inner Richmond',]$Neighborhood <- "Richmond"
sf15new[sf15new$Neighborhood=='Outer Mission',]$Neighborhood <- "Mission"
sf15new[sf15new$Neighborhood=='Inner Sunset',]$Neighborhood <- "Sunset"
sf15new[sf15new$Neighborhood=='Outer Richmond',]$Neighborhood <- "Richmond"
sf15new[sf15new$Neighborhood=='West of Twin Peaks',]$Neighborhood <- "Twin Peaks"
sf15new[sf15new$Neighborhood=='Sunset/Parkside',]$Neighborhood <- "Sunset" 	
 
unique(sf15new$Neighborhood)
nhooddf <- data.frame(table(sf15new$Neighborhood))

nrow(nhooddf)
nh2 <- subset(nhooddf, Freq > 19)
nrow(nh2)
newnames <-as.character(nh2$Var1)
newnames
sf15_b <- sf15new[sf15new$Neighborhood %in% newnames,]
write.csv(sf15_b, file="data/sfhomes15.csv",row.names = F)
 
