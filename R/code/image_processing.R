library(here)
library(raster)
library(imager)
library(rlang)
library(furrr)
library(tictoc)
library(tidyverse)
source(here("R/functions/helpers.R"))

image_names <- here("data/scenes/processed") %>% 
  list.files() %>% 
  str_remove_all(., "\\.png$")

image_files <-  here("data/scenes/processed") %>% 
  list.files(full.names = TRUE) %>% 
  set_names(nm = image_names)

# first method
image_to_long <- function(image_filepath){
  image_filepath %>% 
    imager::load.image() %>% 
    as.data.frame() %>% 
    as_tibble() %>% 
    rename(x_pos = x, y_pos = y) %>% 
    mutate(value = normalize_iv(value, 0, 254)) 
}

plan(multisession(workers = 10))
tic()
comp <- image_files %>% 
  future_map(image_to_long)
toc()

comp$Bathroom_1 %>% 
  mutate(
    x_pos = normalize_iv(x_pos, -.5, .5),
    y_pos = normalize_iv(y_pos, -.8, .8)
  )

# second method
stack_image_pixels <- function(image_filepath) {
  img <- raster::stack(image_filepath)
  out <- matrix(raster::raster(img, 1), 
                nrow = 2848, ncol = 4272) %>% 
    as.data.frame.table(., responseName = "value") %>%
    as_tibble() %>% 
    mutate(across(where(is.factor), as.integer)) %>% 
    rename(height = Var1, width = Var2)
  return(out)
}

plan(multisession(workers = 8))
tic()
images_long <- 
image_files %>%
  future_map_dfr(
    .f = stack_image_pixels,
    .id = "id_scene",
    .progress = TRUE
    )
toc()


normalized_images <- images_long %>%
  mutate(
    height = normalize_iv(height, -.5, .5),
    width = normalize_iv(width, -.8, .8)
         )


combined <- raw_data %>% 
  select(id_scene, x_pos_unmirr, y_pos) %>%
  right_join(., y = normalized_images, by = "id_scene")

# window size: 1440 * 900 -> 1 : 1.6
# height: from -.5 to .5
# width: from -.8 to .8

# 2560 x 1600 mac book dims -> 1 : 1.6
# 4272 x 2848 image dims   -> 1 : 1.5
# 2400 x 1600 -> new aspect ratio for image when displayed

# stimulus dimensions in pixels: (160 * 0.04)^2 = 64^2

# color of grey T is: 128 (in RGB) or (0,0,0) in Psychopy

