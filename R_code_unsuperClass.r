
# Grand Canyon (Landsat)
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
plotRGB(gc, stretch = "hist")
gcc <- unsuperClass(gc, nClasses = 5)
plot(gcc$map)
