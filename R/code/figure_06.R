library(tidyverse)
library(latex2exp)
library(here)
library(ggtext)
library(scales)
library(sysfonts)
library(showtext)
library(ggforce)
showtext::showtext_auto()
sysfonts::font_add_google("Source Sans Pro", "ssp")

data_transform <- read_rds(here("data/model/data_transformation.rds"))

label_x <- c(
  TeX("$\\textbf{Box-Cox}$"),
  "Yeo-Johnson",
  TeX("$\\log_{10}(x)$"),
  TeX("arcsinh(x)"),
  TeX("$\\sqrt{x}$"),
  "no transformation",
  TeX("$e^{x}$")
)

set.seed(42)
data_transform$oos_preds %>%
  as_tibble() %>%
  pivot_longer(everything()) %>%
  mutate(name = factor(name)) %>%
  mutate(name = fct_reorder(name, value)) %>%
  ggplot(aes(x = name, y = value)) +
  geom_jitter(
    width = 0.12,
    alpha = 0.25,
    color = "#132083"
  ) +
  geom_boxplot(
    width = 0.5,
    size = 0.6,
    color = "#132083",
    fill = "grey90",
    alpha = 0.5
  ) +
  scale_y_continuous(
    trans = log2_trans(),
    breaks = trans_breaks("log2", function(x) 2^x, n = 8),
    labels = trans_format("log2", math_format(2^.x)),
    limits = c(NA, 2^6.8)
  ) +
  scale_x_discrete(
    name = "Transformation",
    labels = label_x,
    position = "bottom",
  ) +
  ylab("**\U03C7<sup>2</sup> / df** <br> log<sub>2") +
  coord_cartesian(clip = "off") +
  annotation_logticks(
    base = 10,
    sides = "l",
    outside = FALSE,
    scaled = TRUE,
    size = 0.25
  ) + 
  theme_scientific(base_family = "ssp") +
  theme(axis.title.y = element_markdown(
    face = "plain", lineheight = 1.2
  ))

ggsave(
  filename = "results/figures/rt_transformation.pdf",
  width = 7, height = 5
)
