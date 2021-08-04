# Roberto Celva, n. mat. 0996871
# Analisi e gestione dell'ambiente, UNIBO, 2021
# Script per "Telerilevamento Geo-ecologico" (Duccio Rocchini)

# 1. Remote sensing
# 2. Time series analysis
# 3. Copernicus data
# 4. knitr
# 5. Multivariate analysis
# 6. Cluster analysis
# 7. ggplot2
# 8. DVI - NDVI
# 9. PCA
# 10. Spectral signature

# 1. Remote sensing---------------------------------------

# install.packages('NAME.OF.PACKAGE') to install new packages

library(raster) # library() to load package
library(rasterVis)
library(rasterdiv)
library(ncdf4)
library(knitr)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
library(viridis)
library(rgdal)

# set working directory

setwd('C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab')

p224r63_2011 <- brick('p224r63_2011_masked.grd') 

# brick() loads image as a rasterbrick object, which is a 'pack of bands'
# use brick() to load multilayer objects, raster() to load one layer at a time

# Landsat7 image (7 bands, sensor ETM+, repeat 16 days).
# File name allows to identify location on the Landsat map
# (https://landsat.gsfc.nasa.gov/about/worldwide-reference-system)
# p224 = path224 (satellite path code); r63 = row 63; _2011 = year of flight)
# every satellite uses a different nomenclature

plot(p224r63_2011) # plot of all 7 bands

# Typing object name outputs his charactristics (in this case, number of bands,
# extention, resolution etc.)

# B1: blue
# B2: green
# B3: red
# B4: NIR (near)
# B5: MIR (medium)
# B6: TIR (thermal)
# B7: MIR (another MIR)

cls <- colorRampPalette(c('black', 'yellow', 'red')) (100)

# colorRampPalette() generates a vector containing a chromatic scale.
# (100) specifyes the number of shades for every color

plot(p224r63_2011, col = cls)

# reflectance values ranges from 0 to 1; having set cls, 0 will be
# 'red' and 1 will be 'purple', for every band

# 4 images plot

par(mar = c(2, 2, 2, 2)) # set plot margins (def: c(5.1, 4.1, 4.1, 2.1)) #B, L, T, R #
par(mfrow = c(4, 1)) # 4 rows, 1 column
plot(p224r63_2011$B1_sre) # plot 'blue' band
plot(p224r63_2011$B2_sre) # plot 'green' band
plot(p224r63_2011$B3_sre) # plot 'red' band
plot(p224r63_2011$B4_sre) # plot 'NIR' band

# plotRGB() assigns one color band (from the raster brick set, 7 bands in this case)
# to each of the three components (r, g, b)).

# 'stretch' argument  normalizes raster reflectance values to 0-1
# (hands on, it toogles the contrast).

# 'lin' sets a linear stretch; 'hist' uses a more aggressive algorithm

par(mfrow = c(3, 1)) # 4 rows, 1 column

# natural colors image

plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = 'lin')

# assign 'red' to NIR band (note: forest has a high reflectance in NIR)

plotRGB(p224r63_2011, r = 4, g = 2, b = 1, stretch = 'lin')
plotRGB(p224r63_2011, r = 4, g = 2, b = 1, stretch = 'hist')

### 1988 - 2011 comparison

p224r63_1988 <- brick('p224r63_1988_masked.grd')
par(mfrow = c(2, 1))

# natural colors

plotRGB(p224r63_1988, r = 3, g = 2, b = 1, stretch = 'lin')
plotRGB(p224r63_2011, r = 3, g = 2, b = 1, stretch = 'lin')

# note: pink shade in 1988 is actually atmosferic scattering resulting from
# low-level correction

# 2011-1988 NIR and stretch (lin - hist) comparison
# pdf() generates a pdf file. Needs dev.off() after plot set to work

pdf('Deforestation_lin-hist.pdf')
par(mfrow = c(2, 2))
plotRGB(p224r63_1988, r = 4, g = 2, b = 1, stretch = 'lin')
plotRGB(p224r63_2011, r = 4, g = 2, b = 1, stretch = 'lin')
plotRGB(p224r63_1988, r = 4, g = 2, b = 1, stretch = 'hist')
plotRGB(p224r63_2011, r = 4, g = 2, b = 1, stretch = 'hist')
dev.off() # delete all plots and reset graphic settings to default

# 2. Time series analysis---------------------------------

# library(raster)
# library(rasterVis)

setwd('./greenland')
# "./" to address subfolders from wd.

lst_2000 <- raster('lst_2000.tif')
lst_2005 <- raster('lst_2005.tif')
lst_2010 <- raster('lst_2010.tif')
lst_2015 <- raster('lst_2015.tif')

par(mfrow = c(2, 2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

rlist <- list.files(pattern = 'lst')

# list files containing 'lst' in the name. 

# LST = Land Surface Temperature for Greenland from 2000 to 2015

import <- lapply(rlist, raster) # must adress object in the environment

# lapply() applies raster() (which inports single files, countrary to brick()
# which manages multilayer objects) to objects in 'rlist'

TGr <- stack(import)

# stack() creates a RasterStack object (similar to a RasterBrick,
# but is a collection of single-layered objecs insthead of one multilayered one)

plot(TGr)
par(mfrow = c(1, 1))
plotRGB(TGr, 1, 2, 3, stretch = 'lin')
levelplot(TGr$lst_2000)

# levelplot() generates a heatmap, with histograms representing mean pixel
# value by raster row and column.

crp <- colorRampPalette(c('black', 'orange', 'red'))(200)
levelplot(TGr$lst_2000, col.regions = crp) # 'col.region' is levelplot()'s 'col' 

# plot all 4 layers, specifying main title and subtitles

levelplot(TGr, col.regions = crp, names.attr = c('2000', '2005', '2010', '2015'),
          main = 'Greenland') # plot all strata, using main title and subtitles
mlist <- list.files(pattern = 'melt')

# Nimbus7 satellite images (launched 1978). Microwave sensor
# (https://nsidc.org/data/nsidc-0218)

minport <- lapply(mlist, raster)
melt <- stack(minport)
levelplot(melt)

# difference between current and 1978 melting figures

melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt
levelplot(melt_amount)

# 3. Copernicus data--------------------------------------

# library(raster)
# library(ncdf4)

setwd('C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab')

# VITO observatory Soil Water Index
# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html#Browse;Root=514690;Collection=1000281;DoSearch=true;Time=NORMAL,NORMAL,1,JANUARY,2015,31,DECEMBER,2022;isReserved=false
# single-layered object, inport using raster()

aqa <- raster('c_gls_SWI1km_202107101200_CEURO_SCATSAR_V1.0.1.nc')
crp <- colorRampPalette(c('black', 'orange', 'red'))(200)
plot(aqa, col = crp)

# RE-SAMPLING (skim pixel to obtain a lighter object)

aqa_small <- aggregate(aqa, fact = 50)
plot(aqa_small, col = crp)

# 4. knitr------------------------------------------------

# library(knitr)

# execute an external r code and store outputs in .tex and .pdf

# stitch('Amazon.r', template = system.file('misc', 'knitr-template.Rnw', package = 'knitr'))

# 5. Multivariate analysis--------------------------------

# library(raster)
# library(RStoolbox)

p224r63_2011 <- brick('p224r63_2011_masked.grd')

par(mfrow = c(1, 1))
plotRGB(p224r63_2011, 1, 2, 3, stretch = 'lin')

# plots pixel values on a carthesian system (correlation betwen BLUE and GREEN bands)

par(mfrow = c(1, 1))
plot(p224r63_2011$B1_sre, p224r63_2011$B2_sre)

# note: MULTICOLLINEARIY: high degree of correlation between explanarory variables
# it is possible to plot the correlation between all bands using pairs(p224r63_2011)

# 6. cluster analysis-------------------------------------

# library(raster)
# library(RStoolbox)

# Sun surface
# (https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images)
# 8 bit images (2^8 = 256 values per pixel)

sun <- brick('Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg')
plotRGB(sun, 1, 2, 3, stretch = 'lin')

# UNSUPERVISED CLASSIFICATION (random sampling for the definition of training set)
# set.seed() allows coherent results (which pixels fall in each class)

set.seed(3030)
sunc <- unsuperClass(sun, nClasses = 5) # soc consist in a 'model' and a 'map'
plot(sunc$map)

# Grand Canyon (https://landsat.visibleearth.nasa.gov/view.php?id=8094)

gc <- brick('dolansprings_oli_2013088_canyon_lrg.jpg')
plotRGB(gc, stretch = 'hist')
gcc <- unsuperClass(gc, nClasses = 3)
plot(gcc$map)

# 7. Land use & ggplot2-----------------------------------

# library(raster)
# library(ggplot2)
# library(gridExtra)

defor1 <- brick('defor1.png')
defor2 <- brick('defor2.png')

par(mar = c(2, 2, 2, 2))
par(mfrow = c(2, 1))

set.seed(1986)
d1c <- unsuperClass(defor1, nClasses = 2)
d2c <- unsuperClass(defor2, nClasses = 2)

plot(d1c$map) # green = class2 = forest
plot(d2c$map) # green = class2 = forest

freq(d1c$map) # number of pixels for each class
freq(d2c$map) # number of pixels for each class

# calculate overall proportions by year
# (forest and non-forest pixels overall)

freq_forest92 <- freq(d1c$map)[2, ]/(freq(d1c$map)[1, ] + freq(d1c$map)[2, ]) 
freq_agro92 <- freq(d1c$map)[1, ]/(freq(d1c$map)[1, ] + freq(d1c$map)[2, ]) 
freq_forest06 <- freq(d2c$map)[2, ]/(freq(d2c$map)[1, ] + freq(d2c$map)[2, ])
freq_agro06 <- freq(d2c$map)[1, ]/(freq(d2c$map)[1, ] + freq(d2c$map)[2, ])

# extract 'count' fields

f92 <-  as.matrix(freq_forest92)[2, ]
a92 <-  as.matrix(freq_agro92)[2, ]
f06 <-  as.matrix(freq_forest06)[2, ]
a06 <-  as.matrix(freq_agro06)[2, ]

# build data.frame

df <- as.data.frame(rbind(cbind(a92, a06), cbind(f92, f06)))
rownames(df) <- Land_use <- c('agriculture', 'forest')
colnames(df) <- c('y_1992', 'y_2006')

# ggplot function

p1 <- ggplot(df, aes(x = Land_use, y = y_1992, color = Land_use)) +
  geom_bar(stat = 'identity', fill = 'lightgreen') +
  labs(y = 'Soil cover (%, 1992)') +
  theme(legend.position = 'none', axis.title.x = element_blank())

p2 <- ggplot(df, aes(x = Land_use, y = y_2006, color = Land_use)) +
  geom_bar(stat = 'identity', fill = 'lightgreen') +
  labs(y = 'Soil cover (%, 2006)') +
  theme(legend.position = 'none', axis.title.x = element_blank())

# side-by-side ggplots can be achieved with gridExtra::grid.arrange
# RStoolbox::ggRGB

grid.arrange(p1, p2, nrow = 2)

# 8. DVI (Diversity Vegetation Index) & NDVI--------------

# library(RStoolbox)
# library(rasterdiv)
# library(rasterVis)
# library(ggplot2)

defor1 <- brick('defor1.png')
defor2 <- brick('defor2.png')

# processed images: b1 =  NIR, b2 = RED, b3 = GREEN

par(mfrow = c(2, 1))
plotRGB(defor1, 1, 2, 3, stretch = 'lin') # NIR to red, RED to green, GREEN to blue
plotRGB(defor2, 1, 2, 3, stretch = 'lin')

# note: pure water absorbs NIR, red and green, so that it should turn out black.
# Solids in suspension makes water a generally lighter color
# note: in 8bit images DVI betwen -255 (dead vegetation) and 255 (vegetation max health)

DVI1 <- defor1$defor1.1 - defor1$defor1.2 # DVI: NIR - RED
DVI2 <- defor2$defor2.1 - defor2$defor2.2

plot(DVI1, main = 'DVI 1992')
plot(DVI2, main = 'DVI 2006')

par(mfrow = c(1, 1))
deltaDVI <- DVI1 - DVI2
crp <- colorRampPalette(c('green', 'brown', 'purple'))(100)

# note: big deltaDVI -> purple; healthy veggies -> green
# NDVI: Normalized DVI = DVI / (NIR+red)

NDVI1 <- DVI1/(defor1$defor1.1 + defor1$defor1.2)
NDVI2 <- DVI2/(defor2$defor2.1 + defor2$defor2.2)
deltaNDVI <- NDVI1 - NDVI2

# RStoolbox has an in-built function (spectralIndices()) to calculate
# these (and more) parameters

indices <- spectralIndices(defor1, green = 3, red = 2, nir = 1)

par(mfrow = c(2, 2))
plot(deltaDVI, col = crp)
plot(deltaNDVI, col = crp)
plot(indices$DVI, col = crp)
plot(indices$NDVI, col = crp)

# rasterdiv contains NDVI dataset from Copernicus
# (copNDVI; https://land.copernicus.eu/global/products/ndvi)

par(mfrow = c(1, 1))
plot(copNDVI)

# to crop out values from 253 to 255 (water) set relative columns to NA

crop <- reclassify(copNDVI, cbind(253:255, NA)) 
levelplot(crop)

# 9. PCA (Principal Component Analysis)-------------------

# library(raster)
# library(ggplot2)
# library(viridis) # ggplot color palette, suitable for sight-challenged (besides 'turbo').
# library(RStoolbox)

sentinel <- brick('sentinel.png')

# img already processed and stretched. 4 layers (1 = NIR; 2 = red; 3 = green)

plotRGB(sentinel)

NIR <- sentinel$sentinel.1
red <- sentinel$sentinel.2
ndvi <- (NIR - red)/(NIR + red)
crp <- colorRampPalette(c('red', 'green', 'black'))(100)
plot(ndvi, col = crp)

# MOVING WINDOW:
# raster::focal() applyes FUN to pixels that falls in the grid of the window
# (moving window), defined as a matrix.

# FUN (sd() in this case) is calculated over pixels falling into the grid.
# Outputs are stored in the central pixel.

# In this case, a grid of 3*3 is moved, stopping on every 9th pixel
# note: to have a central pixel, window has to be uneaven!

ndvi_sd3 <- focal(ndvi, w = matrix(1/9, nrow = 3, ncol = 3), fun = sd)
plot(ndvi_sd3, col = crp)

# SD distribution (higher SD between vegetation and rock, NDVI changes rapidly in peaks)

# Principal Component Analysis over raster object

sentpca <- rasterPCA(sentinel)
plot(sentpca$map) # variance distributions among 4 principal components
summary(sentpca$model) # PC1 explains 77% of variance

# redo mowing window analysis over PC1 only

pc1 <- sentpca$map$PC1 # redirect PC1 as a raster object
pc1_sd5 <- focal(pc1, w = matrix(1/25, nrow = 5, ncol = 5), fun = sd)
plot(pc1_sd5, col = crp) # now variance is clearly defined

# plot in ggplot using scale_fill_viridis_c() color palette
# options for scale_fill viridis: magma, inferno, plasma, cividis, viridis

p1 <- ggplot()+  
  geom_raster(pc1_sd5, mapping = aes(x = x, y = y, fill = layer)) +
  scale_fill_viridis(option = 'mako') +
  ggtitle('PC1 SD')
p1

# 10. Spectral signatures---------------------------------

# https://www.neonscience.org/resources/learning-hub/tutorials/select-pixels-compare-spectral-signatures-r

# library(raster)
# library(rgdal)
# library(ggplot2)

defor2 <- brick('defor2.png')
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')

# raster::click allows to query points by clicking on map. 'esc' to quit
# defor2 is a raster brick, so values of the 3 layers are given
# b1 =  NIR, b2 = red, b3 = green
# get the values for FOREST and WATER

click(defor2, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'yellow')

# output:

#       x     y   cell defor1.1 defor1.2 defor1.3
# 1 132.5 450.5  19411      207       14       35
# 2 311.5 122.5 253782      197      240      223

# as expectes, in FOREST reflectance is higher in NIR than in RED and GREEN
# not so in WATER

band <- c(1, 2, 3)
forest <- c(207, 14, 35)
river <- c(197, 240, 223)

# build data.frame

spectrals <- data.frame(band, forest, river)

ggplot(spectrals, aes(x = band)) +
  geom_line(aes(y = forest), color = 'green') +
  geom_line(aes(y = river), color = 'blue') +
  labs(x = 'band', y = 'reflectance')

# note: geom_line is not a great option, as "bands" are discrete!

# 1992 - 2006 comparison

defor2 <- brick('defor2.png')
plotRGB(defor2, r = 1, g = 2, b = 3, stretch = 'lin')
click(defor1, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'yellow')

#       x     y   cell defor2.1 defor2.2 defor2.3
# 1  39.5 426.5  36607      191       15       25
# 2 115.5 217.5 186536       75       41       76

# define the columns of the dataset:

forest2 <- c(191, 15, 25)
river2 <- c(75, 41, 76)

# bind columns to 1992 data.frame

delta <- cbind(spectrals, forest2, river2)

# plot
ggplot(delta, aes(x = band)) +
  geom_line(aes(y = forest), color = 'green', linetype = 'dashed') +
  geom_line(aes(y = river), color = 'blue', linetype = 'dashed') +
  geom_line(aes(y = forest2), color = 'green', linetype = 'solid') +
  geom_line(aes(y = river2), color = 'blue', linetype = 'solid') +
  labs(x = 'band', y = 'reflectance') + 
  theme(legend.position = 'left')

# FOREST reflectance did not vary, while RIVER is clearly "bluer" in 2006
# due to fewer suspended particles.

# Earth Observatory publishes a "mistery image" montly. Let's do science.

boh <- brick('augustpuzzler-1.jpg')
plotRGB(boh, 1, 2, 3, stretch = 'hist')
click(boh, id = T, xy = T, cell = T, type = 'p', pch = 16, cex = 4, col = 'yellow')

# output
# x     y   cell augustpuzzler.1.1 augustpuzzler.1.2 augustpuzzler.1.3
# 1 630.5 417.5  45271               197               188               159
# 2 249.5 292.5 134890               170               166               154
# 3 697.5  74.5 292298                21                76                55


# define the columns of the dataset:
band <- c(1, 2, 3)
stratum1 <- c(197, 188, 159)
stratum2 <- c(170, 166, 154)
stratum3 <- c(21, 76, 55)

spectralsg <- data.frame(band, stratum1, stratum2, stratum3)

# plot the sepctral signatures
ggplot(spectralsg, aes(x = band)) +
  geom_line(aes(y = stratum1), color = 'yellow') +
  geom_line(aes(y = stratum2), color = 'green') +
  geom_line(aes(y = stratum3), color = 'blue') +
  labs(x = 'band', y = 'reflectance')

# It clearly is something!
#---------------------------------------------------------