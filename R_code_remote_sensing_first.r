# install.packages("raster")
library(raster) # carica la libreria
setwd("C:/Users/Rob/Desktop/UNIBO_05.04.21/Telerilevamento e GIS/lab") # imposta la cartella di lavoro
p224r63_2011 <- brick("p224r63_2011_masked.grd") # carica immagine come raster brick, che e' "un pacchetto di bande"
# L'immagine e'scattata da Landsat, quindi ha 7 bande
# NB. nome file: p224 = path224 (n.sinusoide del satellite in volo); r63 = row 63; _2011 = anno di volo))
# ogni satellite ha la sua nomenclatura.
plot(p224r63_2011) # plotta le 7 bande del raster
# digitando il nome del raster se ne ottengo i parametri (SR, risoluzione, nome delle bande etc)
# B1: blue
# B2: green
# B3: red
# B4: NIR (near)
# B5: MIR (medium)
# B6: TIR (thermal)
# B7: MIR (un altro MIR)
cls <- colorRampPalette(c('red','pink', 'orange', 'purple')) (100)
# crea un vettore contenente un'altra scala cromatica. (100) specifica il n. di gradazioni di ognuno dei colori
plot(p224r63_2011, col=cls)
# NB. le riflettanze delle varie bande contenute nell'immagine vanno da 0 a 1; avendo settato colorRampPalette, 0 sarà 'red' e 1 sarà 'purple' per ognuna delle bande
# plot delle 3 bande RGB piu' il NIR, separatamente 
par(mar=c(2,2,2,2)) # imposta la larghezza dei margini (default: par(mar=c(5.1, 4.1, 4.1, 2.1))
par(mfrow=c(4,1)) # 4 righe, 1 colonne
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
dev.off() # cancella i grafici e azzera le impostazioni grafiche 
#
# "plotRGB" assegna a ognuna delle 3 componenti (r,g,b) una banda di colori (fra quelle del raster brick, in questo caso 7 bande Landsat)
# L'argomento "stretch" normalizza i valori di riflettanza del raster a 0-1
# 'lin' sta per "stretch lineare", "hist" e' un altro tipo. In pratica regola il contrasto (hist è più aggressivo)
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch='lin') # immagine a colori naturali
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='lin') # assegno il NIR al rosso. La foresta ha molta riflettanza in NIR
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='hist')
#
### confronto fra il 1988 e il 2011
#
p224r63_1988 <- brick("p224r63_1988_masked.grd")
par(mfrow=c(2,1))
# colori naturali
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch='lin')
plotRGB(p224r63_1988, r=3, g=2, b=1, stretch='lin')
# NB. le sfumature rosa del 1988 sono effetti di scattering atmosferico corretti male
#
# confronto (2011-1988) in NIR e (stretch = lin-hist)
# scrttura pdf: rinchiudo le funzioni grafiche fra pdf('') e dev.off() 
pdf('prova.pdf')
par(mfrow=c(2,2))
plotRGB(p224r63_1988, r=4, g=2, b=1, stretch='lin')
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='lin')
plotRGB(p224r63_1988, r=4, g=2, b=1, stretch='hist')
plotRGB(p224r63_2011, r=4, g=2, b=1, stretch='hist')
dev.off()

