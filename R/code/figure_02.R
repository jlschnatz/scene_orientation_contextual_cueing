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


color_hex <- c("#AC4431", "#51949D", "#B7A1B5")

composite_cleaned_data <- read_csv(here(
  "data/psychopy/processed",
  "composite_cleaned_data.csv"
)) 

figure_02 <- composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  mutate(
    id_orientation = str_to_sentence(id_orientation),
    id_block = factor(id_block)
  ) %>% 
  select(id_participant, id_block, id_orientation, rt) %>% 
  group_by(id_participant, id_orientation, id_block) %>%
  summarise(mean_rt = mean(rt), .groups = "drop")  %>%
  pivot_wider(
    names_from = id_block, 
    values_from = mean_rt
  ) %>%
  rename(block_1_rt = `1`,
         block_2_rt = `2`) %>%
  mutate(blockwise_diff_rt = block_1_rt - block_2_rt) %>% 
  select(contains("id"), blockwise_diff_rt) %>% 
  group_by(id_orientation) %>% 
  mutate(
    diff_mean_rt = mean(blockwise_diff_rt),
    diff_sd_rt = sd(blockwise_diff_rt),
    upper = diff_mean_rt + diff_sd_rt,
    lower = diff_mean_rt - diff_sd_rt) %>% 
  ggplot(aes(
    y = blockwise_diff_rt,
    x = id_orientation,
    color = id_orientation)) +
  geom_hline(
    yintercept = 0, 
    size = 0.25,
    linetype = "longdash"
    ) + 
  geom_jitter(
    width = 0.1, 
    show.legend = F,    
    alpha = .7,
  ) + 
  scale_color_manual(values = color_hex) +
  new_scale_color() +
  geom_linerange(
    aes(ymin = lower, ymax = upper, color = id_orientation),
    show.legend = FALSE
  ) +
  geom_point(
    aes(y = diff_mean_rt, color = id_orientation),
    size = 3.5,
    show.legend = F
    ) +
  scale_color_manual(values = darken(color_hex, amount = .4)) +
  scale_y_continuous(
    name = "**\U0394 RT**  (in sec.) <br>(B1 - B2)",
    breaks = seq(-2, 4, 1),
    limits = c(-2, 4.5),
    expand = c(0,0)
  ) +
  labs(x = NULL) + 
  coord_flip() + 
  guides(color = "none") + 
  theme_scientific(base_family = "ssp") +  
  theme(axis.title.x = element_text(face = "plain")) + 
  theme(axis.title.x = element_markdown(lineheight = 1.2))

print(figure_02)

ggsave(
  plot = figure_02,
  filename = here("results/figures", "diff_by_orientation_block.pdf"),
  width = 7,
  height = 3.5,
  bg = "white",
)



