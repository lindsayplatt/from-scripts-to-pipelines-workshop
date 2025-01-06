#' Plot timeseries for a given site and characteristic
#'
#' @param site_id A character string describing a site ID for a site in the input
#' dataframe
#' @param df A dataframe containing water quality data for one characteristic
#' for one or more sites from the Water Quality Portal
#' @param out_path A folder path to the location where plots should be saved.
#'
#' @return Saves a .png plot at the `out_path` location and returns the file 
#' path to the plot.

plot_timeseries <- function(site_id, df, out_path) {
  site_data <- df |>
    filter(MonitoringLocationIdentifier %in% site_id)
  
  ggplot(site_data, aes(x = date, y = result_value)) +
    geom_point() +
    labs(title = paste(unique(site_data$MonitoringLocationIdentifier), " - ", unique(site_data$CharacteristicName)),
         x = "Date",
         y = "mg/L") +
    theme_classic()
  
  file_path <- paste0(out_path, "/timeseries_", site_id, ".png")
  
  ggsave(file_path)
}