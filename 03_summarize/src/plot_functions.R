#' Plot timeseries for a given site and characteristic
#'
#' @param out_file A character string representing the filepath to use to save
#' the current plot, including the directory, file name, and extension.
#' @param site_id A character string describing a site ID for a site in the input
#' dataframe
#' @param wqp_data_refined A dataframe containing water quality data for one 
#' characteristic for one or more sites from the Water Quality Portal. Dataframe 
#' must have the following columns: `MonitoringLocationIdentifier`, `CharacteristicName`,
#' `ActivityStartDate`, and `result_value`. `ActivityStartDate` should be a date 
#' column and `result_value` should be a numeric column.
#'
#' @return Saves a .png plot and returns the filepath to the plot.
#' 
plot_timeseries <- function(out_file, site_id, wqp_data_refined) {
  site_data <- wqp_data_refined |>
    filter(MonitoringLocationIdentifier %in% site_id)
  
  ggplot(site_data, aes(x = ActivityStartDate, y = result_value)) +
    geom_point() +
    labs(title = paste(unique(site_data$MonitoringLocationIdentifier), " - ", unique(site_data$CharacteristicName)),
         x = "Date",
         y = "mg/L") +
    theme_classic()
  
  ggsave(out_file, width = 7, height = 7)
}