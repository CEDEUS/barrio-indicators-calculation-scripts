# Vehiculos

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

vehiculo <-tbl(con,"hogar") %>% 
  select(FOLIO,NVIV,H13B) %>%
  collect(n=Inf) %>% 
  left_join(geoid, by=c("FOLIO"="FOLIO","NVIV"="NVIV")) %>% 
  mutate(H13B = dplyr::recode(H13B, `1` = "Si tiene auto", `2` = "No tiene auto", `9` = "Sin respuesta")) %>%
  count(ID_W, H13B) %>%
  spread(H13B, n, fill=0) %>% 
  mutate(value=(`Si tiene auto`/(`No tiene auto`+`Si tiene auto`))*100)

saveRDS(vehiculo,"vehiculos.RDS")

