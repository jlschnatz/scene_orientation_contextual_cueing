if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,      # easy directories
  tidyverse, # data manipulation
  glue       # for find_outliers() function
)

source(here("R/functions/helpers.R"))

raw_data <- read_rds(
  file = here("data/psychopy/processed/composite_data.rds")
)

# outlier exclusion

out_1 <- raw_data %>%
  filter(id_block == 1) %>%
  find_outliers(
    .,
    rt = "rt",
    sd_crit = 3, id_participant
  )

out_2 <- raw_data %>%
  filter(id_block == 2) %>%
  find_outliers(
    .,
    rt = "rt", sd_crit = 3,
    id_participant, 
    id_orientation
  )

outliers <- full_join(x = out_1, y = out_2) %>%
  filter(!is_outlier == 0)

composite_cleaned_data <- full_join(x = out_1, y = out_2) %>%
  filter(!is_outlier == 1) %>% 
  mutate(center_distance = euclidean_distance(
    data = .,
    x1 = x_pos_unmirr,
    y1 = y_pos
  )) %>% 
  left_join(., y = read_rds(
    here("data/psychopy/processed/contrast_data.rds"))
    ) %>% 
  dplyr::select(
    contains("id"), rt, hit, contrast, center_distance,
    age, handedness, gender, date
    )

write_rds(
  x = composite_cleaned_data,
  file = here(
    "data/psychopy/processed",
    "composite_cleaned_data.rds"
  ))



source("R/functions/theme_scientific.R")

composite_cleaned_data %>%
  filter(hit == 1) %>% 
  mutate(contrast = normalize_iv(contrast, 0, 1)) %>% 
  ggplot(aes(x = contrast, y = center_distance, color = rt)) + 
  geom_point() +
  scale_color_viridis_c(
    name = "RT",
    trans = "log2", 
    breaks = c(1, 2, 4, 8, 16),
    limits = c(NA, 16),
    direction = -1,
    option = "B") + 
  scale_x_continuous(
    name = "Contrast",
    limits = c(0, 1),
    breaks = seq(0, 1, .2),
    expand = c(0,0)
  ) +
  scale_y_continuous(
    name = "Center distance",
    limits = c(0, 1),
    breaks = seq(0, 1, .2),
    expand = c(0,0)
  ) +
  coord_equal(clip = "off") + 
  theme_scientific() +
  theme(
    legend.position = c(0.5, 0.94),
    legend.direction = "horizontal",
    legend.title = element_text(vjust = .85)
  ) 


composite_cleaned_data %>% 
  group_by( id_scene) %>% 
  count() %>% 
  print(n = 358)
