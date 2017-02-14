# Este archivo sirve para graficar las manzanas usando un shape a elección

library(ggplot2)
library(maptools)
library(rgeos)
library(rgdal)
library(spdplyr)
library(viridis)

#Plot
shape <- "Shapes/Mapas/Carto_Region_13.gdb/"
shape_com <- readOGR(dsn=shape,layer="COMUNAS")
shape_com <- fortify(shape_com,region="COMUNA") #pasando a data frame usando fortify
shape_man <- readOGR(dsn=shape,layer="MANZANA")
shape_man <- shape_man %>% mutate(ID_W = MANZENT) %>% #magia tidy creo variable de id
  fortify(region="MANZENT") #pasando a data frame usando fortify

ggplot(final) + #seleccionando la variable de comunas donde estan los datos
  geom_map(dat=shape_com, map = shape_com, aes(map_id=id),  #graficando primera capa en blanco
           fill="white",colour = "black",size=0)+
  geom_map(map = shape_man, aes(map_id=ID_W, fill = listo), #creando capa con los colores y datos
           colour = "black", size=0) + coord_map() +
  expand_limits(x = shape_com$long, y = shape_com$lat)+ #expandiendo limites!
  scale_fill_viridis(na.value="white", option = "magma") +
  ggtitle(shape) + theme(legend.title=element_blank()) #titulo de la imagen

ggsave(paste("example",".png",sep=""), width=8, height=8, dpi=1200) #permite guardar en alta resolucion!