library(rgdal)
library(sp)
library(SearchTrees)
library(rgeos)
library(raster)
library(readr)

# Loading required SII manzanas

mz_valdivia.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_VALDIVIA/", layer = "MZ_DR_VALDIVIA")
mz_concepcion.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_CONCEPCION/", layer = "MZ_DR_CONCEPCION")
mz_copiapo.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_COPIAPO//", layer = "MZ_DR_COPIAPO")
mz_stgocentro.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_STGO_CENTRO/", layer = "MZ_DR_STGO_CENTRO")
mz_stgooriente.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_STGO_ORIENTE/", layer = "MZ_DR_STGO_ORIENTE")
mz_stgoponiente.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_STGO_PONIENTE/", layer = "MZ_DR_STGO_PONIENTE")
mz_stgosur.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_STGO_SUR/", layer = "MZ_DR_STGO_SUR")
mz_temuco.sii <- readOGR(dsn= "MANZANAS_SII/MZ_DR_TEMUCO/", layer = "MZ_DR_TEMUCO")

# Reading shapes of the barrios

barrios_censo <- readOGR("export", "piloto")
barrios_censo <- spTransform(barrios_censo,
                             CRS("+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))

barrios_censo$MANZENT <- as.character(barrios_censo$MANZENT)

# Joining shapes

lista_sii <- rbind(mz_valdivia.sii,mz_concepcion.sii,mz_copiapo.sii,mz_stgocentro.sii,mz_stgooriente.sii,mz_stgoponiente.sii,mz_stgosur.sii,mz_temuco.sii)
lista_sii <- spTransform(lista_sii,
                             CRS("+proj=utm +zone=19 +south +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"))

rm(list=c("mz_valdivia.sii","mz_concepcion.sii","mz_copiapo.sii","mz_stgocentro.sii","mz_stgooriente.sii","mz_stgoponiente.sii","mz_stgosur.sii","mz_temuco.sii"))

# Creating search tree

tree = createTree(coordinates(lista_sii), dataType="point", columns= 1:2)
search = knnLookup(tree, newdat=coordinates(barrios_censo), k=4)


# Function to select 4 nearest polygons and selecting what covers the largest area

manzdect <- function(x){
  objects <- search[match(x,barrios_censo$MANZENT), ]
  polygons <- sapply(objects, function(z) { gIntersection(barrios_censo[match(x,barrios_censo$MANZENT), ], lista_sii[z, ])
  })
  out <- as.character(lista_sii[objects[which.max(sapply(polygons, function(x) {ifelse(!is.null(x), raster::area(x), NA)}))], ]$CMN_MZ)
  return(ifelse(length(out) != 0, out, NA))
}

# Using function and adding the code to the census manzana

barrios_censo@data$CMN_MZ <- as.vector(sapply(barrios_censo@data$MANZENT, manzdect))

# Loading SII extended data with attributes

sii <- read_delim("Catastro de Bienes Raices 2016-1/BRORGA2441N_00000.txt", delim = "|", col_names = c("CodigoSIIdelaComuna",
"NumerodeManzana",
"NumerodePredial",
"Direcciononombredelpredio",
"Avaluofiscaltotal",
"Contribucionsemestral",
"Codigodedestinoprincipal",
"Avaluoexentodelapropiedad",
"CodigoSIIdelaComunaRolBienComun1",
"NumerodeManzanaRolBienComun1",
"NumerodepredioRolBienComun1",
"CodigoSIIdelaComunaRolBienComun2",
"NumerodeManzanaRolBienComun2",
"NumerodepredioRolBienComun2",
"Superficietotaldelterrenodelapropiedad"
))

# Converting to numeric
sii$Avaluofiscaltotal <- as.integer(sii$Avaluofiscaltotal)

# Creating manzana id

sii$CMN_MZ <- paste0(as.integer(sii$CodigoSIIdelaComuna),"-",as.integer(sii$NumerodeManzana))

# Median of values by manzana
median.value.sii <- sii %>% 
  group_by(CMN_MZ) %>%
  summarise(m=median(Avaluofiscaltotal))

barrios_censo@data$value <- median.value.sii[match(barrios_censo@data$CMN_MZ,median.value.sii$CMN_MZ), ]$m

# Creating shp
writeOGR(barrios_censo,"shape_censo", "shape_censo", driver="ESRI Shapefile")

# Saving indicator
data.w <- barrios_censo@data[ ,c("MANZENT","value")]
names(data.w) <- c("ID_W", "value")
data.w<-data.w[!duplicated(data.w), ]
data.w$value <- round(data.w$value)
write_rds(data.w,"valuesii.RDS")



