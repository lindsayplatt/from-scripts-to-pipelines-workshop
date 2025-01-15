#' @title Map mean values using leaflet
#' 
#' @description This function takes a Water Quality Portal (WQP) dataset and maps 
#' each site and its mean concentration over the entire sampling period of the dataset.
#'
#' @param out_file A character string representing the filepath to use to save
#' the leaflet map as an HTML file, including the directory, file name, and extension.
#' @param wqp_site_metadata A WQP siteInfo data.frame containing at least the 
#' columns `MonitoringLocationIdentifier`, `MonitoringLocationName`, 
#' `LatitudeMeasure`, and `LongitudeMeasure`.
#' @param wqp_data_summarized A data.frame with a summary of the WQP per site
#' as sample count, mean value, standard deviation, and percent of non-detects.
#' This is created by the custom pipeline fxn, `summarize_wqp_data_by_site()`
#'
#' @return A leaflet map showing sampling locations, where each point's radius is
#' proportional to the mean concentration measured at that site over the entire
#' dataset. Users can click on points to obtain additional information about the
#' site and constituent.

map_dataset <- function(out_file, wqp_site_metadata, wqp_data_summarized) {
  
  wqp_data_map <- wqp_data_summarized |>
    mutate(radius = scales::rescale(mean_value, to = c(3, 10))) |>
    left_join(wqp_site_metadata, by = "MonitoringLocationIdentifier")
  
  # Create the leaflet map
  map <- leaflet(wqp_data_map) %>%
    addProviderTiles("USGS.USImageryTopo") %>% # Add base map tiles
    addCircleMarkers(
      ~LongitudeMeasure,
      ~LatitudeMeasure,
      radius = ~radius, # Use the calculated radius
      color = "red", # "#FFB612", # packers yellow
      fillColor = "black", # "#203731", # packers green
      fillOpacity = 0.8,
      popup = ~paste0(
        "<b>Location Name:</b> ", MonitoringLocationName, "<br>",
        "<b>Constituent:</b> ", CharacteristicName, " (", result_unit, ")<br>",
        "<b>Sample Count:</b> ", n_count, "<br>",
        "<b>Mean Value:</b> ", mean_value, "<br>",
        "<b>Standard Deviation:</b> ", sd_value, "<br>",
        "<b>% Non-Detect:</b> ", percent_nondetect
      )
    )
  
  # Save the map
  htmlwidgets::saveWidget(map, out_file, selfcontained = TRUE)
  
  return(out_file)
}
