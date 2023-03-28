# Define Variables ---------------------------------------------------------------------

# File Paths
data_folder <- "/home/tcarleton/Climate/data" # Remote data folder for ERA5 raster stacks 
setwd("/home/tliddell/stagg_paper_figures/")

# Stagg Variables
year_start <- 2000
year_end <- 2019
years <- year_start:year_end


# Load Packages--------------------------------------------------------------------------
library(stagg)
library(tidyverse)
library(raster)
library(sf)
library(haven)
library(here)
library(tigris)
library(data.table)
library(parallel)
library(crayon)

# Load in Data ---------------------------------------------------------------------------
# Read in Polygons
counties <- counties()
counties_shifted <- st_shift_longitude(counties)

# Get Overlay Weights 
area_weights <- overlay_weights(counties, "GEOID", secondary_weights = pop_world_2015_era5)



# Stagregate Temp and Prcp Across 2000 - 2019 --------------------------------------------------


run_stagg_year_prcp <- function(year) {  
  
  ## climate data file paths
  ncpath  <- file.path(data_folder, 'raw/prcp')
  nc_file <- paste0(ncpath, '/', 'era5_prcp_', year, '.nc')
  
  ## immediately crop to weights extent 
  clim_raster_tmp <- raster::crop(raster::stack(nc_file), raster::extent(counties_shifted))
  
  ## convert m to mm
  clim_raster_tmp <- clim_raster_tmp * 1000
  
  ## run stagg for prcp  
  prcp_out <- staggregate_polynomial(clim_raster_tmp,
                                     area_weights,
                                     daily_agg = 'sum',
                                     time_agg = 'month',
                                     degree = 2)
                                  
  return(prcp_out)
  
}


## set up (cores, cluster)
no_cores <- parallel::detectCores() - 1 # Calculate the number of cores. Leave one in case something else needs to be done on the same computer at the same time. 
cl <- parallel::makeCluster(no_cores, type = "FORK") # Initiate cluster. "FORK" means bring everything in your current environment with you. 

## run 
stagg_multiyear_prcp <- parLapply(cl, years, run_stagg_year_prcp)

## stop cluster
stopCluster(cl)

## rbind
stagg_multiyear_prcp_all <- data.table::rbindlist(stagg_multiyear_prcp)

## save outputs

save_name_prcp <- paste0(paste("prcp", "polynomial",
                               year_start, year_end, "US", "counties", 'prcp', "era5", "pop_weights", sep="-"), ".csv")

output_save_path <- "/home/tliddell/stagg_paper_figures/data/stagg_output/precipitation"

## save message
message(crayon::yellow('Saving', save_name_prcp, 'to', output_save_path))

## save output
data.table::fwrite(stagg_multiyear_prcp_all, file = file.path(output_save_path, save_name_prcp))

## fin
message(crayon::green('fin'))
