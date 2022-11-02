library(ggnewscale)
library(broom.mixed)
library(tidyverse)
library(ggnewscale)
color_hex <- c("#E9996B", "#132083", "#9F5E9D")
lme_results_full <- read_rds("data/model/data_modelfit.rds") %>% 
  chuck("full_model", 1) 

table_marginal <- 
lme_results_full %>% 
  augment() %>%
  select(
    id_participant, id_scene,
    id_block, id_orientation, 
    .fixed, .mu) %>% 
  group_by(id_participant,  id_scene) %>% 
  arrange(id_participant, id_scene) %>% 
  mutate(paired = cur_group_id()) %>% 
  ungroup() %>% 
  select(-c(id_scene, id_participant))

table_marginal %>% 
  ggplot(aes(
    x = id_block, y = .mu, color = id_orientation)) + 
  facet_grid(cols = vars(id_orientation)) + 
  geom_path(
    aes(group = paired),
    alpha = 0.2,
    show.legend = F
  ) +
  geom_point(
    alpha = 0.3
  ) +
  scale_color_manual(values = color_hex) +
  new_scale_color() +
  geom_point(
    aes(y = .fixed, color = id_orientation),
    position = position_dodge(1),
    size = 3.5,
  ) +
  geom_line(
    aes(group = id_orientation, y = .fixed, color = id_orientation),
    position = position_dodge(1),
    size = 1.2,
    show.legend = F
    ) +
  scale_color_manual(values = colorspace::darken(color_hex, .4)) +
  scale_y_continuous(
    name = "Marginal effect on y",
    limits = c(0, 6),
    breaks = seq(0, 6),
    expand = c(0,0)
  ) +
  scale_x_discrete(
    name = "Block",
    breaks = c(1,2),
    labels = c("1 - Learning", "2 - Testing"),
    expand = c(.3,.3)
  ) +
  theme_scientific() + 
  theme(
    legend.position = c(0.5, 0.05),
    legend.direction = "horizontal",
    legend.title = element_blank(),
    strip.text.x  = element_blank()
  )

ggsave("test.pdf", width = 5, height = 5)

