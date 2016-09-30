source("data-raw/header.R")

## get map from bcmaps
map <- raster::intersect(bcmaps::ecoprovinces, bcmaps::bc_bound)

## Simplify the polygons. Need to disaggregate first so that pieces of
## multipart polygons are not removed
map %<>% disaggregate()
map %<>% rmapshaper::ms_simplify(keep = 0.02, keep_shapes = TRUE)

## aggregating small polygons into 1 for each ecozone
map %<>% aggregate(by = "CPRVNCNM")

## changing projection
map %<>% spTransform(CRS("+init=epsg:4326"))
names(map)[1] <- "Ecoprovince"
map$Ecoprovince %<>% tolower() %>% tools::toTitleCase()

map %<>% spTransform(CRS("+init=epsg:4326"))

use_data(map, overwrite = TRUE)
