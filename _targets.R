
library(targets)

tar_option_set(
  packages = c(
    'dplyr',
    'ggplot2'
  )
)

source('01_fetch.R')
source('02_prep.R')
source('03_summarize.R')

# Combine all targets from each phase recipe
c(p1, p2, p3)
