library(raster)
library(ncdf4)
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab")
#
# dati del soil water index da VITO observatory. Il file è un singolo strato, quindi si inporta con raster

aqa <- raster('c_gls_SWI1km_202107101200_CEURO_SCATSAR_V1.0.1.nc')
crp <- colorRampPalette(c('purple', 'blue', 'red'))(200)
plot(aqa, col=crp)
# RICAMPIONAMENTO: diminuizione pixel per alleggerire il dato
aqa_small <- aggregate(aqa, fact=50)
plot(aqa_small, col=crp)
