library(photon)
library(sp)

# Leer base de datos del padron

## Padron San Miguel

A1321021 <- read_delim(file("Data/A1321021.csv",encoding="UTF-8"), ";", escape_double = FALSE, trim_ws = TRUE)

# Subset de las calles involucradas en los barrios piloto

capa_calle <- read_csv("Data/capa_calle.csv")
capa_calle <- as.vector(sapply(capa_calle$name, toupper))
calles <- unique(grep(paste(capa_calle,collapse="|"), A1321021$Domicilio, value=TRUE))
subset_calles <- A1321021 %>% filter(Domicilio %in% calles)
rm(list=c("capa_calle","calles"))

# Geocoding de las personas que coinciden con la localizacion
loc <-  as.vector(sapply(subset_calles$Domicilio,function(x){paste(x,", SAN MIGUEL, CHILE",sep="")}))
coord <- geocode(loc, limit = 1)
write.csv(coord,"Data/Brasilia_Geocoding.csv")
rm(loc)

## ¿Cuanto acierto del geocoding? ~ 75.5% GOOD
coord %>% summarise(total=n(),countNA=sum(is.na(lon)),per=(sum(!is.na(lon))/n())*100)

# Merge de geocoding con la base original
subset_calles$location <-  as.vector(sapply(subset_calles$Domicilio,function(x){paste(x,", SAN MIGUEL, CHILE",sep="")}))
coordenadas <- coord %>% select(location,lat,lon)
dat <- merge(subset_calles,coordenadas,by="location")
rm(list=c("coordenadas","subset_calles"))

# Hacer coincidir barrios con las personas del padron

crs <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")

dat <- dat[!is.na(dat$lon),]
coordinates(dat) <- ~lon+lat
proj4string(dat) <- crs
dat <- spTransform(dat, crs)

shape_pil <- readOGR(dsn = "../Censo2012/Shapes/barrios_piloto/", layer = "barrios_piloto")
shape_pil <- spTransform(shape_pil, crs)
brasilia <- shape_pil %>% filter(BARRIO == "Brasilia")

final <- dat[brasilia,]

# Ver las mesas que estan involucradas haciendo un summarize count

count <- as.data.frame(final[!duplicated(final$RUT), ]) %>%  
  group_by(Mesa) %>% summarise(n=n()) %>% 
  arrange(desc(n))

total_mesas <- as.data.frame(A1321021[!duplicated(A1321021$RUT), ]) %>% 
  filter(Mesa %in% count$Mesa) %>% group_by(Mesa) %>% 
  summarise(n=n()) %>% arrange(desc(n))

count$total <- total_mesas$n


# Usando las bases del servel ver cuantos votos hay por mesa es decir cuantas personas participaron en la eleccion 
# https://www.servel.cl/participacion-electoral/

elecciones <- read_excel("Data/13_Resultados_Mesa_Alcaldes_Ter.xlsx",sheet=1,col_types=c("numeric","text","numeric","numeric","text","text","numeric","text","numeric","text","text","text","numeric"))

# Obtener % participacion por mesa

votospormesa <- elecciones %>% filter(Comuna=="SAN MIGUEL") %>% unite(Mesa, c(`Nro. Mesa`,`Tipo Mesa`),sep=" ") %>% group_by(Mesa) %>% summarise(votos=sum(`Votos TER`))
votos <-  merge(count,votospormesa,by="Mesa")

votos <- votos %>% mutate(participacion=votos/total) 

# Media de participacion en las mesas donde los vecinos del barrio votan
mean(votos$participacion)

