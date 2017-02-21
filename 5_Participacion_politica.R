# Leer base de datos del padron

# San Miguel
A1321021 <- read_delim("~/Dev/Extract_PDF/A1321021.csv", ";", escape_double = FALSE, trim_ws = TRUE)

# Hacer subset de las calles involucradas en los barrios piloto

# Hacer geocoding de las personas que coinciden con la localizacion

# Ver las mesas que estan involucradas haciendo un summarize count

# Ver cuantas personas hay por mesa utilizando el padron

# Usando las bases del servel ver cuantos votos hay por mesa es decir cuantas personas participaron en la eleccion 
# https://www.servel.cl/participacion-electoral/

# Obtener % participacion por mesa

# Calcular la probabilidad de que el grupo de personas que vota en la mesa X haya participado 

