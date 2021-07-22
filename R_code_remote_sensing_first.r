# R code for RS

# install.packages("raster")
library(raster)

setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab")
# setwd("C:/lab/")  
# windows
# setwd("/Users/name/lab/")

# "brick" crea un oggetto "raster brick", che è "un pacchetto di bande"
p224r63_2011 <- brick("p224r63_2011_masked.grd")

plot(p224r63_2011) # plotta le 7 bande del raster

# B1: blue
# B2: green
# B3: red
# B4: NIR
