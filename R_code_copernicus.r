library(raster)
library(ncdf4)
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab")
#
# VITO observatory Soil Water Index
# https://land.copernicus.vgt.vito.be/PDF/portal/Application.html#Browse;Root=514690;Collection=1000281;DoSearch=true;Time=NORMAL,NORMAL,1,JANUARY,2015,31,DECEMBER,2022;isReserved=false
# single-layered object, inport using raster()
aqa <- raster('c_gls_SWI1km_202107101200_CEURO_SCATSAR_V1.0.1.nc')
crp <- colorRampPalette(c('purple', 'blue', 'red'))(200)
plot(aqa, col=crp)
# RE-SAMPLING (skim pixel to obtain a lighter object)
aqa_small <- aggregate(aqa, fact=50)
plot(aqa_small, col=crp)
