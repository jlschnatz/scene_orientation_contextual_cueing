library(here)
library(tidyr)
library(tidyverse)
library(lme4)
library(broom.mixed)
source(here("R/functions/helpers.R"))

composite_data <- read_rds(here("data/psychopy/processed/composite_cleaned_data.rds"))
contrast_data <- read_rds(here("data/psychopy/processed/contrast_data.rds"))
transform_data <- read_rds(here("data/model/data_model_raw"))

data_exploratory <- composite_data %>%
  left_join(contrast_data) %>%
  left_join(transform_data) %>%
  select(rt, hit, id_participant, id_scene, contrast, center_distance) %>%
  mutate(across(contrast:center_distance, ~ as.vector(scale(.x, center = T, scale = T))))

formula_glmer <- formula(hit ~ center_distance+contrast + (1 | id_participant))
formula_lmer <- formula(rt ~ center_distance+contrast + (1 | id_participant))

tictoc::tic()
set.seed(42)
model_exploratory_fit <- data_exploratory %>%
  nest(data = everything()) %>%
  mutate(data_glmer = map(data, ~select(.x, -rt))) %>% 
  mutate(data_lmer = map(data, ~ filter(.x, hit == 1))) %>%
  mutate(fit_glmer = map(
    .x = data_glmer,
    .f = ~ glmer(
      formula = formula_glmer,
      family = binomial(link = "logit"),
      data = .
    )
  )) %>%
  mutate(fit_lmer = map(
    .x = data_lmer,
    .f = ~ lmer(
      formula = formula_lmer,
      data = .,
      REML = FALSE
    )
  )) %>%
  mutate(across(
    fit_glmer:fit_lmer,
    .fns = ~ map(.x, tidy),
    .names = "tidy_{col}"
  )) %>%
  mutate(across(
    fit_glmer:fit_lmer,
    .fns = ~ map(.x, glance),
    .names = "glance_{col}"
  )) %>%
  mutate(boot_inf_lmer = map(
    .x = fit_lmer,
    .f = ~ boot_resamples(
      .model = .x,
      .f = fixef,
      .type = "parametric",
      .seed = 42,
      .nsim = 5000,
      .refit = TRUE
    )
  )) %>%
  mutate(boot_inf_glmer = map(
    .x = fit_glmer,
    .f = ~ boot_resamples(
      .model = .x,
      .f = fixef,
      .type = "parametric",
      .seed = 42,
      .nsim = 5000,
      .refit = TRUE
    )
  )) %>%
  mutate(
    boot_tidy_lmer = map(boot_inf_lmer, ~ confint(
      .x,
      level = 0.95, type = "perc"
    )),
    boot_tidy_glmer = map(boot_inf_glmer, ~ confint(
      .x,
      level = 0.95, type = "perc"
    ))
  )
tictoc::toc()

write_rds(
  x = model_exploratory_fit,
  file = here("data/model/data_exploratory_modelfit.rds")
)



