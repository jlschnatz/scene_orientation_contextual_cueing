if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

source("R/functions/theme_scientific.R")
pacman::p_load(
  here,          # easy directories
  tidyverse,     # data manipulation
  ggridges,      # ridgeline plots
  ggtext,
  sysfonts,
  showtext
)
sysfonts::font_add_google("Source Sans Pro", "ssp")
showtext::showtext_auto()
showtext::showtext_opts(dpi = 500)

data_modelfit <- read_rds(here("data/model/data_modelfit.rds"))


# reduced model 
boot_raw_reduced <- data_modelfit %>% 
  chuck("boot_inference", 1 , "replicates") %>% 
  pivot_longer(cols = everything(), names_to = "term",
               values_to = "boot_value")


boot_conf_reduced <- data_modelfit %>% 
  chuck("boot_tidy", 1)

# generate labels for both models:
fct_level_reduced <- boot_conf_reduced$term
fct_label_reduced <- c(
  "<b>\U03B2<sub><i>0</i></b>",
  "\U03B2<sub><i>block</i>",
  "\U03B2<sub><i>orient. new</i>",
  "\U03B2<sub><i>orient. orig.</i>",
  "\U03B2<sub><i>block : orient. new</i>",
  "\U03B2<sub><i>block : orient. orig.</i>"
)

boot_combined_reduced <- inner_join(boot_raw_reduced, boot_conf_reduced, by = "term") %>% 
  mutate(term = factor(
    x = term, 
    levels = fct_level_reduced, 
    labels = fct_label_reduced)
  )

boot_figure <- 
  boot_combined_reduced  %>% 
  ggplot(aes(x = boot_value, y = term)) + 
  geom_vline(
    xintercept = 0, 
    size = 0.25, 
    ) + 
  geom_density_ridges(
    scale = 0.6,
    rel_min_height = 0.035,
    show.legend = FALSE,
    color = NA,
   # bandwidth = 0.01,
    position = position_nudge(y = 0.1),
    fill = "#132083",
    alpha = .85
  ) + 
  geom_errorbarh(
    aes(xmin = lower, xmax = upper), 
    show.legend = FALSE,
    height = 0,
    size = 0.8,
    color = "grey20"
  ) +
  geom_point(
    aes(x = estimate),
    show.legend = F, 
    size = 2,
    color = "grey20"
    ) + 
  scale_x_continuous(
    name = "Bootstrapped fixed-effect \ncoefficients",
    limits = c(-5, 5),
    breaks = seq(-5, 5, 1),
    expand = c(0,0)
  ) + 
  scale_y_discrete(
    name = NULL,
    expand = c(0.03, 0)
  ) + 
  theme_scientific(base_family = "ssp", base_size = 9) + 
  theme(
    axis.text.y = element_markdown(),
    axis.title.x = element_text(size = 10)
  )

ggsave(
  plot = boot_figure,
  filename = here::here("results/figures/bootstrapped_weights.pdf"),
  width = 5,
  height = 4,
  dpi = 500,
)
