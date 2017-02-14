# Este archivo sirve para graficar las barrios usando un shape a elección

library(ggplot2)
library(maptools)
library(rgeos)
library(rgdal)
library(spdplyr)
library(viridis)

shape_pil <- readOGR(dsn = "Shapes/barrios_piloto/", layer = "barrios_piloto") #Leyendo shape de barrios piloto
shape_man <- readOGR(dsn = "Shapes/Mapas/Carto_Region_13.gdb/", layer = "MANZANA") #Leyendo shape de precenso 2011

crs <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84") # Projeccion

shape_pil <- spTransform(shape_pil, crs) # Estableciendo projeccion en el shape
shape_man <- spTransform(shape_man, crs) 
intersect <- raster::intersect(shape_pil,shape_man) # INTERSECT! esta version es mejor que gIntersect porque preserva la tabla

barrio <- "El Mariscal" # Barrio
mapbarrio <- intersect %>% filter(BARRIO==barrio) %>% fortify(region="MANZENT") %>% mutate(ID_W=id) # Filtrando y pasando a data.frame y generando campo de id
#Graficando
ggplot(final) + 
  geom_map(dat=mapbarrio, map = mapbarrio, aes(map_id=id),fill="white",colour = "black",size=0)+
  geom_map(map = mapbarrio, aes(map_id=ID_W, fill = listo),colour = "black", size=0) + coord_map()  +
  expand_limits(x = mapbarrio$long, y = mapbarrio$lat) + 
  scale_fill_viridis(na.value="white", option = "magma") +
  ggtitle(paste("Barrio",barrio)) + 
  theme(legend.title=element_blank())
