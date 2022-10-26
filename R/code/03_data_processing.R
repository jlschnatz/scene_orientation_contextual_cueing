if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}
source(here::here("R/functions/helpers.R"))
pacman::p_load(
  here,      # easy directories
  tidyverse, # data manipulation
  glue       # for find_outliers() function
)

raw_data <- read_rds(
  file = here("data/psychopy/processed/composite_data.rds")
)

# outlier exclusion
out_1 <- raw_data %>%
  filter(id_block == 1) #%>%
  # find_outliers(
  #   .data = .,
  #   .rt = rt,
  #   .sd_crit = 3,
  #   .groups = id_participant
  # )
out_2 <- raw_data %>%
  filter(id_block == 2)# %>%
  # find_outliers(
  #   .data = .,
  #   .rt = rt, .sd_crit = 3,
  #   .groups = c(id_participant, id_orientation)
  # )
outliers <- full_join(
  x = out_1, y = out_2,
  by = colnames(out_1)
  ) #%>%
#  filter(!is_outlier == 0)

composite_cleaned_data <- full_join(
  x = out_1, y = out_2,
  by = colnames(out_1)) %>%
 # filter(!is_outlier == 1) %>% 
  mutate(center_distance = euclidean_distance(
    .data = .,
    .x1 = x_pos_unmirr,
    .y1 = y_pos
  )) %>% 
  left_join(., y = read_rds(
    here("data/psychopy/processed/contrast_data.rds")),
    by = c("id_participant", "id_scene")
    ) %>% 
  dplyr::select(
    contains("id"), rt, hit, contrast, center_distance,
    age, handedness, gender, date
    )

# export rds file with processed data
write_rds(
  x = composite_cleaned_data,
  file = here(
    "data/psychopy/processed",
    "composite_cleaned_data.rds"
  ))
