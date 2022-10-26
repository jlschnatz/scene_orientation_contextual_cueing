library(here)
library(tidyverse)
library(ggdist)
library(gghalves)
library(sysfonts)
library(showtext)
library(colorspace)
library(ggnewscale)
library(ggtext)
source(here("R/functions/theme_scientific.R"))

showtext::showtext_auto()
sysfonts::font_add_google("Source Sans Pro", "ssp")
color_hex <- c("#E9996B", "#132083", "#9F5E9D")

composite_cleaned_data <- read_rds(here(
  "data/psychopy/processed",
  "composite_cleaned_data.rds"
)) 


data_diff <- 
composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  mutate(
    id_orientation = str_to_sentence(id_orientation),
    id_block = factor(id_block)
  ) %>% 
  dplyr::select(id_participant, id_block, id_orientation, rt) %>% 
  group_by(id_orientation, id_block) %>%
  mutate(
    mean_overall = mean(rt)) %>%
  group_by(
    id_participant, id_block, 
    id_orientation, mean_overall
    ) %>% 
  summarise(
    mean_within = mean(rt), 
    .groups = "drop"
    ) %>% 
  pivot_wider(
    names_from = id_block, 
    values_from = c(
      mean_within, mean_overall)
  ) %>% 
  mutate(
    diff_within = mean_within_2 - mean_within_1,
    diff_overall = mean_overall_2 - mean_overall_1) %>% 
  dplyr::select(starts_with("id"), starts_with("diff")) %>% 
  group_by(id_orientation) %>% 
  mutate(
    diff_sd = sd(diff_within),
    lower = diff_overall - diff_sd,
    upper = diff_overall + diff_sd
    ) %>% 
  dplyr::select(-diff_sd) %>% 
  ungroup()
  
set.seed(42)
figure_02 <- data_diff %>% 
  ggplot(aes(
    y = diff_within,
    x = id_orientation,
    color = id_orientation)) +
  geom_hline(
    yintercept = 0, 
    size = 0.25,
    ) + 
  geom_jitter(
    width = 0.1, 
    show.legend = F,    
    alpha = .7,
  ) + 
  scale_color_manual(values = color_hex) +
  geom_linerange(
    aes(ymin = lower, ymax = upper, color = id_orientation),
    show.legend = FALSE
  ) +
  new_scale_color() +
  geom_point(
    aes(y = diff_overall, color = id_orientation),
    size = 3.5,
    show.legend = F
    ) +
  scale_color_manual(values = darken(color_hex, amount = .4)) +
  scale_y_continuous(
    position = "left",
    name = "**\U0394 RT** (in sec.)<br>(B2 - B1)",
    breaks = seq(-5, 5, 1),
    limits = c(-5, 5),
    expand = c(0,0)
  ) +
  labs(x = NULL) + 
  coord_flip() + 
  guides(color = "none") + 
  theme_scientific(base_family = "ssp") +  
  theme(axis.title.x.bottom = element_text(face = "plain")) + 
  theme(
    axis.title.x.bottom = element_markdown(lineheight = 1.2),
    plot.margin  = margin(t = 20, r = 10, b = 0),
    axis.text.y = element_blank(),
    axis.line.y = element_blank(),
    axis.ticks.y = element_blank()
    ) 

print(figure_02)



