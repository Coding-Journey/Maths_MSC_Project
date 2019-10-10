#script to plot depth ages of all holes in a site all together in 1 plot 2xn 

library(data.table) #used for data.table, dataframe for faster and better databasing

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

fileName <- "20190927_VOLCORE_AgeDepth.csv"

df_AgeDepth <- data.table::fread(fileName)
df_AgeDepth <- df_AgeDepth[,c("Hole","Age_Ma","Depth_m")] #probably will have to add in other useful parts
df_AgeDepth$Site_id <- RemoveLetters(df_AgeDepth$Hole)

#splitting into sites, then can graph these all seperately, probably will only select useful data for ease of computation
df_sites <- split(df_AgeDepth,df_AgeDepth$Site_id)

#site1 = df_sites$`32` #plotting the depth age of hole 32
df_site1012_holes = split(df_sites$`1012`,df_sites$`1012`$Hole) #good example as it A,B,C all in 1 site

#want to set up a 2xn structure then plot in a for loop
par(mfrow=c(2,2))

for(i in 1:length(df_site1012_holes)) {
  plot(df_site1012_holes[[i]][["Depth_m"]],df_site1012_holes[[i]][["Age_Ma"]],main=df_site1012_holes[[i]]$Hole[1],ylab="Age_Ma",xlab="Depth_m",ylim = c(0,4))
}

#simple scatter
#plot(site1[["Depth_m"]],site1[["Age_Ma"]], main="Hole: 32",ylab="Age_Ma",xlab="Depth_m")




RemoveLetters <- function(x) {
  
  for(i in 1:length(x)) {
    x[i] <- gsub("*\\D\\d$","",x[i]) #extra case for strings like uu460SP4 -> uu460S
    x[i] <- gsub("[a-zA-Z]$","",x[i]) #just gets the end letters outta there uu460S -> uu460
  }
  
  return(x)
}