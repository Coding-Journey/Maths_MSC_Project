library(data.table) #used for data.table, dataframe for faster and better databasing

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

fileName <- "20190927_VOLCORE_Holes.csv"

df <- data.table::fread(fileName)

df$Site_iD <- RemoveLetters(df$Hole) #removing the non numbers so we can group into sites

#oceans <- split(df,df$Ocean_region) #splits into ocean regions
#now want to split into holes? or just split into holes first
#add an extra column for holes as idk how I'd split with 14,14A etc
#want a column as site number, just the numbers of the hole ID

#splitting into sites, then can graph these all seperately
df_sites <- split(df,df$Site_iD)

#now split into sites, want to loop over them and plot the graph, maybe do just 1 site right now to get it working

#plotting a graph and map for 4th site as it has 2 elements

site134 <- df_sites$`134`

world <- map_data("world")

#restricting it down to atlantic ocean

xlimit <- c(0,20)#c(0,50)
ylimit <- c(30,45)#c(25,50)

#coord map, xlim,ylim far superior to y_limit etc
gg1 <- ggplot() + geom_polygon(data=world,aes(x=long,y=lat,group=group))+coord_fixed(1.3) + coord_map(xlim =xlimit,ylim=ylimit)
gg1

labs <- site134

gg1 +
  geom_point(data=labs,aes(x=Longitude_dec_deg,y=Latitude_dec_deg),color="red",shape=4,size=5)


#plotting world map then add points I guess




RemoveLetters <- function(x) {
  
  for(i in 1:length(x)) {
    x[i] <- gsub("*\\D\\d$","",x[i]) #extra case for strings like 460SP4
    x[i] <- gsub("[a-zA-Z]$","",x[i]) #just gets the end letters outta there
  }
  
  return(x)
}