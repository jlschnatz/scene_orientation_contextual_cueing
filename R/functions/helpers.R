euclidean_distance <- function(data, x, y) {
  df <- data %>% select({{ x }}, {{ y }})
  out <- sqrt((df[, 1]^2 + df[, 2]^2))
  return(out)
}
