library(tidyverse)
library(modelbased)
library(ggtext)

showtext::showtext_auto()
sysfonts::font_add_google("Source Sans Pro", "ssp")
color_hex <- c("#E9996B", "#132083", "#9F5E9D")
source(here("R/functions/theme_scientific.R"))

data_modelfit <- read_rds(here("data/model/data_modelfit.rds"))
data_mm <- data_modelfit %>% 
  chuck("full_model", 1) %>% 
  estimate_means(at = c("id_block", "id_orientation")) %>% 
  rename_with(.fn = tolower) 

figure_marginal_mean <- data_mm %>% 
  ggplot(aes(
    x = id_block,
    y = mean,
    color = id_orientation)) + 
  geom_point(
    position = position_dodge(0.6),
    size = 3.5
  ) +
  geom_linerange(
    aes(ymin = ci_low, ymax = ci_high),
    position = position_dodge(0.6),
    size = .8
    ) + 
  scale_color_manual(values = color_hex, name = NULL) +
  scale_y_continuous(
    name = "**EMM** (in sec.)",
    limits = c(0, 5),
    expand = c(0, 0),
    breaks = seq(0, 5)
  ) +
  scale_x_discrete(
    name = "Block",
    labels = c("(1) - Learning", "(2) - Testing")
  ) +
  theme_scientific(base_family = "ssp", base_size = 11) + 
  theme(
    axis.title.y = element_markdown(face = "plain", lineheight = 1.2),
    legend.position = c(0.5, 0.1),
    legend.direction = "horizontal")


print(figure_marginal_mean)
ggsave(
  plot = figure_marginal_mean,
  filename = "results/figures/marginal_means.pdf",
  width = 5,
  height = 4
  )
