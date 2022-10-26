if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,      # easy directories
  tidyverse, # data manipulation
  ggtext,    # advanced text features
  sysfonts,  # fonts library
  showtext,  # display font in figure
  scico      # colors
)

source(here("R/functions/theme_scientific.R"))
showtext::showtext_auto()
sysfonts::font_add_google("Source Sans Pro", "ssp")

composite_data <- 
here("data/psychopy/processed/composite_cleaned_data.rds") %>% 
  read_rds() 

composite_data %>% 
  filter(hit == 1) %>% 
  select(rt, contrast, center_distance) %>% 
  ggplot(aes(x = contrast, y = center_distance, color = rt) ) + 
  geom_point(alpha = .8, size = 3.5) +
  scale_color_scico(
    palette = "batlowK",
    name = "**RT** (log<sub>2</sub>)",
    trans = "log2", 
    breaks = c(1, 2, 4, 8, 16),
    limits = c(NA, 16)
    ) + 
  scale_x_continuous(
    name = "Contrast",
    limits = c(0, 1),
    breaks = seq(0, 1, .2),
    expand = c(0,0)
  ) +
  scale_y_continuous(
    name = "Center distance",
    limits = c(0, 1),
    breaks = seq(0, 1, .2),
    expand = c(0,0)
  ) +
  coord_equal(clip = "off") + 
  theme_scientific(base_family = "ssp") +
  theme(
    legend.position = c(0.5, 0.94),
    legend.direction = "horizontal",
    legend.title = element_markdown(vjust = .85, face = "plain")
  ) 

ggsave(here("results/figures/rt_centerdist_contrast.pdf"), width = 5, height = 5)



