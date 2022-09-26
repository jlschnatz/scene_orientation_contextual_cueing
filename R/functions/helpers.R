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
