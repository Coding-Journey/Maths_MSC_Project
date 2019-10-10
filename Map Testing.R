library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

usa <- map_data("usa")
w2hr <- map_data("world2Hires")

#plotting the usa map

gg1 <- ggplot() + geom_polygon(data=usa,aes(x=long,y=lat,group=group))+coord_fixed(1.3)

#adding some black and yellow points

labs <- data.frame(
  long = c(-122.064873,-122.306417),
  lat = c(36.951968,47.644855),
  names = c("SWFSC-FED","NWFSC"),
  stringsAsFactors = FALSE #wil try true
)

gg1

gg1 +
  geom_point(data=labs,aes(x=long,y=lat),color="white",shape=4,size=3)

#gg1 +
#  geom_point(data=labs,aes(x=long,y=lat),color="black",size=5)+
#  geom_point(data=labs,aes(x=long,y=lat),color="yellow",size=4)
