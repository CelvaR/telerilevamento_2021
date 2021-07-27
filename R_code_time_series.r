library(raster)
library(rasterVis)
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab/greenland")
rlist <- list.files(pattern='lst') # list files containing 'lst' in the name
# LST = Land Surface Temperature
inport <- lapply(rlist, raster) # lapply() applies raster() (which inports single files, countrary to brick() which manages multilayer objects) to objects in 'rlist'
TGr <- stack(inport) # stack() creates a RasterStack object (similar to a RasterBrick, but is a collection of single-layered objecs insthead of one multilayered one)
plot(TGr)
plotRGB(TGr, 1,2,3, stretch='lin')
levelplot(TGr$lst_2000) # levelplot() generates a heatmap, with histograms representing mean pixel value by raster row and column
crp <- colorRampPalette(c('purple', 'blue', 'red'))(200)
levelplot(TGr$lst_2000, col.regions=crp) # 'col.region' is levelplot()'s 'col' 
# plot di tutti gli strati, con titoli e sottotitoli diversi
levelplot(TGr, col.regions=crp, names.attr=c('2000', '2005', '2010', '2015'), main = 'Groenlandia') # plot all strata, using main title and subtitles
#
#
mlist <- list.files(pattern="melt") # Nimbus7 satellite images (launched 1978). Microwave sensor (source: https://nsidc.org/data/nsidc-0218)
minport <- lapply(mlist, raster)
melt <- stack(minport)
levelplot(melt, col.regions=crp)
# difference between current and 1978 melting figures
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt
levelplot(melt_amount)
