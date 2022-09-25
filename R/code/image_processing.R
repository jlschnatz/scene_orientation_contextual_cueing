library(here)
library(tidyverse)
library(magick)
library(imager)
library(raster)
library(rlang)
library(furrr)
library(tictoc)

image_list <- here("data/scenes/processed") %>%
  list.files(full.names = TRUE) %>%
  map(image_read)
image_info(image_list[[1]])

image_scale(image_list[[1]], geometry = "500")

image_names <- list.files(here("data/scenes/processed")) %>% 
  str_remove_all(., "\\.png$")
image_files <- list.files(
  here("data/scenes/processed"),
  full.names = TRUE
  ) %>% 
  set_names(nm = image_names)

t <- raster::stack(image_files[1])
t@nrows
t@ncols

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

centered_images_long <- 
images_long %>% 
  mutate(width = width - (max(width)/2),
         height = height - (max(height)/2))

centered_images_long %>%
  filter(width == 0 & height == 0)

# height: from -.5 to .5
# width: from -.8 to .8

# 2560 x 1600 mac book dims -> 1 : 1.6
# 4272 x 2848 image dims   -> 1 : 1.5
# 2400 x 1600 -> new aspect ratio for image when displayed


function(data, aspect_ratio) {
  scaling_factor <- aspect_ratio
}
