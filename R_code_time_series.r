library(raster)
library(rasterVis)
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab/greenland")
rlist <- list.files(pattern='lst') # crea la lista dei file che contengono la stringa 'lst' nel nome
# LST = Land Surface Temperature
inport <- lapply(rlist, raster) # applica "raster" (che inporta singoli files, al contrario di "brick" che inporta oggetti multistrato) agli oggetti in "rlist"
TGr <- stack(inport) # crea il RasterStack (simile a RasterBrick, ma è piu' un insieme di layers piuttosto che un oggetto multistrato)
plot(TGr)
plotRGB(TGr, 1,2,3, stretch='lin')
# levelplot crea heatmaps. Sull'asse x superiore l'istogramma riporta i vlori medi dei pixel in ogni colonna del raster
levelplot(TGr$lst_2000)
# per assegnare colori diversi l'argomento in levelplot è col.regions
crp <- colorRampPalette(c('purple', 'blue', 'red'))(200)
levelplot(TGr$lst_2000, col.regions=crp)
# plot di tutti gli strati, con titoli e sottotitoli diversi
levelplot(TGr, col.regions=crp, names.attr=c('2000', '2005', '2010', '2015'), 
          main = 'Groenlandia')
#
#
# immagini del satellite Nimbus7 (lancio 1978). Monta sensore a microonde
# il ghiaccio non assorbe microonde
# https://nsidc.org/data/nsidc-0218
mlist <- list.files(pattern="melt")
minport <- lapply(mlist, raster)
melt <- stack(minport)
levelplot(melt, col.regions=crp)
# differenza fra i valori di scioglimento fra il primo e l'ultimo anno di volo 
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt
levelplot(melt_amount)
