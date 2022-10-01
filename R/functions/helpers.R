# Function: Compute Euclidean distance of a vector from the origin
# Input:
#   - data: containing x, and y
#   - x:    x component of vector
#   - y:    y component of vector
# Output: vectorized euclidean distance 

euclidean_distance <- function(data, x1, y1, x2 = 0, y2 = 0) {
  df <- data %>% dplyr::select({{ x1}}, {{ y1 }}, {{ x2 }}, {{ y2 }})
  out <- df %>% 
    dplyr::summarise(
      sqrt(({{ x1 }} - {{ x2 }})^2 + ({{ y1 }} - {{ y2}})^2 )
      ) %>% 
    pull()
  return(out)
}

# Function: normalize set of values between a given interval
# Input:
#   - x:      vector containing the set of values
#   - lower:  lower bound of interval
#   - upper:  upper bound of interval
# Output: returns vector of normalized values between the given interval bounds

normalize_iv <- function(x, lower, upper) {
  out <- (upper - lower) * (x - min(x))/(max(x) - min(x)) + lower
  return(out)
}

# Function: find outliers of distribution of reaction times
# Details:  outliers are detected via given
#           standard deviations from a subject's mean score
# Input:
#   - data:    the data containing the reaction time variable
#   - rt:      the reaction time variable
#   - sd_crit: critical standard deviations, values higher will be excluded
#   - ...:     possible grouping variables
# Output: data frame with two new columns: 
#   - the z-transformed reaction time variable
#   - binary is_outlier variable indicating if rt is an outlier (0: no, 1: yes)

find_outliers <- function(data, rt, sd_crit, ...) {
  var_name <- glue::glue("{rt}_scaled")
  out <- data %>% 
    dplyr::group_by(...) %>% 
    dplyr::mutate(
      !!var_name := as.vector(scale(rt, center = T, scale = T)),
      is_outlier = dplyr::case_when(
        abs(!!sym(var_name)) > sd_crit ~ 1, TRUE ~ 0
        )
      ) %>% 
    ungroup()
  return(out)
}

pivot_longer_image <- function(filepath) {
  img <- raster::stack(filepath)
  out <- matrix(raster::raster(img, 1), 
                nrow = 2848, ncol = 4272) %>% 
    as.data.frame.table(., responseName = "value") %>%
    as_tibble() %>% 
    mutate(across(where(is.factor), as.integer)) %>% 
    rename(x_pos_img = Var2, y_pos_img = Var1,) %>% 
    mutate(
      x_pos_img = normalize_iv(x_pos_img, -.8, .8),
      y_pos_img = normalize_iv(y_pos_img, -.5, .5),
    ) %>% 
    relocate(x_pos_img, .before = everything())
  return(out)
}

nearest_neighbour_search <- function(df_img, df_stim) {
  data <- df_img %>% 
    dplyr::select(contains("pos"))
  query <- df_stim %>% 
    dplyr::select(contains("pos"))
  
  nn_results <- RANN::nn2(
    data = data, query = query, 
    k = 1, searchtype = "standard"
  )
  
  out <- tibble(
    index = as.vector(nn_results$nn.idx), 
    dist = as.vector(nn_results$nn.dists)
  )
  return(out)
}
