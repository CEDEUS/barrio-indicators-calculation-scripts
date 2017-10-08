library(rgdal)
library(spdplyr)
library(rgeos)
library(httr)
library(jsonlite)

shape <- readOGR(dsn = "export/", layer = "piloto")
shape$MANZENT<-as.character(shape$MANZENT)
shape.cntrd <- shape %>% left_join(numberpeople,by=c("MANZENT"="ID_W")) %>% filter(!is.na(count))
shape.cntrd_ctrn <- gCentroid(shape.cntrd,byid=TRUE)

table.post <- as.data.frame(cbind(shape.cntrd$MANZENT,coordinates(shape.cntrd_ctrn),as.character(shape.cntrd$BARRIO)),stringsAsFactors = F)
colnames(table.post) <- c("name","lon","lat","barrio")
table.post$lon <- as.numeric(table.post$lon)
table.post$lat <- as.numeric(table.post$lat)

get.score <- function(x) {
  url <- RETRY("GET", paste0("http://0.0.0.0:17080/api?mode=walk&start_point=",x,"&walking_time_period=15&walking_speed=1.38"),timeout=100)
  data <- content(url,"text")
  tryCatch(return(data.frame(score=as.vector(fromJSON(data)$walkshed$properties$score))),
           error = function(e) {
             return(data.frame(score=NA))
           }
  )}

final <- apply(table.post, 1, function(x) {
  print(toString(x[1]))
  data <- get.score(paste0(x[3],",",x[2]))
  frame <- cbind(data.frame(id=rep(x[1],nrow(data))),data,d=rep(x[4],nrow(data)))
  rownames(frame) <- NULL
  print(frame)
})


t <-do.call("rbind",setNames(final, NULL))

colnames(t) <- c("ID_W","listo","d")
t$listo <- as.numeric(as.character(t$listo))
write_rds(t,"accesibility_score_final_15.RDS")

