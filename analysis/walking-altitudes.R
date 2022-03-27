source("load.R")

random_walk_ids <- walk_workout_ids %>% sample(size = 10)

workout_points %>%
  filter(workout_id %in% random_walk_ids) %>%
  group_by(workout_id) %>%
  mutate(
    pct_workout = row_number(),
    pct_workout = pct_workout / max(pct_workout)
  ) %>%
  ggplot(aes(x = pct_workout, y = altitude)) +
  geom_point() +
  facet_wrap(~workout_id)
