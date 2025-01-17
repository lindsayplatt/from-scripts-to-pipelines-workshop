
# This file includes the target recipes for targets that download data

# Load all `src` files for this phase
source('01_fetch/src/download_wqp_physchem_data.R')

p1 <- list(
  
  # Fetch data from the portal using a function defined in the pipeline
  tar_target(
    p1_dataset,
    download_wqp_physchem_data(state = state,
                               county = county,
                               start_date = start_date,
                               end_date = end_date)
    ),
  
  # Save raw data as a csv to be able to share outside of the pipeline.
  # Note that target name is the same as the data *except* for the 
  # suffix `_csv`, denoting the file type.
  tar_target(p1_dataset_csv, {
    out_file <- "01_fetch/out/p1_data_file.csv"
    write_csv(p1_dataset, out_file)
    return(out_file) # File targets *must* return the filepath at the end
  }, 
  format = "file"
  )
  
)
