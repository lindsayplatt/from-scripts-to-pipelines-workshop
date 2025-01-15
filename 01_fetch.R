
# This file includes the target recipes for targets that download data

# Configuration elements
start_date = "10-01-2020" # Format MM-DD-YYYY
out_data_file = "01_fetch/out/p1_data_file.csv"

# Load all `src` files for this phase
source('01_fetch/src/download_wqp_physchem_data.R')

p1 <- list(
  
  # Fetch data from the portal using a function defined in the pipeline
  tar_target(
    p1_dataset,
    download_wqp_physchem_data(state = 'Wisconsin',
                               county = 'Brown',
                               start_date = start_date,
                               end_date = '2023-09-30')
    ),
  
  # Save raw data as a csv to be able to share outside of the pipeline.
  # Note that target name is the same as the data *except* for the 
  # suffix `_csv`, denoting the file type.
  tar_target(p1_dataset_csv, {
    write_csv(p1_dataset, out_data_file)
    return(out_data_file) # File targets *must* return the filepath at the end
  }, 
  format = "file"
  )
  
)
