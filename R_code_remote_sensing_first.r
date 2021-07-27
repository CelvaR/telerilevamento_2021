# install.packages('NAME.OF.PACKAGE') to install new packages
library(raster) # load package
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab") # set working directory
# Landsat image (7 bands)
# file name allows to identify location on the Landsat map (https://landsat.gsfc.nasa.gov/about/worldwide-reference-system)
# p224 = path224 (satellite path code); r63 = row 63; _2011 = year of flight)
# every satellite uses a different nomenclature
p224r63_2011 <- brick("p224r63_2011_masked.grd") # load image as a rasterbrick object, which is a 'pack of bands'        
plot(p224r63_2011) # plot of all 7 bands
# typing object name outputs his charactristics (in this case, number of bands, extention, resolution etc.)
# B1: blue
# B2: green
# B3: red
# B4: NIR (near)
# B5: MIR (medium)
# B6: TIR (thermal)
# B7: MIR (another MIR)
cls <- colorRampPalette(c('red','pink', 'orange', 'purple')) (100)
# colorRampPalette() generates a vector containing a chromatic scale. (100) specifyes the number of shades for every color
plot(p224r63_2011, col=cls)
# reflectance values ranges from 0 to 1; having set cls, 0 will be 'red' and 1 will be 'purple', for every band
#
# 4 images plot
#
par(mar=c(2,2,2,2)) # set plot margins (default: par(mar=c(5.1, 4.1, 4.1, 2.1)) ### order: B,L,T,R ###
par(mfrow=c(4,1)) # 4 rows, 1 column
plot(p224r63_2011$B1_sre) # plot 'blue' band
plot(p224r63_2011$B2_sre) # plot 'green' band
plot(p224r63_2011$B3_sre) # plot 'red' band
plot(p224r63_2011$B4_sre) # plot 'NIR' band
dev.off() # deletes plots and graphic sets
#
# plotRGB() assigns one color band (from the raster brick set, 7 bands in this case) to each of the three components (r,g,b))
# 'stretch' argument  normalizes raster reflectance values to 0-1. Hands on, it toogles the contrast
# 'lin' sets a linear stretch; 'hist' uses a more aggressive algorithm
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch='lin') # natural colors image
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='lin') # assign 'red' to NIR band (note: forest has a high reflectance in NIR)
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='hist')
#
### 1988 - 2011 comparison
p224r63_1988 <- brick("p224r63_1988_masked.grd")
par(mfrow=c(2,1))
# natural colors
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch='lin')
plotRGB(p224r63_1988, r=3, g=2, b=1, stretch='lin')
# note: pink shade in 1988 is actually atmosferic scattering resulting from low-level correction
#
# 2011-1988 NIR and stretch (lin - hist) comparison
# pdf() generates a pdf file. Needs dev.off() after plot set to work
pdf('prova.pdf')
par(mfrow=c(2,2))
plotRGB(p224r63_1988, r=4, g=2, b=1, stretch='lin')
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='lin')
plotRGB(p224r63_1988, r=4, g=2, b=1, stretch='hist')
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='hist')
dev.off()

