rgb_value <- 128

rgb_to_luminance <- function(rgb) {
  # step one
  srgb <- rgb / 255
  # step two
  if (srgb >= 0.04045) {
    lin_srgb <- srgb / 12.92
  } else {
    lin_srgb <- ((srgb + 0.055) / 1.055)^2.4
  }
  # step three
  luminance <- 
    0.2126 * lin_srgb + 
    0.7152 * lin_srgb + 
    0.0722 * lin_srgb
  return(tibble::tibble(
    rgb = rgb,
    srgb = srgb,
    lin_srgb = lin_srgb,
    luminance = luminance
    ))
}

rgb_to_luminance(128)



composite_cleaned_data %>% 
  filter(id_participant == "1")  %>% 
  dplyr::select(starts_with("id"), rt, contrast) %>% 
  view
