library(raster)
library(ggplot2)
#
defor1 <- brick('defor1.png')
defor2 <- brick('defor2.png')
d1c <- unsuperClass(defor1, nClasses=2)
d2c <- unsuperClass(defor2, nClasses=2)
par(mar=c(2,2,2,2))
par(mfrow=c(2,1))
plot(d1c$map) # green = class2 = forest
plot(d2c$map) # green = class2 = forest
#
freq(d1c$map) # calculate number of pixels for each class
freq(d2c$map) # calculate number of pixels for each class
# calculate overall proportions by year
freq_forest92 <- freq(d1c$map)[2,]/(freq(d1c$map)[1,]+freq(d1c$map)[2,]) # calculate proportion of forest pixels overall
freq_agro92 <- freq(d1c$map)[1,]/(freq(d1c$map)[1,]+freq(d1c$map)[2,]) # calculate proportion of non forest pixels overall
freq_forest06 <- freq(d2c$map)[2,]/(freq(d2c$map)[1,]+freq(d2c$map)[2,])
freq_agro06 <- freq(d2c$map)[1,]/(freq(d2c$map)[1,]+freq(d2c$map)[2,])
# build data.frame
f92 <-  as.matrix(freq_forest92)[2,]
a92 <-  as.matrix(freq_agro92)[2,]
f06 <-  as.matrix(freq_forest06)[2,]
a06 <-  as.matrix(freq_agro06)[2,]
df <- as.data.frame(rbind(cbind(a92, a06), cbind(f92, f06)))
rownames(df) <- cover <- c('agriculture', 'forest')
colnames(df) <- c('y_1992', 'y_1996')
# ggplot
p1 <- ggplot(df, aes(x=cover, y=y_1992, color=cover))+
  geom_bar(stat="identity", fill="lightblue")
p1
