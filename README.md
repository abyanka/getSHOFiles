# Short interest data for quantitative investing.
# Written in R

# _getSHO.R is the key file.
# It calls two other files which grabs the data and constructs an easily useable file with the short interest going back to 2009.

# Modify it for your use. 
# I schedule _getSHO to run daily at midnight so that the data is ready for automated investment the next business day

# Note that directory paths are set to my computer in all 3 files.
# Directory paths are in all 3 files so that each file can be run independently.
# Change these plus install.packages as needed for use in your environment