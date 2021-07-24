# R code for RS

# install.packages("raster")
library(raster)

setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab")
# setwd("C:/lab/")  
# windows
# setwd("/Users/name/lab/")

# "brick" crea un oggetto "raster brick", che è "un pacchetto di bande"
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# è un'area dell'amazzonia, il "lago" è una foresta

plot(p224r63_2011) # plotta le 7 bande del raster
# digitando il nome del raster ne ricavo le invormazioni (SR, risoluzione, nome delle bande etc)

# B1: blue
# B2: green
# B3: red
# B4: NIR
# B5: MIR
# B6: TIR
# B7: MIR (2)
cls <- colorRampPalette(c('red','pink', 'orange', 'purple')) (200)
plot(p224r63_2011, col=cls) # plotta le 7 bande del raster
#
# plotto le 3 bande RGB più il NIR
par(mar=c(2,2,2,2)) # imposta la larghezza dei margini (default: par(mar=c(5.1, 4.1, 4.1, 2.1))
par(mfrow=c(4,1)) # 4 riga, 1 colonne
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
#
# plotRGB include fra gli argomenti il colore delle bande
# l'argomento "stretch" normalizza i valori di riflettanza del raster fra 0 e 1
# 'lin' sta per "stretch lineare", "hist" è un altro tipo. In pratica regola il contrasto
par(mfrow=c(1,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch='lin') # immagine a colori naturali
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='lin') # assegno il NIR al rosso. la foresta ha molta riflettanza in NIR
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='hist') # immagine a colori naturali

