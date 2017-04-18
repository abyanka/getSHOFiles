Short interest data for quantitative investing.
Written in R

_getSHO.R is the key file.
It calls two other files which grabs the data and constructs an easily useable file with the short interest going back to 2009.
These two files are the files that would most likely interest someone who wants to set up a scrape of SHO daily.

_getSHO.R is how I prepare the short interest files for my own use.
In it, I calculate normalized deviations from a moving average.

I schedule _getSHO to run daily at midnight so that the data is ready for automated investment the next business day

Note that directory paths are set to my computer in all 3 files.
Directory paths are in all 3 files so that each file can be run independently.
Change these plus install.packages as needed for use in your environment

SP500 constituent symbols are include to facilitate the execution of _getSHO.R
dailySUSIR.csv is the example output.

comments, bugs, critiques, etc
tzuohann@gmail.com