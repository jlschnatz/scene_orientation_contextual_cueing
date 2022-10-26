if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}
source(here::here("R/functions/theme_scientific.R"))
pacman::p_load(
  here,      # easy directories
  tidyverse, # data manipulation
  ggtext,
  showtext,
  sysfonts
  )

showtext_auto()
font_add_google("Source Sans Pro", "ssp")
data_transform <- read_rds(here("data/model/data_transformation.rds"))
columns <- c("x", "x.t")
color_hex <- c("#E9996B", "#132083", "#9F5E9D")


range_act <- range(range(results$act), range(results$pred))

dummy <- data_normal %>% 
  group_by(name) %>% 
  summarise(value = range(value), .groups = "drop")



data_normal <- 
data_transform %>% 
  keep(names(.) %in% columns) %>% 
  enframe() %>% 
  mutate(name = c("transformed", "non-transformed")) %>% 
  unnest(value) 

data_normal %>% 
  ggplot(aes(sample = value, color = name)) +
  facet_grid(
    rows  = vars(name),
    scales = "free") +
  geom_qq_line(size = 1, linetype = 2) + 
  geom_qq(alpha = 0.3, size = 2) +  
  geom_blank(data = dummy) +
  guides(color = "none") +
  scale_color_manual(values = c("#E9996B", "#132083")) +
  scale_x_continuous(
    name = "Theoretical",
    limits = c(-4, 4),
    breaks = seq(-4, 4, 1),
    expand = c(0,0)
  ) +
  scale_y_continuous(
    name = "Sample",
    breaks = scales::pretty_breaks(n = ),
    expand = c(0, 0)
  ) +
  theme_scientific(base_family = "ssp") 

ggsave(
  filename = "results/figures/normalization_check.pdf",
  width = 5, height = 4)  
  

