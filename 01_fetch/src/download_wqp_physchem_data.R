
#' @title Download WQP data using dataRetrieval fxns
#' @description This function downloads data from the Water Quality Portal (WQP)
#' using the functions in the package `dataRetrieval`. Given a state, county,
#' and date range, the function will return the sample results for physical and
#' chemical from water media stored in WQP.
#' 
#' @param state character string giving the full state name, e.g. "Wisconsin"
#' @param county character string giving the full county name, e.g. "Brown"
#' @param start_date character or Date value giving the first date to include
#' @param end_date character or Date value giving the last date to include
#' 
download_wqp_physchem_data <- function(state, county, start_date, end_date) {
  readWQPdata(service = "Result", # This is currently set to WQX legacy
              profile = "resultPhysChem",
              sampleMedia = c('water', 'Water'),
              characteristicName = c('Chloride', 
                                     'Phosphorus', 
                                     'Nitrate'), 
              statecode = state,
              countycode = county,
              startDateLo = start_date,
              startDateHi = end_date)
}
