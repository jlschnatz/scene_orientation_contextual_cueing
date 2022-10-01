library(here)
library(tidyverse)
library(ggdist)
library(gghalves)
library(sysfonts)
library(showtext)
library(ggnewscale)
library(colorspace)
library(ggtext)
showtext::showtext_auto()
sysfonts::font_add_google("Source Sans Pro", "ssp")
source(here("R/functions/theme_scientific.R"))

#AC4431
#EBA53E
#51949D
#B7A1B5

color_hex <- c("#AC4431", "#51949D", "#B7A1B5")

composite_cleaned_data <- read_csv(here(
  "data/psychopy/processed",
  "composite_cleaned_data.csv"
  )) 

set.seed(42)
figure_01 <-composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  mutate(
    id_orientation = str_to_sentence(id_orientation),
    id_block = factor(id_block)
    ) %>% 
  select(contains("id"), rt) %>% 
  group_by(id_block, id_orientation) %>% 
  mutate(
    mean_rt = mean(rt),
    sd_rt = sd(rt),
    upper = mean_rt + sd_rt,
    lower = mean_rt - sd_rt
    ) %>% 
  ggplot(aes(
    y = rt, 
    x = id_block, 
    fill = id_orientation,
    color = id_orientation
    )) +
  stat_slab(
    side = "right",
    color = NA,
    position = position_dodge(width = .8),
    alpha = .7,
    trim = TRUE,
    scale = 0.5,
    show.legend = FALSE
  ) +
  geom_half_point(
    side = "left", 
    aes(fill = id_orientation),
    range_scale = .4, 
    alpha = .4,
    shape = 19,
    position = position_dodge(width = .8),
  ) + 
  scale_fill_manual(values = color_hex) + 
  scale_color_manual(values = color_hex) + 
  new_scale_color() +
  geom_linerange(
    aes(ymin = lower, ymax = upper, color = id_orientation),
    position = position_dodge(width = .8),
    show.legend = FALSE
  ) +
  geom_point(
    aes(y = mean_rt, color = id_orientation),
    position = position_dodge(width = .8),
    size = 3.5,
    show.legend = FALSE
  ) + 
  scale_color_manual(values = darken(color_hex, amount = .4)) + 
  scale_x_discrete(
    name = "Block",
    breaks = c(1,2),
    labels = c("(1) - Training", "(2) - Testing"),
    expand = c(.3,.3)
  ) +
  scale_y_continuous(
    name = "**RT** (in sec.)",
    breaks = seq(0, 16, 2),
    limits = c(0, 16),
    expand = c(0,0)
  ) +
  guides(color = guide_legend(
    override.aes = list(size = 5, alpha = 1),
    )) + 
  theme_scientific(base_family = "ssp") +
  theme(
    legend.title = element_blank(),
    axis.title.y = element_text(face = "plain"),
    legend.direction = "horizontal",
    legend.position = c(.5, .97),
  ) + 
  theme(axis.title.y = element_markdown(),
        plot.margin  = margin(t = 20))

print(figure_01)

ggsave(
  plot = figure_01,
  filename = here("results/figures", "rt_by_orientation_block.pdf"),
  width = 7,
  height = 5,
  bg = "white",
  )


