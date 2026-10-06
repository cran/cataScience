## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = "#>", message = FALSE,
                     warning = FALSE, fig.width = 7.2, fig.height = 4.5)

## ----setup--------------------------------------------------------------------
library(cataScience)

## ----installation, eval=FALSE-------------------------------------------------
# install.packages("cataScience")

## ----development-installation, eval=FALSE-------------------------------------
# install.packages("remotes")
# remotes::install_github("shanlong-who/cataScience")

## ----launch, eval=FALSE-------------------------------------------------------
# library(cataScience)
# run_cata()

## ----launch-options, eval=FALSE-----------------------------------------------
# run_cata(launch.browser = FALSE, port = 3838)

## ----example-file-------------------------------------------------------------
example_file <- system.file(
  "app", "data", "cat-dirty-data.xlsx", package = "cataScience"
)
file.exists(example_file)

## ----package-version----------------------------------------------------------
packageVersion("cataScience")

