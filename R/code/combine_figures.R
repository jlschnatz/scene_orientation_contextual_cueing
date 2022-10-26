library(cowplot)
library(here)
source(here("R/code/figure_01.R"))
source(here("R/code/figure_02.R"))

plot_grid(
  figure_01,
  figure_02,
  labels = c("A", "B"),
  rel_heights = c(6, 2),
  nrow = 2,
  align = "v",
  axis = "l"
  )

ggsave(
  filename = here("results/figures", "combined_rt_diff.pdf"),
  width = 7,
  height = 8,
  bg = "white",
)

