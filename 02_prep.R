
# This file includes the target recipes for targets that clean and prepare data

# Configuration elements
characteristic = "Chloride"
fraction = "Dissolved"

# Load all `src` files for this phase
# source('02_prep/src/?????.R')

p2 <- list(
  # Filter to characteristic and fraction of interest
  tar_target(
    p2_filter_dataset,
    {
      # This could definitely be a function
      p1_dataset |>
        filter(CharacteristicName == characteristic,
               ResultSampleFractionText == fraction) |>
        mutate(result_unit = ifelse(ResultDetectionConditionText %in% "Not Detected", tolower(DetectionQuantitationLimitMeasure.MeasureUnitCode), tolower(ResultMeasure.MeasureUnitCode)),
               result_value = as.numeric(ifelse(ResultDetectionConditionText %in% "Not Detected", DetectionQuantitationLimitMeasure.MeasureValue, ResultMeasureValue)),
               non_detect = ifelse(ResultDetectionConditionText %in% "Not Detected", 1, 0),
               year = year(ActivityStartDate))
    }
  ),
  # Wrangle result data for plotting and mapping
  tar_target(
    p2_summarize_dataset_by_year,
    {
      p2_filter_dataset |>
        group_by(MonitoringLocationIdentifier, year, result_unit, CharacteristicName) |>
        summarise(
          ncount = n(),
          perc_nd = length(non_detect[non_detect == 1])/length(non_detect) * 100,
          mean_value = mean(result_value),
          .groups = 'drop' # Avoid the message about grouped output
        )
    }
  )
)
