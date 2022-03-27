library(tidyverse)
library(lubridate)

healthkit_db_con <- DBI::dbConnect(RSQLite::SQLite(), "../data/personal-data-warehouse-data/healthkit/healthkit.db")

workouts <- tbl(healthkit_db_con, "workouts") %>%
  collect() %>%
  mutate(across(matches("Date$"), as_datetime))

workout_points <- tbl(healthkit_db_con, "workout_points") %>%
  collect() %>%
  mutate(date = as_datetime(date))

walk_workout_ids <- workouts %>%
  filter(workoutActivityType == "HKWorkoutActivityTypeWalking") %>%
  pull(id)
