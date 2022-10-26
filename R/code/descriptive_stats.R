library(here)
library(tidyverse)

composite_cleaned_data <- read_rds(
  here("data/psychopy/processed/composite_cleaned_data.rds")
  ) 

# count hits vs. misses without grouping
hr_data <- composite_cleaned_data %>% 
  group_by(hit) %>% 
  summarise(
    n_abs = n(),
    n_rel = n()/nrow(.)
  ) %>% 
  filter(hit == 1) 

composite_cleaned_data %>% 
  select(id_participant, age, gender, handedness) %>% 
  distinct() %>% 
  summarise(
    mean_age = mean(age),
    sd_age = sd(age),
  ) 
