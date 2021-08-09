# Roberto Celva, n. mat. 0996871
# Analisi e gestione dell'ambiente, UNIBO, 2021
# Script per "Telerilevamento Geo-ecologico" (Duccio Rocchini)

# Analysis of storm 'Vaia' effects on a local scale

library(raster)
library(rgdal)
library(rasterVis)
library(RStoolbox)
library(ggplot2)
library(viridis)
library(gridExtra)
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/EarthExplorer")

# 0. Data download ---------------------------------------

# Landsat8 images (path 192, row 028, 04/10/18 - 21/09/19)
# https://earthexplorer.usgs.gov/

# bands (https://landsat.gsfc.nasa.gov/landsat-8/landsat-8-bands)

# B1: ultra - blue 0.433-0.453 um
# B2: blue 0.450-0.515 um
# B3: green 0.525-0.600 um
# B4: red 0.630-0.680 um
# B5: NIR (near) 0.845-0.885 um
# B6: MIR (medium) 1.560-1.660 um
# B7: MIR (medium) 2.100-2.300 um
# B8: panchromatic (gray) 0.500-0.680 um
# B9: panchromatic (gray) 0.500-0.680 um
# B10: TIR (thermal) 10.6-11.2 um
# B11: TIR (thermal) 11.5-12.5 um

# Trento Province forest districts (shapefile)
# https://siat.provincia.tn.it/geonetwork/srv/ita/catalog.search#/metadata/p_TN:c3c63da0-db6c-420e-8d20-7519f6f71aac
# (Cavalese forest district singled out using QGIS)

# 1. Import data ------------------------------------------

# import Cavalese forest district shapefile
cropper <- readOGR(dsn = 'cropper3.shp')

# generate a 'list' object addressing 04/10/2018 files
import18 <- list.files(pattern = '20181004')

# rasterize all objects in list
list18 <- lapply(import18, raster)

# crop 04/10/2018 files applying a loop function over list18
for(i in 1:length(list18)){
  assign(paste0('crp18_', list18[[i]]@data@names),  # this part creates the names
         mask(crop(list18[[i]], cropper), cropper)) # this one applies FUN 'mask(crop())'
}

# list cropped object in the environment using character string in names
grep18 <- grep('crp18', names(.GlobalEnv), value = T)

# generate a 'list' of the cropped objects
croplist18 <- do.call('list', mget(grep18))

# merge in a 'RasterBrick' object
stack18 <- brick(croplist18)

# rename layers for conveniance
names(stack18) <- c('B1','B2','B3','B4','B5','B6','B7')

# same for 2019

import19 <- list.files(pattern = '20190921')
list19 <- lapply(import19, raster)
for(i in 1:length(list19)){
  assign(paste0('crp19_', list19[[i]]@data@names),  # this part creates the names
         mask(crop(list19[[i]], cropper), cropper)) # this one applies FUN 'mask(crop())'
}
grep19 <- grep('crp19', names(.GlobalEnv), value = T)
croplist19 <- do.call('list' ,mget(grep19))
stack19 <- brick(croplist19)
names(stack19) <- c('B1','B2','B3','B4','B5','B6','B7')

# 2. Some plots--------------------------------------------

par(mfrow = c(1, 2))
plotRGB(stack18, 4, 3, 2, stretch = 'lin') # nat col
plotRGB(stack19, 4, 3, 2, stretch = 'lin') # nat col

plotRGB(stack18, 5, 3, 2, stretch = 'lin') # NIR in red
plotRGB(stack19, 5, 3, 2, stretch = 'lin') # NIR in red

plotRGB(stack18, 4, 5, 2, stretch = 'hist') # RED in red, NIR in green
plotRGB(stack19, 4, 5, 2, stretch = 'hist') # RED in red, NIR in green

mw18 <- focal(stack18$B4,w = matrix(1/9,nrow = 3,ncol = 3),fun = mean)
mw19 <- focal(stack19$B4,w = matrix(1/9,nrow = 3,ncol = 3),fun = mean)

levelplot(mw18, main = '2018 RED reflectance', zscaleLog = T)
levelplot(mw19, main = '2019 RED reflectance', zscaleLog = T)

# skim pixel by a factor of 30
small18 <- aggregate(stack18, fact = 30)

# correlation plot
pairs(small18, hist = T, cor = F)

# 3. cluster analysis -------------------------------------

# NB. not standardized?! WHY!!!

set.seed(3031)
cstack18 <- unsuperClass(stack18, nClasses = 2)
cstack19 <- unsuperClass(stack19, nClasses = 2)

par(mfrow = c(1, 2))
plot(cstack18$map)
plot(cstack19$map)

# get frequencies removing NAs (cropped out pixels)
freq18 <- freq(cstack18$map) [-3,]
freq19 <- freq(cstack19$map) [-3,]

# get frequencies
forest18 <- freq18[1,2]/sum(freq18[,2])
forest19 <- freq19[1,2]/sum(freq18[,2])
soil18 <- freq18[2,2]/sum(freq18[,2])
soil19 <- freq19[2,2]/sum(freq18[,2])

# build data.frame
forest <- cbind(forest18, forest19)
soil <- cbind(soil18, soil19)
Cover <- rep(c('Forest', 'Soil'), 2)
Year <- c(rep('2018', 2), rep('2019', 2))
Frame <- cbind(Cover, Year)
Value <- c(forest[,1], soil[,1], forest[,2], soil[,2])
Value <- round(Value, 2)
dataf <- cbind(Frame, Value)
DF <- as.data.frame(dataf)
DF$Value <- as.numeric(as.character(DF$Value))
DF

# barplot
p1 <- ggplot(data = DF, aes(x = Year, y = Value, fill = Cover)) + 
  geom_bar(stat = 'identity', position = 'dodge') + 
  geom_text(aes(label = Value),position  = position_dodge(width=1), 
            vjust = -0.25, , cex = 3) +
  scale_fill_manual(values = c('forestgreen', 'red4'))
p1
# apx. 5.7% of forest loss

# 4. DVI & NDVI--------------------------------------------

DVI18 <- stack18$B5 - stack18$B4
DVI19 <- stack19$B5 - stack19$B4
NDVI18 <- DVI18 / (stack18$B5 + stack18$B4)
NDVI19 <- DVI19 / (stack19$B5 + stack19$B4)

par(mfrow=c(1,2))
crp <- colorRampPalette(c('red4', 'seagreen1'))(5)

plot(NDVI18, main = 'NDVI 2018', col = crp, zlim = c(-1, 1))
plot(NDVI19, main = 'NDVI 2019', col = crp, zlim = c(-1, 1))

deltaNDVI <- NDVI18 - NDVI19
levelplot(deltaNDVI)
