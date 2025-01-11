#' Map mean values using leaflet
#' 
#' This function takes a Water Quality Portal (WQP) dataset and maps each site and its
#' mean concentration over the entire sampling period of the dataset.
#'
#' @param data A WQP Result profile from the prep step of the data pipeline. It 
#' must contain the following columns:
#' `MonitoringLocationIdentifier`, `CharacteristicName`, `result_value`, `result_unit`,
#' and `non_detect` and it must have an attribute called `siteInfo`.
#' @param out_path A string describing the location where the leaflet map should
#' be saved.
#'
#' @return A leaflet map showing sampling locations, where each point's radius is
#' proportional to the mean concentration measured at that site over the entire
#' dataset. Users can click on points to obtain additional information about the
#' site and constituent.

map_dataset <- function(data, out_path){
  
  site_info <- attr(data, "siteInfo") |>
    select(MonitoringLocationIdentifier, MonitoringLocationName, LatitudeMeasure, LongitudeMeasure)
    
  df <- data |>
    group_by(MonitoringLocationIdentifier, CharacteristicName, result_unit) |>
    summarise(
      n_count = n(),
      mean_value = round(mean(result_value, na.rm = TRUE), 2),
      sd_value = round(sd(result_value, na.rm = TRUE), 2),
      percent_nondetect = round(sum(non_detect)/length(non_detect) * 100, 2),
      .groups = "drop"
    ) |>
    mutate(radius = scales::rescale(mean_value, to = c(3, 10))) |>
    left_join(site_info, by = "MonitoringLocationIdentifier")
  
  # Create the leaflet map
  map <- leaflet(df) %>%
    addTiles() %>% # Add base map tiles
    addCircleMarkers(
      ~LongitudeMeasure,
      ~LatitudeMeasure,
      radius = ~radius, # Use the calculated radius
      color = "#FFB612", # packers yellow
      fillColor = "#203731", # packers green
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
  param <- unique(df$CharacteristicName)
  file_path <- paste0(out_path, "/leaflet_map_", param, ".html")
  htmlwidgets::saveWidget(map, file_path, selfcontained = TRUE)
}
