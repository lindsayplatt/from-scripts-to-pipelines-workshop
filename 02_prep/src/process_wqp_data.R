
#' @title Filter and clean the downloaded WQP data
#' @description This function takes the downloaded WQP data and filters to just 
#' one desired characteristic/fraction combination. Then, it applies some data
#' cleaning to bring together the result values and units, which are stored in 
#' different columns depending on whether the measurement represents a value
#' below the detection limit. It also adds a `year` column.
#' 
#' @param wqp_data_raw a data.frame with downloaded data from WQP, such as from
#' the pipeline function `download_wqp_physchem_data()`. 
#' @param characteristic a single character string representing one possible
#' value that appears in the column `CharacteristicName`. You can access the full
#' list of possible values at https://www.waterqualitydata.us/Codes/Characteristicname?mimeType=xml.
#' @param fraction a single character string representing one possible value that
#' appears in the column `ResultSampleFractionTest`, e.g. 'Total', 'Dissolved',
#' 'Suspended', etc.
#' 
refine_wqp_data <- function(wqp_data_raw, characteristic, fraction) {
  wqp_data_raw |>
    
    # Filter the dataset to just the characteristic and sample fraction of interest
    filter(CharacteristicName == characteristic,
           ResultSampleFractionText == fraction) |>
    
    # Harmonize result units and values into a single column regardless of non-detect status
    mutate(result_unit = ifelse(ResultDetectionConditionText %in% "Not Detected", 
                                yes = tolower(DetectionQuantitationLimitMeasure.MeasureUnitCode), 
                                no = tolower(ResultMeasure.MeasureUnitCode)),
           
           result_value = as.numeric(ifelse(ResultDetectionConditionText %in% "Not Detected", 
                                            yes = DetectionQuantitationLimitMeasure.MeasureValue, 
                                            no = ResultMeasureValue)),
           
           non_detect = ifelse(ResultDetectionConditionText %in% "Not Detected", 1, 0),
           
           year = year(ActivityStartDate))
}

#' @title Summarize the refined WQP data annual
#' @description Summarize the filtered and cleaned data to output annual counts,
#' percentage of records that were non-detects, and mean values.
#' 
#' @param wqp_data_processed a data.frame of WQP data that has been filtered to 
#' represent *ONE* characteristic-fraction combo and must contain at least the
#' following columns: `MonitoringLocationIdentifier`, `CharacteristicName`, 
#' `year`, `result_unit`, `result_value`, and `non_detect`.
#' 
summarize_wqp_data_by_year <- function(wqp_data_processed) {
  wqp_data_processed |>
    group_by(MonitoringLocationIdentifier, year, result_unit, CharacteristicName) |>
    summarise(
      ncount = n(),
      perc_nd = length(non_detect[non_detect == 1])/length(non_detect) * 100,
      mean_value = mean(result_value),
      .groups = 'drop' # Avoid the message about grouped output
    )
}
