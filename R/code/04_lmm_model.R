library(here)
library(tidyverse)
library(tidymodels)
library(broom.mixed)
library(lmerTest)
library(multilevelmod)
source(here("R/functions/helpers.R"))


composite_cleaned_data <- read_rds(here(
  "data/psychopy/processed",
  "composite_cleaned_data.rds"
)) 

model_data <- composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  select(contains("id"), rt, contrast, center_distance) 

lme_model_spec <- linear_reg() %>% 
  set_mode("regression") %>%
  set_engine("lmer")

formula_lme <- formula(
  # Dependent variable
  rt ~  
  # Fixed effects (Interaction between block and orientation)
   id_block*id_orientation + contrast + center_distance + 
  # Random effects (each random slope and intercept)
    (1 + id_block|id_participant) +
    (1 + id_block|id_scene)
  )

lme_results <-
lme_model_spec %>% 
  fit(formula_lme, data = model_data) 


broom.mixed::tidy(lme_results)


inference <- lmerTest::lmer(
  formula = formula_lme,
  data = model_data,
  REML = TRUE
  )

summary(inference)

lmerTest::rand(inference)
anova(inference)


hit_data <-
composite_cleaned_data %>% 
  select(contains("id"), hit, contrast, center_distance)  

glmer(
  formula = hit ~ id_block*id_orientation + 
    contrast + center_distance + 
    (1  | id_participant) + 
    (1 | id_scene), 
  data = hit_data,
  family = "binomial"
) %>% 
  summary()

  
