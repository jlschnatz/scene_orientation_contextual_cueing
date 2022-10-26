source("R/functions/theme_scientific.R")

lme_results_full %>% 
  augment() %>% 
  ggplot(aes(x = .resid)) +
  ggridges::geom_density_line(
    fill = "#132083",
    color = NA,
    alpha = 0.8
  ) + 
  scale_x_continuous(
    name = "Error",
    limits = c(-.75, .75),
    breaks = seq(-1, 1, 0.25),
    expand = c(0,0)
  ) +
  scale_y_continuous(
    name = "Density",
    limits = c(0, 2.5),
    breaks = seq(0, 3 , 0.5),
    expand = c(0,0)
  ) + 
  theme_scientific()



ranef(lme_results_full)$`id_scene:id_participant` %>% 
  as_tibble() %>% 
  ggplot(aes(x =  `(Intercept)`)) + 
  ggridges::geom_density_line(
    fill = "#132083",
    color = NA,
    alpha = 0.8
  ) + 
  scale_x_continuous(
    name = "Random Intercepts",
    limits = c(-1, 1),
    breaks = seq(-1, 1, 0.5),
    expand = c(0,0)
  ) +
  scale_y_continuous(
    name = "Density",
    limits = c(0, 1.5),
    breaks = seq(0, 1.5 , 0.5),
    expand = c(0,0)
  ) + 
  theme_scientific()


lme_results_full %>% 
  augment() %>% 
  ggplot(aes(x = .fitted, y = rt)) +
  geom_smooth(method = "lm", se = FALSE, color = "black",
              formula = y~ x) +
  geom_point(
    color = "#132083",
    alpha = 0.8
  ) +
  scale_x_c
  scale_x_continuous(
    name = "Predicted",
    limits = c(-0.5, 1.5),
    breaks = seq(-.5, 1.5, 0.5),
    expand = c(0,0)
  ) +
  scale_y_continuous(
    name = "Actual",
    limits = c(-0.5, 2),
    breaks = seq(-0.5, 2, 0.5),
    expand = c(0,0)
  ) +
  coord_cartesian(clip = "off") +
  theme_scientific()
  


lme_results_full %>% 
  augment() %>% 
  ggplot(aes(x = .fitted, y = .resid)) + 
  geom_point()



