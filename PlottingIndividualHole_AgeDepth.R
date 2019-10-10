library(data.table) #used for data.table, dataframe for faster and better databasing

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

fileName <- "20190927_VOLCORE_AgeDepth.csv"

df_AgeDepth <- data.table::fread(fileName)
df_AgeDepth <- df_AgeDepth[,c("Hole","Age_Ma","Depth_m")] #probably will have to add in other useful parts

#splitting into sites, then can graph these all seperately, probably will only select useful data for ease of computation
df_sites <- split(df_AgeDepth,df_AgeDepth$Hole)

site1 = df_sites$`32` #plotting the depth age of hole 32

#simple scater
plot(site1[["Depth_m"]],site1[["Age_Ma"]], main="Hole: 32",ylab="Age_Ma",xlab="Depth_m")
