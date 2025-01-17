
library(targets)

tar_option_set(
  packages = c(
    'dplyr',
    'ggplot2',
    'dataRetrieval', # may comment out for actual workshop
    'readr',
    'lubridate',
    'leaflet',
    'htmlwidgets',
    'scales'
  )
)

# Set 01_fetch pipeline configurations
start_date <- "2020-10-01" # Date samples begin
end_date <- "2023-09-30" # Date samples end
state <- 'Wisconsin'
county <- 'Brown'

# Set 02_prep pipeline configurations
characteristic <- "Chloride" # Phosphorus, Nitrate
fraction <- "Dissolved"

source('01_fetch.R')
source('02_prep.R')
source('03_summarize.R')

# Combine all targets from each phase recipe
c(p1, p2, p3)
