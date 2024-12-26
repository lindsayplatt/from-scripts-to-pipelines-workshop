
# This file includes the target recipes for targets that download data

# Configuration elements
start_date = "10-01-2020" # Format MM-DD-YYYY
out_data_file = "01_fetch/out/p1_data_file.csv"

# Load all `src` files for this phase
# source('01_fetch/src/?????.R')

p1 <- list(
  # Fetch data from the portal
  tar_target(
    p1_dataset,
      readWQPdata(service = "Result", # This is currently set to WQX legacy
                  profile = "resultPhysChem",
                  statecode = "Wisconsin",
                  countycode = "Brown",
                  startDateLo = start_date)
  ),
  # Save data to csv
  tar_target(
    p1_dataset_csv,
    {
      p1_dataset |>
        write_csv(out_data_file)
      
      return(out_data_file)
    },
    format = "file"
  )
)
