#Sustainability at barrio scale

Welcome to our indicators project! the objetives are:

- Evaluate the possibility of an sustainability measure in different data dimensions.
- Evaluate homogeneous areas in some indicators.
- Explore differences between sampling areas in different contexts.

#How this repository works

We have a centralized MYSQL server with all the public databases like the census 2012 and others to have major performance in the processing. So the R scripts connect with the server and request the data without putting on the RAM all the content improving the handle of big resources. To make plots the shp files of the census 2012 were requested by law of transparency to INE (Instituto Nacional de Estadisticas). 
