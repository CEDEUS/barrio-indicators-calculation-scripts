# Changelog

## 30/01 - 03/02

- Rewrite and consolidation of indicators. 
- Work on “Empleabilidad en la misma comuna” y “Materialidad de la vivienda”. Now we have four indicators ready to apply.

## 06/02 - 10/02

- Work on Rodrigo's cultural equipment indicator. Help converting PDF file to CSV.
- Work on participation indicator using the voter registration list (PDF extraction).

## 13/02 - 17/02

- Work on participation indicator (Geocoding).

## 20/02 - 24/02

- Clip of people living in the barrio.
- Uploaded proof of concept of the participation indicator in a separate branch, needs discussion.

## 20/02 - 25/02

- FONDECYT TRIP

## 06/03 - 10/03

- Work on indicator visualizations.

## 13/03 - 17/03

- Reproducibility of green area indicator.
- BarriosSust bug fixes.

## 20/03 - 24/03

- Finished BarrioSust app.
- Team meeting feedback.

## 20/03 - 24/03

- Added mean and std for the barrio and the buffer.
- Legend fixes (added percentaje).
- Added new barrios.

## 27/03 - 31/03

- Added unit counter

## 03/04 - 07/04

- Started modularizing code

## 10/04 - 14/04

- Started exploring alternatives to add new data
- Bug hunting & fixing 
  - Legend Values: The calculation of values was done before on all barrios so they are correct. For leaflet the shape needs to be filtered for perfomance purposes and the legends only shows the calculation over all barrios.

## 17/04 - 21/04

- Added barrios modelo
- Added custom legends
- Publication graphs
- K-Means Clustering
- Search for similar projects

## 24/04 - 28/04

- Statistical tests coding (normality, t-test, kruskal, anova)

## 02/05 - 12/05

- Statistical tests over differents types of barrios

## 15/05 - 02/06

- Work on reporting statistical tests (uploaded to rpubs.com)

## 05/06 - 09/06

- New statistical tests over types of barrio and between cities

## 12/06 - 16/06

- Start working on new walkability indicator
- Searching for methods

## 19/06 - 30/06

- Extraction of walkability data from walkscore - 10 min - 1.25 m/s for barrios in the platform
- Extraction of walkability data from walkscore - 15 min - 1.38 m/s for barrios in the platform

## 03/07 - 07/07

- Added data to the visualization (10 min - 1.25 m/s) for the barrios
- Bugfix in the platform because duplicated manzanas with different values					
- Tests to search differences in the contexts and cities

## 10/07 - 14/07

- Builded small platform to watch boxplots from the different contexts
- Started learning about quadtrees - rtrees
- Searching for a method to join SII data with census data

## 17/07 - 21/07

- First attempts using centroids and trying to get the sii polygon where it falls

## 24/07 - 28/07

- Start analizyng python code to get the way of to do it
- Start writing script to calculate the appartments by manzana (DPTO,DEPTO,DTO).

## 31/07 - 11/08

- Script to search appartments done but very inaccurate because dirty database
- Attempt failed, looking for a new method to join SII polygons with census (gDifference, bbox and extent)

## 14/08 - 18/08

- Looking for new barrios using the Wikimapia platform
- Work on Rodrigo's regexes to get the street names from the mineduc database

## 21/08 - 25/08 

- Extraction of barrios from the Wikimapia platform, troubles getting it out, searching for a method to convert KML to SHP in unix
- Bash script to convert KML to SHP using ogr2ogr, it downloads the feature from wikimapia using wget and converts the file to shp (tricky script)
- Extracted new barrios to the platform barrios sustentables: Villa Codelco, Tierra Viva Oriente, Villa Vista Hermosa, El Llano, Barrio San Miguel, Barrio Brasil, Barrio Las Lilas y Barrio Jardin del Este.
- Helped Rodrigo with the extraction of ferias libres by municipality from a portal	using a custom script

## 28/08 - 08/09

- Added new barrios joining polygons with the prexistent barrios
- Join with the census polygons
- Rebuilded indicators: % empleados en la misma comuna, % Mujeres trabajando, % de viviendas de buena calidad, Acceso a tecnologias de la Información, Cercania a areas verdes
- Created new script to add new barrios (not so easy)

## 11/09 - 15/09

- Updated walkability indicators y new scripts to extract from the OTP platform
- Bugfix in the platform of barrios sustentables (UTF-8 for spanish characters and adjustements for the new barrios)
- Looking for new indicators

## 25/09 - 06/10

- Added new barrios: Fundo El Carmen, Barrio Estación, Barrio Amanecer, Lomas de San Sebastian, Villa Los Fundadores, Camilo Henríquez, Parque Krahmer y Sector Regional
- Extraction from Wikimapia KML to SHP						
- Join
- Join with shapes of census
- Updated indicators
- Uploaded scripts to GIT

## 09/10 - 20/10

- Sucess looking for a method to use quadtrees in R
- Created a method using the 4 nearest polygons and selecting the polygon with the largest area
- Last method now is a function to use it on batch mode
- Second method using the data from the neighbors and calculating the mean and median
- Backup of data on the server
- Learning about walkability using OSMnx and pandana

## 23/10 - 03/11

- Bug fix in the attempt to join, creation of tests using quadtrees and changed the way of how to do it 
- Script rewrite to add the largest area of intersection with the sii polygon
- Year of construction by SII manzana calculated using the median added to polygon and visualized using qgis to test
- Added indicator to the platform, bug fixing on the visualization to show a new categorical legend
- Added to GIT
