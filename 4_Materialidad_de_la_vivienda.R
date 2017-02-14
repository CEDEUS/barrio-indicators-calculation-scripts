#Materialidad de la vivienda

#Conexiones
library(RMySQL)
library(tidyverse)

con <- src_mysql(dbname = "censo2012",
                 host = Sys.getenv("MYSQL_HOST"),
                 user = Sys.getenv("MYSQL_USER"),
                 password = Sys.getenv("MYSQL_PASS")
                 )

#Inicio querys
#Generando ID_W
geoid <- tbl(con,"idgeo") %>% 
  select(FOLIO,NVIV,COM,DTO,AREA,ZONA,MZ,LOCALIDAD,ENTIDAD,SECTOR) %>% 
  collect(n=Inf) %>% 
  mutate(ID_W=paste(COM,sprintf("%02d", DTO),AREA,ifelse(AREA==1, sprintf("%03d",ZONA), ifelse(AREA==2, sprintf("%03d",LOCALIDAD), 0)),ifelse(AREA==1, sprintf("%03d",MZ), ifelse(AREA==2, sprintf("%03d",ENTIDAD), 0)),sep="")) %>% 
  select(FOLIO,NVIV,ID_W)

#Funcion de materialidad para asignar valores 2 (Viviendas aceptables), 1 (Viviendas mejorables) y 0 (Viviendas precarias)
materialidad <- function(x,y,z) {
  return(
  ifelse(x==1|x==2|x==3|x==4,2,ifelse(x==5,1,ifelse(x==6,0,NA))) +
  ifelse(y==1|y==2|y==3,2,ifelse(x==4|x==5,1,ifelse(x==6,0,NA))) +
  ifelse(y==1|y==2|y==3,2,ifelse(x==4|x==5|x==6,1,ifelse(x==7,0,NA)))
  )
}

#Chequear... tengo mis dudas.
imv <- tbl(con, "vivienda") %>% 
  select(FOLIO,NVIV,V03A,V03B,V03C) %>% 
  collect(n=Inf) %>%
  left_join(geoid, by=c("FOLIO"="FOLIO","NVIV"="NVIV")) %>%
  mutate(score = materialidad(V03A,V03B,V03C))

final <- imv %>% group_by(ID_W) %>% summarise(listo = mean(score,na.rm = T))

#Cleaning
rm(list=c("imv","geoid"))