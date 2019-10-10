#script to plot depth ages of all holes in a site all together in 1 plot 2xn 

library(data.table) #used for data.table, dataframe for faster and better databasing

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

#library(gridExtra) #used to line up plots nicely
library(cowplot) #trying cowplot instead

fileName_AgeDepth <- "20190927_VOLCORE_AgeDepth.csv"
fileName_Holes <- "20190927_VOLCORE_Holes.csv"

#want to set up a 2xn structure then plot in a for loop
#par(mfrow=c(2,2))

PlotList <- list()

df_Holes <- data.table::fread(fileName_Holes)
df_Holes$Site_id <- RemoveLetters(df_Holes$Hole)
df_Holes_sites <- split(df_Holes,df_Holes$Site_id)
site1012 <- df_Holes_sites[[1]]

##plot map here
world <- map_data("world")

xlimit <- c(-100,-75)#c(0,50)
ylimit <- c(20,40)#c(25,50)

labs <- site1012

#going to try cropping before even plotting

#world_cropped <- st_crop(world,)
#coord map, xlim,ylim far superior to y_limit etc
gg1 <- ggplot() + geom_polygon(data=world,aes(x=long,y=lat,group=group))+ coord_quickmap(xlim =xlimit,ylim=ylimit) + ggtitle("Site 1012")
gg1 <- gg1 + geom_point(data=labs,aes(x=Longitude_dec_deg,y=Latitude_dec_deg),color="red",shape=4,size=3)

PlotList[[1]] <- gg1


  

##end of map plotting


df_AgeDepth <- data.table::fread(fileName_AgeDepth)
df_AgeDepth <- df_AgeDepth[,c("Hole","Age_Ma","Depth_m")] #probably will have to add in other useful parts
df_AgeDepth$Site_id <- RemoveLetters(df_AgeDepth$Hole)

#splitting into sites, then can graph these all seperately, probably will only select useful data for ease of computation
df_sites <- split(df_AgeDepth,df_AgeDepth$Site_id)

#site1 = df_sites$`32` #plotting the depth age of hole 1012
df_site1012_holes = split(df_sites$`1012`,df_sites$`1012`$Hole) #good example as it A,B,C all in 1 site


maxAge <- 4


labelList <- c("1012A","1012B","1012C")

for(i in 1:length(df_site1012_holes)) {
  labels <- df_site1012_holes[[i]]
  PlotList[[i+1]] <- ggplot(data=labels,aes(x=Depth_m,y=Age_Ma),main=df_site1012_holes[[i]]$Hole[1])+coord_cartesian(ylim = c(0,4))+ggtitle(labelList[i]) + geom_point()
                    
}

#simple scatter
#plot(site1[["Depth_m"]],site1[["Age_Ma"]], main="Hole: 32",ylab="Age_Ma",xlab="Depth_m")




##arrange all plots together nicely
#plot_grid(gg1,PlotList[[1]],PlotList[[2]],PlotList[[3]])
#plot_grid(PlotList[[1]],PlotList[[2]],PlotList[[3]],PlotList[[4]])
plot_grid(plotlist = PlotList)
#plot_grid()
#gg1


RemoveLetters <- function(x) {
  
  for(i in 1:length(x)) {
    x[i] <- gsub("*\\D\\d$","",x[i]) #extra case for strings like uu460SP4 -> uu460S
    x[i] <- gsub("[a-zA-Z]$","",x[i]) #just gets the end letters outta there uu460S -> uu460
  }
  
  return(x)
}
