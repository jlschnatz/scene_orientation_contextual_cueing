if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,      # easy directories
  raster,    # image data processing
  furrr,     # parallel processing
  tidyverse, # data manipulation
  hutilscpp, # find nearest coords of stimulus in image
  progress   # utilities for computation progress
)

source(here("R/functions/helpers.R"))

image_names <- here("data/scenes/processed") %>%
  list.files() %>%
  str_remove_all(., "\\.png$")

image_files <- here("data/scenes/processed") %>%
  list.files(full.names = TRUE) %>%
  set_names(nm = image_names)

plan(multisession(workers = 8))
img_list <- future_map(
  image_files, 
  pivot_longer_image,
  .progress = TRUE
  )

stim_raw_list <- here(
  "data/psychopy/processed/composite_data.rds"
) %>%
  read_rds(.) %>%
  dplyr::select(
    id_participant, id_scene,
    x_pos_stim = x_pos_unmirr,
    y_pos_stim = y_pos
  ) %>%
  distinct() %>%
  group_split(id_scene) %>%
  set_names(nm = image_names)

plan(multisession(workers = 6))
img_pos_output <- future_map2(
  .x = img_list,
  .y = stim_raw_list,
  .f = ~nearest_neighbour_search(.x, .y)
)

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

temp_x_stim <- vector("list", length(stim_proc_list))
temp_y_stim <- vector("list", length(stim_proc_list))
temp_image <- vector("list", length(stim_proc_list))

rgb_stim <- 128 # rgb value of stimulus (T)

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
        x1 = x_pos_img, y1 = y_pos_img,
        x2 = x_pos_stim,
        y2 = y_pos_stim
      )) %>%
      filter(eucl_dist < .1) %>%
      summarise(
        mab = mean(abs(value - rgb_stim))
        ) %>% 
      pull(mab)
  }
}

contrast_data <- enframe(temp_image, name = "id_scene") %>%
  mutate(id_scene = factor(image_names)) %>%
  unnest(value) %>%
  unnest(value) %>%
  group_by(id_scene) %>%
  mutate(id_participant = as.factor(1:9)) %>%
  dplyr::select(id_participant, id_scene, contrast = value) %>%
  ungroup()

write_rds(
  contrast_data,
  here("data/psychopy/processed/contrast_data.rds")
)


imager::load.image(image_files[5]) %>% print()

imager::load.image(image_files[5]) %>% as.numeric() %>% 
  matrix(nrow = 2848, ncol = 4272) %>% 
  .[1:800, 1:800] %>% 
  reshape2::melt() %>% 
  as_tibble() %>% 
  ggplot(aes(x = Var2, y = Var1, fill = value)) +
  scale_fill_gradient(low = "black", high = "white") + 
  geom_raster(show.legend = F) + 
  theme_void()
img <- raster::stack(image_files[5]) 

mat <- matrix(raster::raster(img, 1), 
       nrow = 2848, ncol = 4272) 

mat[(2848/4):2848, (4272/4):4272] %>% 
  reshape2::melt() %>% 
  as_tibble() %>% 
ggplot(aes(x = Var2, y = Var1, fill = value)) +
  scale_fill_gradient(low = "black", high = "white") + 
  geom_raster(show.legend = F) + 
  theme_void()

heatmap3::heatmap3(mat, useRaster = TRUE)

ggsave("test.pdf", width = 3204, height = 2136, units = "px")
