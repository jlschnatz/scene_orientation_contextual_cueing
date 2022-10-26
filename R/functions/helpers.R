# Function: Compute Euclidean distance of a vector from the origin
# Input:
#   - data: containing x, and y
#   - x:    x component of vector
#   - y:    y component of vector
# Output: vectorized euclidean distance 

euclidean_distance <- function(.data, .x1, .y1, .x2 = 0, .y2 = 0) {
  df <- .data %>% dplyr::select({{ .x1 }}, {{ .y1 }}, {{ .x2 }}, {{ .y2 }})
  out <- df %>% 
    dplyr::summarise(
      sqrt(({{ .x1 }} - {{ .x2 }})^2 + ({{ .y1 }} - {{ .y2 }})^2 )
      ) %>% 
    dplyr::pull()
  return(out)
}

# Function: normalize set of values between a given interval
# Input:
#   - x:      vector containing the set of values
#   - lower:  lower bound of interval
#   - upper:  upper bound of interval
# Output: returns vector of normalized values between the given interval bounds

normalize_iv <- function(.x, .lower, .upper) {
  out <- (.upper - .lower) * (.x - min(.x))/(max(.x) - min(.x)) + .lower
  return(out)
}

# Function: find outliers of distribution of reaction times
# Details:  outliers are detected via given
#           standard deviations from a subject's mean score
# Input:
#   - data:    the data containing the reaction time variable
#   - rt:      the reaction time variable
#   - sd_crit: critical standard deviations, values higher will be excluded
#   - .groups:     possible grouping variables
# Output: data frame with two new columns: 
#   - the z-transformed reaction time variable
#   - binary is_outlier variable indicating if rt is an outlier (0: no, 1: yes)

find_outliers <- function(.data, .rt, .sd_crit, .groups = NULL) {
  .groupings <- dplyr::enquos(.groups)
  .rt_enquo <- dplyr::enquo(.rt)
  var_name <- glue::glue("{ensym(.rt)}_scaled")
  out <- .data %>% 
    dplyr::group_by(!!.groupings) %>% 
    dplyr::mutate(
      !!sym(var_name)  := as.vector(scale(!!.rt_enquo, center = T, scale = T)),
      is_outlier = dplyr::case_when(abs(!!sym(var_name)) > .sd_crit ~ 1, TRUE ~ 0)
      ) %>% 
    dplyr::ungroup() %>% 
    select(-`<quos>`) 
  return(out)
}

# Function: Save image as long formatted data frame with normalized dimensions
# Details:  Image gets read in as raster layer object and then transformed into a matrix.
#           After that, the matrix gets transformed into a long-formatted data frame while
#           also normalizing the x and y coordinates according the the height units in Psychopy.
# Input:
#  - .path: absolute image filepath
# Output: 
#  - tibble with 3 columns (x_img containing the x-coordinate, 
#    y_img the y-coordinate and value the grey luminance value for each image pixel)  

pivot_longer_image <- function(.path) {
  img <- raster::raster(.path)
  out <- img %>% 
    matrix(nrow = 4272, ncol = 2848) %>% 
    pracma::flipdim(dim = 2) %>% 
    as.data.frame.table(., responseName = "value") %>%
    dplyr::as_tibble() %>% 
    dplyr::mutate(across(where(is.factor), as.integer)) %>% 
    dplyr::rename(x_pos_img = Var1, y_pos_img = Var2) %>% 
    dplyr::mutate(
      x_pos_img = normalize_iv(x_pos_img, -.8, .8),
      y_pos_img = normalize_iv(y_pos_img, -.5, .5),
    ) %>% 
    dplyr::relocate(x_pos_img, .before = everything())
  return(out)
}

nearest_neighbour_search <- function(.img, .stim,
                                     .algorithm = c("kd_tree", "cover_tree", "CR", "brute")) {
  rlang::arg_match(.algorithm)
  data <- .img %>% 
    dplyr::select(contains("pos"))
  query <- .stim %>% 
    dplyr::select(contains("pos"))
  
  nn_results <- FNN::knnx.index(
    data = data,
    query = query,
    k = 1,
    algorithm = .algorithm
  )
  out <- tibble(index = as.vector(nn_results))
  return(out)
}

boot_resamples <- function(.model, .f, .seed, .nsim, .resample,
                           .type = c("parametric", "residual", "case", "wild", "rep")) {
  set.seed(.seed)
  out <- lmeresampler::bootstrap(
    model = .model, .f = .f, 
    type = .type,
    B = .nsim,
    resample = .resample
  ) 
  return(out)
}


