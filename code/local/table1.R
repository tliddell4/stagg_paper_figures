## tracey mangin
## august 31, 2023
## table, reproduce in r

##
install.packages("kableExtra")

## libraries
library(tidyverse)
library(kableExtra)

package_table <- tibble(Package = c("stagg", "xagg", "krigR", "climate4R", 
                                    "exactextractr", "climateR", "ecmwfr"),
                        Language = c("R", "python", "R", "R", "R", "R", "R"),
                        Download_climate_data = c(NA, "X", "X", "X", NA, "X", "X"),
                        Nonlinear_transformation = c("X", rep(NA, 6)),
                        Temporal_aggregation = c("X", rep(NA, 6)),
                        Aggregate_to_polygons = c("X", "X", NA, NA, "X", NA, NA),
                        wt_agg = c("X", "X", NA, NA, "X", NA, NA))