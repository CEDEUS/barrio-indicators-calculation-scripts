#Numero de personas con trabajo/estudio en la comuna "en la vivienda" o "fuera de la vivienda" / Poblacion total

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
geoid <- tbl(con, "idgeo") %>% 
  select(FOLIO,NVIV,COM,DTO,AREA,ZONA,MZ,LOCALIDAD,ENTIDAD,SECTOR) %>% 
  collect(n=Inf) %>% 
  mutate(ID_W=paste(COM,sprintf("%02d", DTO),AREA,ifelse(AREA==1, sprintf("%03d",ZONA), ifelse(AREA==2, sprintf("%03d",LOCALIDAD), 0)),ifelse(AREA==1, sprintf("%03d",MZ), ifelse(AREA==2, sprintf("%03d",ENTIDAD), 0)),sep="")) %>% 
  select(FOLIO,NVIV,ID_W)

emc <- tbl(con, "poblacion") %>%
  select(FOLIO,NVIV,P38A) %>% 
  collect(n=Inf) %>%
  left_join(geoid, by=c("FOLIO"="FOLIO","NVIV"="NVIV")) %>% 
  filter(P38A==1 | P38A==2) %>% 
  group_by(ID_W) %>% 
  summarize(count = n())

total <- tbl(con, "poblacion") %>%
  select(FOLIO,NVIV,P38A) %>% 
  collect(n=Inf) %>% 
  left_join(geoid, by=c("FOLIO"="FOLIO","NVIV"="NVIV")) %>%
  group_by(ID_W) %>%
  summarize(total = n())

final <- left_join(emc, total, by=c("ID_W"="ID_W")) %>% mutate(listo = count/total)

#Cleaning
rm(list=c("total","emc","geoid"))