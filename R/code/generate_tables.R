if (!"pacman" %in% installed.packages()) {
  install.packages("pacman")
}

pacman::p_load(
  here,          # easy directories
  tidyverse,     # data manipulation
  lme4
)

data_modelfit <- read_rds(here::here("data/model/data_modelfit.rds"))


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
  "Term", "$\\hat{\\beta}$ / $\\sigma^{2}$",
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
  mutate(across(everything(), ~if_else(is.na(.x), "-", .x)))

write_rds(
  transform_table,
  here("data/table", "transform_table.rds")
)



# tables of the mixed regression model results (with contrast and center distance)

tidy_fit_fuller <- data_modelfit %>% 
  chuck("fuller_tidy", 1) %>% 
  select(-c(group, effect)) %>% 
  mutate(across(where(is.numeric), .fns = ~round(.x, 3)))  %>% 
  mutate(estimate = if_else(str_starts(term, "sd"), estimate^2, estimate))

tidy_boot_fuller <- data_modelfit %>% 
  chuck("boot_tidy_fuller", 1) %>% 
  select(-c(type, level, estimate)) %>% 
  mutate(across(where(is.numeric), ~round(.x, 3))) %>% 
  mutate(signif = if_else(lower*upper < 0, "n.s.", "$\\ast$"))

col_names_fit <- c(
  "Term", "$\\hat{\\beta}$ / $\\sigma^{2}$",
  "\\textit{SE}", "\\textit{t}", "95\\% CI", "Significance"
)

term_rows <- c(
  "Intercept $\\beta_{0}$",
  "Block $\\beta_{1}$",
  "Orient. $\\beta_{2}$",
  "Orient. $\\beta_{3}$",
  "Distance $\\beta_{4}$",
  "Contrast $\\beta_{5}$",
  "Int. $\\beta_{4}$",
  "Int. $\\beta_{5}$",
  "$\\sigma^{2}_{scene}$",
  "$\\sigma^{2}_{participant}$",
  "$\\sigma^{2}_{\\epsilon}$"
)

table_model_fuller <- left_join(tidy_fit_fuller, tidy_boot_fuller) %>% 
  mutate(across(everything(), as.character)) %>% 
  mutate(CI = str_c("[",lower, ", ", upper, "]")) %>% 
  select(-c(lower, upper)) %>% 
  relocate(signif, .after = everything()) %>% 
  rename_with(.fn = ~col_names_fit) %>% 
  mutate(Term = term_rows) %>% 
  mutate(across(everything(), ~if_else(is.na(.x) , "-", .x))) 

write_rds(
  table_model_fuller,
  here("data/table", "model_table_fuller.rds")
)


# anova comparison

library(tidyverse)
read_rds("data/model/data_modelfit.rds") %>% 
  select(full_model, fuller_model) %>% 
  map(~pluck(., 1)) %>% 
  set_names(nm = c("full_model", "fuller_model")) %>%
  iwalk(~ assign(..2, ..1, envir = .GlobalEnv))

anova_comp_rownames <- c(
  "$AIC$",
  "$BIC$",
  "L($\\theta$)",
  "Deviance",
  "$t$",
  "$df$",
  "$p$"
)

anova_comp_colnames <- c("Measures of fit", "(1)", "(2)")

table_anova_comparison <- anova(full_model, fuller_model, refit = T) %>% 
  broom::tidy() %>% 
  pivot_longer(cols = -term) %>% 
  pivot_wider(names_from = term, values_from = value) %>% 
  filter(!name == "npar") %>% 
  mutate(fuller_model = if_else(name == "p.value", "< .001", as.character(round(fuller_model, 3)))) %>% 
  mutate(full_model = as.character(round(full_model, 3))) %>% 
  mutate(name = anova_comp_rownames) %>% 
  mutate(full_model = if_else(is.na(full_model), "-", full_model)) %>% 
  rename_with(~anova_comp_colnames)
  
write_rds(
  table_anova_comparison,
  here("data/table/anova_table.rds")
  )



