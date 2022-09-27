# Function: Compute Euclidean distance of a vector from the origin
# Input:
#   - data: containing x, and y
#   - x:    x component of vector
#   - y:    y component of vector
# Output: vectorized euclidean distance 

euclidean_distance <- function(data, x, y) {
  df <- data %>% select({{ x }}, {{ y }})
  out <- sqrt((df[, 1]^2 + df[, 2]^2))
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
