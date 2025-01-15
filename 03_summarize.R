
# This file includes the target recipes for targets that summarize and visualize data

# Load all `src` files for this phase
source('03_summarize/src/plot_functions.R')
source('03_summarize/src/map_function.R')

p3 <- list(
  # next can add a timeseries plot for the data by year and then maybe an accompanying map?
  # would love to create a very simple shiny app for this.
  tar_target(
    p3_timeseries_plots,
    plot_timeseries(site_id = p2_sites, df = p2_filter_dataset, out_path = "03_summarize/out"),
    pattern = map(p2_sites),
    format = "file"
  ),
  tar_target(
    p3_leaflet_map,
    map_dataset(data = p2_filter_dataset, out_path = "03_summarize/out")
  )
)
