# packages and functions
if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,      # easy directories
  raster,    # image data processing
  furrr,     # parallel processing
  tidyverse, # data manipulation
  progress   # utilities for computation progress
)
source(here("R/functions/helpers.R"))

# image filepaths
image_names <- here("data/scenes/processed") %>%
  list.files() %>%
  str_remove_all(., "\\.png$")

image_files <- here("data/scenes/processed") %>%
  list.files(full.names = TRUE) %>%
  set_names(nm = image_names)

# store all images in img_list as long tibbles
plan(multisession(workers = 6))
img_list <- future_map(image_files, pivot_longer_image)

# get stimulus position data
stim_raw_list <- here("data/psychopy/processed/composite_data.rds") %>%
  read_rds(.) %>%
  dplyr::select(
    id_participant, id_scene,
    x_pos_stim = x_pos_unmirr,
    y_pos_stim = y_pos
  ) %>%
  distinct() %>%
  group_split(id_scene) %>%
  set_names(nm = image_names)

# find nearest neighbor for images pixels and stimulus data as a query
plan(multisession(workers = 6))
img_pos_output <- future_map2(
  .x = img_list,
  .y = stim_raw_list,
  .f = ~nearest_neighbour_search(.x, .y, .algorithm = "brute")
)

# store nearest neighbor values together with rgb value in tibble
stim_proc_list <- enframe(img_pos_output, name = "id_scene") %>%
  unnest(value) %>%
  group_split(id_scene) %>%
  map2(
    .x = img_list, .y = .,
    .f = ~ .x %>% slice(.y$index)
    ) %>%
  map2(
    .x = ., .y = stim_raw_list,
    .f = ~.x %>% bind_cols(id_participant = .y$id_participant, .)
    ) %>% 
  enframe(name = "id_scene") %>%
  unnest(value) %>%
  rename(y_pos_stim = y_pos_img, x_pos_stim = x_pos_img) %>%
  group_split(id_scene) %>%
  set_names(image_names)

# create temporary files for the loops
temp_x_stim <- vector("list", length(stim_proc_list))
temp_y_stim <- vector("list", length(stim_proc_list))
temp_image <- vector("list", length(stim_proc_list))

rgb_stim <- 128 
pb <- progress_bar$new(total = 360)
for (scene in seq_len(length(stim_proc_list))) {
  for (part in 1:9) {
    pb$tick()
    temp_x_stim[[scene]][part] <- stim_proc_list[[scene]] %>%
      slice(part) %>%
      pull(x_pos_stim)
    
    temp_y_stim[[scene]][part] <- stim_proc_list[[scene]] %>%
      slice(part) %>%
      pull(y_pos_stim)

    temp_image[[scene]][part] <- img_list[[scene]] %>%
      mutate(
        y_pos_stim = temp_y_stim[[scene]][part],
        x_pos_stim = temp_x_stim[[scene]][part]
      ) %>%
      mutate(eucl_dist = euclidean_distance(
        .,
        .x1 = x_pos_img, 
        .y1 = y_pos_img,
        .x2 = x_pos_stim,
        .y2 = y_pos_stim
      )) %>%
      filter(eucl_dist < .08) %>% 
      summarise(
        mad = mean(abs(value - rgb_stim)) 
      ) %>% 
      pull(mad)
  }
}

contrast_data <- enframe(temp_image, name = "id_scene") %>%  
  mutate(id_scene = factor(id_scene, labels = image_names)) %>% 
  unnest(value) %>%
  group_by(id_scene) %>%
  mutate(id_participant = as.factor(1:9)) %>%
  dplyr::select(id_participant, id_scene, contrast = value) %>%
  ungroup() 

write_rds(
  contrast_data,
  here("data/psychopy/processed/contrast_data.rds")
)


