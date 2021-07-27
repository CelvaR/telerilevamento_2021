library(RStoolbox)
library(rasterdiv)
library(rasterVis)
library(ggplot2)
#
defor1 <- brick('defor1.png')
defor2 <- brick('defor2.png')
# processed images: b1= NIR, b2=red, b3=green
par(mfrow=c(2,1))
plotRGB(defor1, 1,2,3, stretch="lin") # B1 to red, B2 to green, B3 to blue
plotRGB(defor2, 1,2,3, stretch="lin")
dev.off()
# note: pure water absorbs NIR, so that it turns out black. Solids in suspension makes it a lighter color
# DVI = Diversity vegetation Index = (NIR - red)
# note: in 8bit images DVI betwen -255 (dead vegetation) and 255 (vegetation max health)
DVI1 <- defor1$defor1.1 - defor1$defor1.2
DVI2 <- defor2$defor2.1 - defor2$defor2.2
#
par(mfrow=c(2,1))
plot(DVI1, main = 'DVI 0')
plot(DVI2, main = 'DVI 1')
par(mfrow=c(1,1))
diffDVI <- DVI1-DVI2
plot(diffDVI)
crp <- colorRampPalette(c('green', 'yellow', 'red'))(100)
plot(diffDVI, col=crp)
# note: where the difference in DVI is greater, map is red; where vegetation is healthier, map is green
# NDVI: Normalized DVI = DVI / (NIR+red)
NDVI1 <- DVI1/(defor1$defor1.1+defor1$defor1.2)
NDVI2 <- DVI2/(defor2$defor2.1+defor2$defor2.2)
diffNDVI <- NDVI1-NDVI2
plot(diffNDVI, col=crp)
# RStoolbox has an in-built function (spectralIndices()) to calculate these (and more) parameters
indices <- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(indices$DVI, col=crp)
plot(indices$NDVI, col=crp)
# rasterdiv contains NDVI dataset from Copernicus (copNDVI; https://land.copernicus.eu/global/products/ndvi)
plot(copNDVI)
# to crop out values from 253 to 255 (water) set relative columns to NA
crop <- reclassify(copNDVI, cbind(253:255, NA)) 
levelplot(crop)
#
p1 <- ggRGB(defor1, 1,2,3, stretch="lin") # gglpot's plotRGB()
p2 <- ggRGB(defor2, 1,2,3, stretch="lin")
# par(mfrow()) does not work with ggplots; no stable package available up to now
