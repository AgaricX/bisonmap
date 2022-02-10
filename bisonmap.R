## Make a map of the Bison Herd Locations
## original script https://www.r-spatial.org/r/2018/10/25/ggplot2-sf-2.html
## Modified by Sam Stroupe, PhD Student, Texas A&M University

library("sf")
library("rnaturalearth")
library("rnaturalearthdata")
library("ggplot2")
library("cowplot")
library("googleway")
library("ggrepel")
library("ggspatial")
library("libwgeom")
library("rgeos")
library("tools")
library("maps")

#load the location data for herds with decimal coordinates#
Herds <- read.csv("Herd_Locations.csv")

#Make a map of the World
world <- ne_countries(scale = "medium", returnclass = "sf")

#Add states to map
states <- st_as_sf(map("state", plot = FALSE, fill = TRUE))
states <- cbind(states, st_coordinates(st_centroid(states)))
states$ID <- toTitleCase(states$ID)

ggplot(data = world) +
  geom_sf() +
  geom_sf(fill = "antiquewhite1") +
  geom_point(data = Herds, aes(x = longitude, y = latitude, col= Subspecies , shape= Age), size = 4) +
  geom_text_repel(data = Herds, aes(x = longitude, y = latitude, label= Herd.Name),
             fontface = "bold", size = 4) +
  # ggtitle("Bison Sample Locations") +
  annotation_north_arrow(location = "bl", which_north = "true", 
                         pad_x = unit(0.75, "in"), pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme(panel.background = element_rect(fill = "aliceblue")) + 
  #geom_sf(data = states, fill = NA) +
  coord_sf(xlim = c(-170, -50), ylim = c(20, 80))
