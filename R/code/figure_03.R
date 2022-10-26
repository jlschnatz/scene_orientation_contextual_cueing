library(here)
library(tidyverse)
library(sysfonts)
library(showtext)
library(ungeviz)
library(ggnewscale)
library(colorspace)
library(ggtext)
source(here("R/functions/theme_scientific.R"))

showtext::showtext_auto()
sysfonts::font_add_google("Source Sans Pro", "ssp")
color_hex <- c("#E9996B", "#132083", "#9F5E9D")

composite_cleaned_data <- read_rds(here(
  "data/psychopy/processed",
  "composite_cleaned_data.rds"
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
  select(- c(n_within, sum_n)) %>% 
  filter(hit == 0) %>% 
  select(-hit) %>% 
  pivot_wider(names_from = id_block,
              values_from = hr_within,
              values_fill = 0,
              names_prefix = "within_block_") %>% 
  mutate(diff_within = within_block_1 - within_block_2) %>% 
  select(-c(within_block_1, within_block_2))

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
  filter(hit == 0)  %>% 
  select(- c(n_overall, sum_n, hit)) %>% 
  pivot_wider(names_from = id_block,
              values_from = hr_overall,
              names_prefix = "overall_block_") %>% 
  mutate(diff_overall = overall_block_1 - overall_block_2) %>% 
  select(-c(overall_block_2, overall_block_1))
 
data_hit <-  inner_join(
  within_participant_count, overall_count,
  by = c( "id_orientation")
  ) %>% 
  group_by(id_orientation) %>% 
  mutate(
    sd_hr = sd(diff_within),
    n = n(),
    se_hr = sd_hr / sqrt(n),
    lower = diff_overall - se_hr * qnorm(0.975),
    upper = diff_overall + se_hr * qnorm(0.975),
    lower = diff_overall - sd_hr,
    upper = diff_overall + sd_hr
  ) %>% 
  ungroup() %>% 
  mutate(id_orientation = str_to_sentence(id_orientation)) %>% 
  select(-c(sd_hr, n, se_hr))

set.seed(42)
figure_03 <- data_hit %>% 
  ggplot(aes(
    x = diff_overall, 
    y = id_orientation,
    color = id_orientation)
    ) +
  geom_vline(
    xintercept = 0, 
    size = .25,
    color = "black"
    ) + 
  geom_jitter(
    aes(x = diff_within),
    height = 0.3, 
    show.legend = F,    
    alpha = .7) + 
  geom_errorbarh(
    aes(xmin = lower, xmax = upper),
    height = 0
  ) + 
  scale_color_manual(values = color_hex) +
  guides(color = "none") + 
  new_scale_color() + 
  geom_point(aes(color = id_orientation), size = 3) + 
  scale_color_manual(values = darken(color_hex, amount = .4)) +
  scale_x_continuous(
    name = "**\U0394 MR**<br>(B1 - B2)",
    limits = c(-.5, .5),
    breaks = seq(-.5, .5, .1),
    expand = c(0, 0)
  ) + 
  coord_cartesian(clip = "off") + 
  guides(color = "none") + 
  theme_scientific(base_family = "ssp") + 
  theme(
    plot.margin = margin(t = 5, l = 10, r = 10),
    axis.line.y = element_blank(),
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.x = element_markdown(face = "plain", lineheight = 1.2)
  )

print(figure_03)


