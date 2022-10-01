if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,      # easy directories
  tidyverse, # data manipulation
  lubridate  # working with dates
)

source(here("R/functions/helpers.R"))

raw_data <- here("data/psychopy/raw") %>%
  list.files(
    full.names = TRUE,
    pattern = "\\.csv$"
  ) %>%
  map_dfr(.x = ., .f = ~read_csv(
    file = .x,
    col_names = TRUE,
    col_types = cols(
      Xcoord = col_double(),
      Ycoord = col_double(),
      Xpos = col_double(),
      Ypos = col_double(),
    ),
    show_col_types = FALSE)) %>%  
  dplyr::select(
    # identification variables
    id_participant = id_participant,
    id_block = BlockNumber,
    id_trial = TrialLoop.thisN,
    id_scene = FileName,
    id_orientation = TrialType,
    # response variable
    rt = find_target.time,
    # hit target on time
    hit = ClickInTime,
    # target position
    x_pos_unmirr = Xcoord,
    x_pos_mirr = Xpos,
    y_pos = Ycoord,
    # demographics
    age = `age...19`,
    handedness = `handedness...20`,
    gender = `gender...21`,
    date = date
  ) %>%
  filter(!id_orientation == "None") %>%
  mutate(id_trial = id_trial + 1) %>% 
  mutate(across(c(contains("id"), handedness, gender), as.factor)) %>%
  mutate(date = parse_date_time(date, "%Y%b%d%H%M")) %>% 
  arrange(id_participant, id_block, id_trial)

write_rds(
  x = raw_data,
  file = here("data/psychopy/processed", "composite_data.rds")
  )

