# Reading shapefiles into R

library(rgdal)

counties_md <- readOGR("data/cb_500k_maryland", #folder with all the bits
                       "cb_500k_maryland") #shapefile in that folder


# Basic spatial plots

plot(counties_md)

howard <- counties_md[counties_md[["NAME"]]=="Howard", ]
plot(howard, col="red", add=T)
text(coordinates(counties_md),#will place text at centroids of counties
     labels = counties_md[["NAME"]], cex = 0.7)

# Exercise

# Starting from a fresh map, print numbers on each county in order of
#  the smallest (1) to largest (24) in land area ("ALAND" attribute). 
# Hint: Use `rank(x)` to get ranks from a numeric vector x.

counties_md$rank <- rank(counties_md$ALAND)
plot(counties_md)
text(coordinates(counties_md),#will place text at centroids of counties
     labels = counties_md[["rank"]], cex = 0.7)


# Reading rasters into R

library(raster)

nlcd <- raster("data/nlcd_agg.grd")

attr_table <- nlcd@data@attributes[[1]]

plot(nlcd)

# Change projections

proj4string(counties_md)

counties_proj <- spTransform(counties_md, proj4string(nlcd))

plot(nlcd)
plot(counties_proj, add=T)


# Masking a raster
pasture <- mask(nlcd, nlcd==81, maskvalue = F)
plot(pasture)


# Exercise

# Create a mask for a different land cover class. 
#  Look up the numeric ID for a specific class in attr_table.

city <- mask(nlcd, nlcd==22:24, maskvalue = F)
plot(city)


# Adding data to maps with tmap

library(tmap)

qtm(...)

qtm(counties_proj, fill = ..., ... = "NAME")

map1 <- tm_shape(...) +
            ...() +
            ...("AWATER", title = "Water Area (sq. m)") +
            tm_text(..., size = 0.7)

map1 +
    tm_style_classic(legend.frame = TRUE) +
    tm_scale_bar(position = ...)


# Exercise

# The color scales in tmap are divided into bins by default. 
# Look at the help file for tm_fill: help("tm_fill") to find which argument
#  controls the binning scale. How can you change it to a continuous gradient?

...


# Interactive maps with leaflet

library(leaflet)

imap <- leaflet() %>%
            ...() %>%
            ...(lng = -76.505206, lat = 38.9767231, zoom = ...)

imap %>%
    ...(
        "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
        layers = "nexrad-n0r-900913", group = "base_reflect",
        options = WMSTileOptions(format = "image/png", transparent = TRUE),
        attribution = "Weather data © 2012 IEM Nexrad"
    )
