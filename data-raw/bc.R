source("data-raw/header.R")

## get bc from bcmaps
bc <- raster::intersect(bcmaps::ecoprovinces, bcmaps::bc_bound)

## Simplify the polygons. Need to disaggregate first so that pieces of
## multipart polygons are not removed
bc %<>% disaggregate()
bc %<>% rmapshaper::ms_simplify(keep = 0.02, keep_shapes = TRUE)

## aggregating small polygons into 1 for each ecozone
bc %<>% aggregate(by = "CPRVNCNM")

## changing projection
bc %<>% spTransform(CRS("+init=epsg:4326"))
names(bc)[1] <- "Ecoprovince"
bc$Ecoprovince %<>% tolower() %>% tools::toTitleCase()

bc %<>% spTransform(CRS("+init=epsg:4326"))

use_data(bc, overwrite = TRUE)
