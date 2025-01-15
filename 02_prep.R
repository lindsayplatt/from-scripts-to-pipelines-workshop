
# This file includes the target recipes for targets that clean and prepare data

# Configuration elements
characteristic = "Chloride"
fraction = "Dissolved"

# Load all `src` files for this phase
source('02_prep/src/process_wqp_data.R')

p2 <- list(
  
  # Filter to characteristic and fraction of interest and clean up some of the
  # columns using a custom fxn defined in `02_prep/src/process_wqp_data.R`
  tar_target(
    p2_filter_dataset,
    refine_wqp_data(p1_dataset, characteristic, fraction)
  ),
  
  # Wrangle result data for plotting and mapping
  tar_target(
    p2_summarize_dataset_by_year,
    summarize_wqp_data_by_year(p2_filter_dataset)
  ),
  
  # Get list of site IDs for plotting
  tar_target(
    p2_site_list,
    unique(p2_filter_dataset$MonitoringLocationIdentifier)
  )
)
