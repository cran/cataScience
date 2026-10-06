## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", message = FALSE,
                     warning = FALSE, fig.width = 7.2, fig.height = 4.5)

## ----setup--------------------------------------------------------------------
library(cataScience)
library(readxl)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(DSIR)

## ----import-data--------------------------------------------------------------
example_file <- system.file(
  "app", "data", "cat-dirty-data.xlsx", package = "cataScience"
)
cat_data <- read_excel(example_file)
head(cat_data)

## ----missing-summary----------------------------------------------------------
missing_summary <- tibble(
  variable = names(cat_data),
  n_missing = vapply(cat_data, function(x) sum(is.na(x)), integer(1))
)
missing_summary

## ----duplicate-ids------------------------------------------------------------
duplicate_ids <- cat_data |>
  count(id, name = "n_rows") |>
  filter(n_rows > 1)
duplicate_ids

## ----compare-missing-methods--------------------------------------------------
complete_weights <- cat_data |>
  filter(!is.na(weight_kg))

median_filled <- cat_data |>
  mutate(weight_kg = replace_na(weight_kg, median(weight_kg, na.rm = TRUE)))

comparison_data <- bind_rows(
  "Observed weights" = complete_weights,
  "Median replacement" = median_filled,
  .id = "method"
)

method_summary <- comparison_data |>
  summarise(
    n_cats = n(),
    mean_weight_kg = mean(weight_kg),
    median_weight_kg = median(weight_kg),
    .by = method
  )
method_summary

## ----weight-outliers----------------------------------------------------------
weight_quartiles <- quantile(cat_data$weight_kg, c(0.25, 0.75), na.rm = TRUE)
weight_iqr <- diff(weight_quartiles)
lower_fence <- unname(weight_quartiles[1] - 1.5 * weight_iqr)
upper_fence <- unname(weight_quartiles[2] + 1.5 * weight_iqr)

flagged_weights <- cat_data |>
  filter(!is.na(weight_kg), weight_kg < lower_fence | weight_kg > upper_fence)
flagged_weights |>
  select(id, name, weight_kg)

## ----text-labels--------------------------------------------------------------
sort(unique(cat_data$gender))

standardized_data <- cat_data |>
  mutate(
    gender_key = str_to_lower(str_trim(gender)),
    gender = case_when(
      gender_key %in% c("f", "female") ~ "Female",
      gender_key %in% c("m", "male") ~ "Male",
      TRUE ~ gender
    )
  ) |>
  select(-gender_key)

standardized_data |>
  count(gender, sort = TRUE)

## ----comparison-plot, fig.alt="Boxplots of observed cat weights and weights after median replacement, with individual values shown."----
ggplot(comparison_data, aes(x = method, y = weight_kg, fill = method)) +
  geom_boxplot(width = 0.45, outlier.shape = NA, alpha = 0.6) +
  geom_jitter(width = 0.08, height = 0, alpha = 0.5, size = 1.5) +
  scale_fill_brewer(palette = "Set2", guide = "none") +
  theme_dsi() +
  labs(
    title = "A cleaning choice changes the data we see",
    subtitle = "Bundled cat teaching data; median replacement is an illustration",
    x = NULL, y = "Weight (kg)"
  )

