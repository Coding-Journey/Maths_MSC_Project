#now doing the WholeSite Map&AgeDepth for every site, print to pdf

#script to plot depth ages of all holes in a site all together in 1 plot 2xn 



#TODO: fix this so it goes over all and prints to pdf, about line 58 rn


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

##loading df_Holes csv
df_Holes <- data.table::fread(fileName_Holes)
df_Holes$Site_id <- RemoveLetters(df_Holes$Hole)
df_Holes_sites <- split(df_Holes,df_Holes$Site_id)

##loading df_AgeDepth
df_AgeDepth <- data.table::fread(fileName_AgeDepth)
df_AgeDepth <- df_AgeDepth[,c("Hole","Age_Ma","Depth_m")] #probably will have to add in other useful parts
df_AgeDepth$Site_id <- RemoveLetters(df_AgeDepth$Hole)

#splitting into sites, then can graph these all seperately, probably will only select useful data for ease of computation
df_sites <- split(df_AgeDepth,df_AgeDepth$Site_id)

ggPlotList <- list()

for(i in 1:length(df_Holes_sites)) {
  PlotList <- list()
  
  ##plot map here
  world <- map_data("world")
  
  xlimit <- c(-100,-75)#c(0,50)
  ylimit <- c(20,40)#c(25,50)
  
  labs <- df_Holes_sites[[i]]
  
  gg1 <- ggplot() + geom_polygon(data=world,aes(x=long,y=lat,group=group)) + ggtitle("Site 1012")#+ coord_quickmap(xlim =xlimit,ylim=ylimit)
  gg1 <- gg1 + geom_point(data=labs,aes(x=Longitude_dec_deg,y=Latitude_dec_deg),color="red",shape=4,size=3)
  
  site_PlotList[[1]] <- gg1
  ##end of map plotting
  
  df_site_holes = split(df_sites[[i]],df_sites[[i]]$Hole)
  
  maxAge <- 0
  
  for(i in 1:length(df_site_holes)) {
    if(max(df_site_holes[[i]]$`Age_Ma`) > maxAge) {
      maxAge <- df_site_holes[[i]]$`Age_Ma`
    } 
  }
  
  # might have to change this if something is bigger, this needs to be the max for the site
  
  
  for(i in 1:length(df_site1012_holes)) {
    labels <- df_site1012_holes[[i]]
    PlotList[[i]] <- ggplot(data=labels,aes(x=Depth_m,y=Age_Ma),main=df_site1012_holes[[i]]$Hole[1])+coord_cartesian(ylim = c(0,maxAge))+ggtitle(labelList[i]) + geom_point()
    
  }
  
  #simple scatter
  #plot(site1[["Depth_m"]],site1[["Age_Ma"]], main="Hole: 32",ylab="Age_Ma",xlab="Depth_m")
  
  
  
  
  ##arrange all plots together nicely
  plot_grid(gg1,PlotList[[1]],PlotList[[2]],PlotList[[3]]) #here just need to make this a list then print them all to a pdf
  
  #gg1
  
  
  ggPlotList[[i]] #add the final combined to this
}



#going to try cropping before even plotting

#world_cropped <- st_crop(world,)
#coord map, xlim,ylim far superior to y_limit etc









RemoveLetters <- function(x) {
  
  for(i in 1:length(x)) {
    x[i] <- gsub("*\\D\\d$","",x[i]) #extra case for strings like uu460SP4 -> uu460S
    x[i] <- gsub("[a-zA-Z]$","",x[i]) #just gets the end letters outta there uu460S -> uu460
  }
  
  return(x)
}
