#!/bin/bash
##SBATCH -n 8                # Number of cores, up to 40 per machine usually
##SBATCH -N 1                # Ensure that all cores are on one machine
##SBATCH -t 1-00:00          # Runtime in D-HH:MM, 2 hours
#SBATCH -p largemem         # Partition to submit to. Find out partitions with the command "sinfo"
##SBATCH --mem=1000          # Memory pool for all cores (see also --mem-per-cpu)
##SBATCH -o name_%j.out    	# File to which STDOUT will be written, %j inserts jobid
##SBATCH -e name_%j.err     # File to which STDERR will be written, %j inserts jobid

module load R/4.0.1 #Load R module
module load gdal #load gdal (for geospatial stuff like rgdal package in r)
module load proj 
export R_LIBS_USER=$HOME/apps/R_4.0.1:$ #tell R which folder to look for packages
R CMD BATCH --quiet --no-restore --no-save /home/tliddell/stagg_paper_figures/code/cluster/r_scripts/temp_bins.R
