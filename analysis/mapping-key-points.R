source("load.R")

library(sf)
library(leaflet)

library(ggmap)
library(ggpointdensity)

basemap_ottawa <- get_map(
  location = c(
    left = -75.9671,
    bottom = 45.1582,
    right = -75.2907,
    top = 45.5770
  )
)


start_points <- workout_points %>%
  group_by(workout_id) %>%
  slice_head(n = 1) %>%
  ungroup() %>%
  st_as_sf(coords = c("longitude", "latitude")) %>%
  st_set_crs(4326)
  
end_points <- workout_points %>%
  group_by(workout_id) %>%
  slice_tail(n = 1) %>%
  ungroup() %>%
  st_as_sf(coords = c("longitude", "latitude")) %>%
  st_set_crs(4326)

start_points %>%
  leaflet() %>%
  addCircleMarkers(
    stroke = FALSE
  ) %>%
  addTiles()

start_points %>%
  ggplot() +
  geom_sf()

workout_points %>%
  filter(longitude > -76, latitude < 46, latitude > 45) %>% # roughly within Ottawa range
  slice_sample(prop = 0.05) %>% # choose random subset, because plotting all the points is very expensive
  ggplot(aes(longitude, latitude)) +
  geom_pointdensity(size = 0.5)

workout_points %>%
  filter(longitude > -76, latitude < 46, latitude > 45) %>% # roughly within Ottawa range
  slice_sample(prop = 0.01) %>%
  leaflet() %>%
  addCircleMarkers(
    stroke = FALSE
  ) %>%
  addTiles()

ggmap(basemap_ottawa) +
  geom_sf(
    start_points,
    aes()
  )


# Refs
# - https://stackoverflow.com/questions/61056371/gps-heatmap-with-ggplot-geom-path
# - https://stackoverflow.com/questions/57833905/how-to-convert-a-list-of-sf-spatial-points-into-a-routable-graph
# - https://r-spatial.org/r/2019/09/26/spatial-networks.html
# - https://github.com/luukvdmeer/sfnetworks
