library(here)
library(tidyverse)
library(sysfonts)
library(showtext)
library(ungeviz)
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

within_participant_count <- composite_cleaned_data %>% 
  select(
    id_participant, id_block, 
    id_orientation, hit
    ) %>% 
  group_by(
    id_participant, id_block,
    id_orientation, hit
    ) %>% 
  summarise(
    n_within = n(),
    .groups = "drop"
    ) %>% 
  group_by(id_participant, id_block, id_orientation) %>% 
  mutate(
    sum_n = sum(n_within),
    hr_within = n_within / sum_n
    ) %>% 
  ungroup() %>% 
  select(- c(n_within, sum_n))

overall_count <- composite_cleaned_data %>% 
  select(
    id_participant, id_block, 
    id_orientation, hit
  ) %>% 
  group_by(id_block, id_orientation, hit) %>% 
  summarise(
    n_overall = n(), 
    .groups = "drop"
    ) %>% 
  group_by(id_block, id_orientation) %>% 
  mutate(
    sum_n = sum(n_overall),
    hr_overall = n_overall / sum_n
  ) %>% 
  ungroup() %>% 
  select(- c(n_overall, sum_n))

inner_join(
  within_participant_count, overall_count,
  by = c("id_block", "id_orientation", "hit")
  ) %>% 
  filter(hit == 1) %>% 
  select(-hit) %>% 
  group_by(id_block, id_orientation) %>% 
  mutate(
    se_hr = sd(hr_within)/sqrt(n()),
    lower = hr_overall - se_hr * qnorm(0.975),
    upper = hr_overall + se_hr * qnorm(0.975),
  ) %>% 
  mutate(
    id_orientation = str_to_sentence(id_orientation),
    id_block = factor(id_block)
  ) %>% 
  ggplot(aes(
    x = id_block, 
    y = hr_overall,
    color = id_orientation)) + 
  geom_point(
    size = 3,
    position = position_dodge(width = .6)
    ) +
  geom_linerange(
    aes(ymin = lower, ymax = upper),
    position = position_dodge(width = .6),
    show.legend = F
    ) +
  scale_color_manual(
    name = NULL,
    values = darken(color_hex, amount = .1)
    ) + 
  scale_x_discrete(
    name = "Block",
    breaks = c(1,2),
    labels = c("(1) - Training", "(2) - Testing"),
    expand = c(.3,.3)
  ) +
  scale_y_continuous(
    name = "Hit Rate",
    breaks = seq(0, 1, 0.2),
    limits = c(0, 1),
    expand = c(0,0)
  ) + 
  guides(color = guide_legend(
    override.aes = list(size = 5),
  )) + 
  theme_scientific() + 
  theme(
    legend.position = c(0.5, 0.05),
    legend.direction = "horizontal"
  )

ggsave(
  here("results/figures/hr_by_orientation_block.pdf"),
  width = 4,
  height = 6
)

