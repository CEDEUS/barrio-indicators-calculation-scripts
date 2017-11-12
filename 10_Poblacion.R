# Poblacion total

#Connections 
library(RMySQL)
library(tidyverse)

con <- src_mysql(dbname = "censo2012",
                 host = Sys.getenv("MYSQL_HOST"),
                 user = Sys.getenv("MYSQL_USER"),
                 password = Sys.getenv("MYSQL_PASS")
                 )

#Start querying

# Generating ID_W
geoid <- tbl(con,"idgeo") %>% 
  select(FOLIO,NVIV,COM,DTO,AREA,ZONA,MZ,LOCALIDAD,ENTIDAD,SECTOR) %>% 
  collect(n=Inf) %>% 
  mutate(ID_W=paste(COM,sprintf("%02d", DTO),AREA,ifelse(AREA==1, sprintf("%03d",ZONA), ifelse(AREA==2, sprintf("%03d",LOCALIDAD), 0)),ifelse(AREA==1, sprintf("%03d",MZ), ifelse(AREA==2, sprintf("%03d",ENTIDAD), 0)),sep="")) %>% 
  select(FOLIO,NVIV,ID_W)

# Calculating population by manzana

numberpeople <-tbl(con,"poblacion") %>%
  select(FOLIO,NVIV) %>% collect(n=Inf) %>% 
  left_join(geoid, by=c("FOLIO"="FOLIO","NVIV"="NVIV")) %>% 
  group_by(ID_W) %>% 
  summarize(value = n())

  writeRDS(numberpeople,"poblacion.RDS")

