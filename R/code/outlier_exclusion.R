library(here)
library(tidyverse)
library(glue)
source(here("R/functions/helpers.R"))

raw_data <- read_csv(
  file = here("data/psychopy/processed/composite_data.csv")
)

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
  filter(!is_outlier == 1)

write_csv(
  x = composite_cleaned_data,
  file = here(
    "data/psychopy/processed",
    "composite_cleaned_data.csv"
  ))
