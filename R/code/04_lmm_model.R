if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}
source("R/functions/helpers.R")
pacman::p_load(
  here,          # easy directories
  tidyverse,     # data manipulation
  tidymodels,    # regression modelling
  lme4,          # lmm backend
  multilevelmod, # hierarchical models in tidymodels
  boot,          # bootstrapping parameters for inference
  bestNormalize, # dv normalization
  broom.mixed    # broom for mixed models
)

composite_cleaned_data <- read_rds(here(
  "data/psychopy/processed",
  "composite_cleaned_data.rds")
  ) 

# data normalization
set.seed(42)
best_norm <- composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  pull(rt) %>% 
  bestNormalize(
    x = .,
    standardize = FALSE,
    allow_orderNorm = FALSE,
    allow_lambert_s = FALSE,
    allow_lambert_h = FALSE,
    allow_exp = TRUE,
    k = 10,
    r = 5
  )
write_rds(best_norm, file = "data/model/data_transformation.rds", compress = "gz")


# LMM
rt_data <- composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  dplyr::select(contains("id"), rt) %>%
  bind_cols(rt_trans = best_norm$x.t) #%>% 
 # mutate(id_orientation = fct_relevel(id_orientation, "new", after = 3))

write_rds(rt_data, file = here("data/model/data_model_raw"))

# specify treatment contrasts
contrasts(rt_data$id_orientation) <- contr.treatment(n = 3, 
                                                     base = 1)
contrasts(rt_data$id_block) <- contr.treatment(n = 2, base = 1)


# specify model framework
lme_model_spec <- linear_reg() %>% 
  set_mode("regression") %>%
  set_engine("lmer") %>% 
  set_args(
    REML = F
  )

# specify formulas
formula_full <- formula(
  rt ~  id_block + id_orientation + id_block:id_orientation + 
  (1|id_participant) + (1|id_scene)
  )

formula_reduced <- formula(
  rt ~ 1 + (1|id_participant) + (1|id_scene)
)

# fit models
set.seed(42)
lme_results_full <- lme_model_spec %>% 
  fit(formula_full, data = rt_data) %>% 
  extract_fit_engine()
set.seed(42)
lme_results_reduced <- lme_model_spec %>% 
  fit(formula_reduced, data = rt_data) %>% 
  extract_fit_engine()


# combine all data into one dataframe
data_model_fit <- rt_data %>% 
  nest(data = everything()) %>% 
  mutate(normalization = list(best_norm)) %>% 
  mutate(
    full_model = list(lme_results_full),
    reduced_model = list(lme_results_reduced),
    ) %>% 
  mutate(
    full_glance = map(full_model, glance),
    full_tidy = map(full_model, tidy),
    full_augment = map(full_model, augment),
    reduced_glance = map(reduced_model, glance),
    reduced_tidy = map(reduced_model, tidy),
    reduced_augment = map(reduced_model, augment)
    ) %>% 
  mutate(anova_comparison = map2(
    .x = full_model, .y = reduced_model, 
    .f = ~anova(..1, ..2) %>% broom::tidy())
    ) %>% 
  mutate(
    boot_inference = map(.x = full_model, .f = ~boot_resamples(
      .f = fixef, 
      .type = "parametric",
      .model = .x, 
      .seed = 42,  
      .nsim = 5000,
      .refit = TRUE
      )),
    boot_tidy = map(boot_inference, ~confint(
      .x, level = 0.95, type = "perc"))
    ) 

# save 
write_rds(
  x = data_model_fit,
  file = "data/model/data_modelfit.rds",
  compress = "gz"
)
