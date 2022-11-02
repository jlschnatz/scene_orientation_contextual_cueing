if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,          # easy directories
  tidyverse,     # data manipulation
  lme4
)

data_modelfit <- read_rds(here::here("data/model/data_modelfit.rds"))
model_exploratory_fit <- read_rds(here("data/model/data_exploratory_modelfit.rds"))

# tables of the mixed regression model results

tidy_fit <- data_modelfit %>% 
  chuck("full_tidy", 1) %>% 
  select(-c(group, effect)) %>% 
  mutate(estimate = if_else(str_starts(term, "sd"), estimate^2, estimate))  %>% 
  mutate(across(where(is.numeric), .fns = ~round(.x, 3))) 
  

tidy_boot <- data_modelfit %>% 
  chuck("boot_tidy", 1) %>% 
  select(-c(type, level, estimate)) %>% 
  mutate(across(where(is.numeric), ~round(.x, 3))) %>% 
  mutate(signif = if_else(lower*upper < 0, "n.s.", "$\\ast$"))

col_names_fit <- c(
  "Term", "Estimate",
  "\\textit{SE}", "\\textit{t}", "95\\% CI", "Significance"
)

term_rows <- c(
  "Intercept $\\beta_{0}$",
  "Block $\\beta_{1}$",
  "Orient. $\\beta_{2}$",
  "Orient. $\\beta_{3}$",
  "Int. $\\beta_{4}$",
  "Int. $\\beta_{5}$",
  "$\\sigma^{2}_{scene}$",
  "$\\sigma^{2}_{participant}$",
  "$\\sigma^{2}_{\\epsilon}$"
)

table_model <- left_join(tidy_fit, tidy_boot) %>% 
  mutate(across(everything(), as.character)) %>% 
  mutate(CI = str_c("[",lower, ", ", upper, "]")) %>% 
  select(-c(lower, upper)) %>% 
  relocate(signif, .after = everything()) %>% 
  rename_with(.fn = ~col_names_fit) %>% 
  mutate(Term = term_rows) %>% 
  mutate(across(everything(), ~if_else(is.na(.x) , "-", .x))) 

write_rds(
  table_model,
  here("data/table", "model_table.rds")
)

# table of descriptive results
composite_cleaned_data <- read_rds(
  here("data/psychopy/processed/composite_cleaned_data.rds")
) 

# count hits vs. misses by id_orientation
hr_group_data <- composite_cleaned_data %>% 
  group_by(id_orientation, id_block) %>% 
  mutate(n_orientation = n()) %>% 
  group_by(id_orientation, id_block, hit) %>% 
  summarise(
    n_abs = n(),
    n_rel = n()/n_orientation,
    .groups = "drop"
  ) %>% 
  distinct() %>% 
  filter(hit == 1) %>% 
  select(-hit)


rt_group_data <- composite_cleaned_data %>% 
  filter(hit == 1) %>% 
  group_by(id_block, id_orientation) %>% 
  summarise(
    mean_rt = mean(rt),
    sd_rt = sd(rt),
    .groups = "drop"
  )

descriptives_table <- inner_join(rt_group_data, hr_group_data) %>% 
  mutate(across(where(is.numeric), ~round(.x, 2))) %>%
  mutate(mean_sd = str_c(mean_rt, " (", sd_rt, ")")) %>% 
  mutate(id_orientation = fct_relevel(id_orientation, "new", after = Inf),
         id_orientation = fct_relevel(id_orientation, "mirrored", after = 1)) %>% 
  mutate(id_orientation = fct_relabel(id_orientation, str_to_sentence)) %>% 
  select(-c(mean_rt, sd_rt)) %>% 
  pivot_wider(names_from = c(id_block),
              values_from = c(mean_sd, n_abs, n_rel),
              names_vary = "slowest") %>% 
  rename_with(~c("Orientation",
                 "$M$ ($SD$)", "$n$", "Hit rate", 
                 "$M$  ($SD$) ", "$n$ ", "Hit rate ")
  ) %>% 
  arrange(Orientation)

write_rds(
  descriptives_table,
  here("data/table", "descriptives_table.rds")
)

# Transformation data:

data_transform <- read_rds(here::here("data/model/data_transformation.rds"))
vars <- c("mean", "sd", "lambda")

chosen_transformation <- data_transform %>% 
  chuck("chosen_transform") %>% 
  .[vars] %>% 
  as_tibble() %>% 
  mutate(transformation = "boxcox", .before = everything())

transform_desriptives <- data_transform %>% 
  pluck("other_transforms") %>% 
  map(.x = .,~.[vars]) %>% 
  enframe(name = "transformation") %>% 
  unnest_longer(everything(.)) %>% 
  drop_na() %>% 
  pivot_wider(names_from = value_id, values_from = value) 
 
transform_stats <- data_transform %>% 
  pluck("norm_stats") %>% 
  as_tibble(rownames = "transformation") %>% 
  rename(norm_stat = value)

col_names <- c(
  "Transformation",
  "$M$ ($SD$)",
  "$\\lambda$",
  "$\\chi^2$ / $df$"
)

transform_table <- full_join(transform_desriptives, chosen_transformation) %>% 
inner_join(., transform_stats) %>% 
  arrange(norm_stat) %>% 
  mutate(across(where(is.numeric), ~round(.x, 2))) %>% 
  mutate(across(
    where(is.numeric),
    ~if_else(.x > 1000, format(.x, scientific = TRUE), as.character(.x))
    )) %>%
  mutate(M_SD = str_c(mean," (", sd, ")"), .after = transformation) %>% 
  select(-c(mean, sd)) %>% 
  mutate(transformation = c(
    "Box-Cox",
    "Yeo-Johnson",
    "$log_{10}(x)$",
    "$arcsinh(x)$",
    "$\\sqrt{x}$",
    "no transformation",
    "$e^x$"
  )) %>% 
  rename_with(~col_names) %>% 
  mutate(across(everything(), ~if_else(is.na(.x), "-", .x))) %>% 
  filter(Transformation != "$e^x$")

write_rds(
  transform_table,
  here("data/table", "transform_table.rds")
)



# table of exploratory analysis of predictors contrast and center distance
# glmer
exploratory_summary_glmer <- model_exploratory_fit %>% 
  chuck("tidy_fit_glmer", 1) %>% 
  select(-c(group, effect)) %>% 
  mutate(estimate = if_else(str_starts(term, "sd"), estimate^2, estimate))  %>% 
  mutate(across(estimate:statistic, .fns = ~round(.x, 3))) %>% 
  select(-p.value)

exploratory_boot_glmer <- model_exploratory_fit %>% 
  chuck("boot_tidy_glmer", 1) %>% 
  select(-c(type, level, estimate)) %>% 
  mutate(across(where(is.numeric), ~round(.x, 3))) %>% 
  mutate(signif = if_else(lower*upper < 0, "n.s.", "$\\ast$"))

col_names_exploratory <- c(
  "Term", "$\\hat{\\beta}$ / $\\sigma^{2}$",
  "\\textit{SE}", "\\textit{t}", "95\\% CI", "Significance"
)

term_exploratory_rows_glmer <- c(
  "$\\beta_{0}$",
  "$\\beta_{distance}$",
  "$\\beta_{contrast}$",
  "$\\sigma^{2}_{subj.}$"
)

table_model_exploratory_glmer <- left_join(
  exploratory_summary_glmer, 
  exploratory_boot_glmer
  ) %>% 
  mutate(across(everything(), as.character)) %>% 
  mutate(CI = str_c("[",lower, ", ", upper, "]")) %>% 
  select(-c(lower, upper)) %>% 
  relocate(signif, .after = everything()) %>% 
  rename_with(.fn = ~col_names_exploratory) %>% 
  mutate(Term = term_exploratory_rows_glmer) %>% 
  mutate(across(everything(), ~if_else(is.na(.x) , "-", .x))) %>% 
  mutate(model = "glmer", .before = everything())


#lmer 

exploratory_summary_lmer <- model_exploratory_fit %>% 
  chuck("tidy_fit_lmer", 1) %>% 
  select(-c(group, effect)) %>% 
  mutate(estimate = if_else(str_starts(term, "sd"), estimate^2, estimate))  %>% 
  mutate(across(estimate:statistic, .fns = ~round(.x, 3))) 

exploratory_boot_lmer <- model_exploratory_fit %>% 
  chuck("boot_tidy_lmer", 1) %>% 
  select(-c(type, level, estimate)) %>% 
  mutate(across(where(is.numeric), ~round(.x, 3))) %>% 
  mutate(signif = if_else(lower*upper < 0, "n.s.", "$\\ast$"))

col_names_exploratory <- c(
  "Term", "$\\hat{\\beta}$ / $\\sigma^{2}$",
  "\\textit{SE}", "\\textit{t}", "95\\% CI", "Significance"
)

term_exploratory_rows_lmer <- c(
  "$\\beta_{0}$",
  "$\\beta_{distance}$",
  "$\\beta_{contrast}$",
  "$\\sigma^{2}_{subj.}$",
  "$\\sigma^{2}_{\\epsilon}$"
)

table_model_exploratory_lmer <- left_join(
  exploratory_summary_lmer, 
  exploratory_boot_lmer
) %>% 
  mutate(across(everything(), as.character)) %>% 
  mutate(CI = str_c("[",lower, ", ", upper, "]")) %>% 
  select(-c(lower, upper)) %>% 
  relocate(signif, .after = everything()) %>% 
  rename_with(.fn = ~col_names_exploratory) %>% 
  mutate(Term = term_exploratory_rows_lmer) %>% 
  mutate(across(everything(), ~if_else(is.na(.x) , "-", .x))) %>% 
  mutate(model = "lmer", .before = everything())


table_model_exploratory_combined <-
full_join(table_model_exploratory_glmer, table_model_exploratory_lmer) %>% 
  pivot_wider(names_from = model,
              values_from = -c(model, Term),
              names_vary = "slowest") %>% 
  rename_with(~c(
    "Term",
    "Estimate",
    "$SE$",
    "$z$",
    "$CI$",
    "Signif.",
    "Estimate ",
    "$SE$ ",
    "$t$ ",
    "$CI$ ",
    "Signif. "
  )) %>% 
  mutate(across(everything(), ~if_else(is.na(.x) , "-", .x))) 


write_rds(
  table_model_exploratory_combined,
  here("data/table", "model_table_exploratory.rds")
)





