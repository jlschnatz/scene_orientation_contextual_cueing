library(here)
library(tidyverse)

composite_cleaned_data <- read_csv(
  here("data/psychopy/processed/composite_cleaned_data.csv")
  ) 

# count hits vs. misses by id_orientation
composite_cleaned_data %>% 
  group_by(id_orientation) %>% 
  mutate(n_orientation = n()) %>% 
  group_by(id_orientation, hit) %>% 
  summarise(
    n_abs = n(),
    n_rel = n()/n_orientation,
    .groups = "drop"
    ) %>% 
  distinct()

# count hits vs. misses without grouping
composite_cleaned_data %>% 
  group_by(hit) %>% 
  summarise(
    n_abs = n(),
    n_rel = n()/nrow(.)
    )

composite_cleaned_data %>% 
  select(id_participant, age, gender, handedness) %>% 
  distinct() %>% 
  summarise(
    mean_age = mean(age),
    sd_age = sd(age),
  ) 

composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  group_by(id_block, id_orientation) %>% 
  summarise(
    mean_rt = mean(rt),
    sd_rt = sd(rt),
    .groups = "drop"
  )

# potential interference  mirrored condition 
# subjects recognize scene but react slower due to the 
# manipulated scene orientation

