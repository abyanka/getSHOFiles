#try(setwd("/Users/lawtz/Dropbox/quantopian"))
try(setwd("C:/Users/tzuohann/Dropbox/quantopian"))
#First download all available files 
#http://www.finra.org/industry/trf/monthly-short-sale-transaction-files-2012

#Monthly files start in August 2009
#Sometimes we have _1 or _2, sometimes, _1 to _4
#Daily files go back one year. Use monthly where possible, otherwise, use daily.
#Monthly files include time dimension which we can use for drift strategies later on.
#Rely on daily SHO from 20100104 for Quantopian backtests for now
library(RCurl)
library(lubridate)
add.months= function(date,n) seq(date, by = paste (n, "months"), length = 2)[2]
startMonDate = as.Date('2009-08-01') 
dlDate       = startMonDate
now  = Sys.Date()
print("Updating SHO Files")
while (dlDate < now) {
  monDL  = sprintf("%02d", month(dlDate))
  yearDL = as.character(year(dlDate))
  fileToLook = paste('monthlyFiles/FNYXsh',yearDL,monDL,'.txt.zip',sep="")
  urlToLook  = paste('http://regsho.finra.org/FNYXsh',yearDL,monDL,'.txt.zip',sep="")
  if (!file.exists(fileToLook)){
    if (url.exists(urlToLook)){
      print(urlToLook)
      download.file(urlToLook,destfile=paste(fileToLook,sep=""),quiet = TRUE)
    }
  }
  for (i1 in 1:4){
    urlToLook  = paste('http://regsho.finra.org/Nasdaq_TRF_REGSHO_',yearDL,monDL,'_',as.character(i1),'.zip',sep="")
    fileToLook = paste('monthlyFiles/Nasdaq_TRF_REGSHO_',yearDL,monDL,'_',as.character(i1),'.zip',sep="")
    if (!file.exists(fileToLook)){
      if (url.exists(urlToLook)){
        print(urlToLook)
        download.file(urlToLook,destfile=paste(fileToLook,sep=""),quiet = TRUE)
      }
    }
  }
  dlDate = add.months(dlDate, 1)
}

#Daily files start in 20100104
#http://regsho.finra.org/FNYXshvol20160401.txt
#and
#http://regsho.finra.org/FNSQshvol20160401.txt
startDayDate = as.Date('2010-01-04') 
dlDate       = startDayDate
now  = Sys.Date()
while (dlDate < now) {
  dayDL  = sprintf("%02d", day(dlDate))
  monDL  = sprintf("%02d", month(dlDate))
  yearDL = as.character(year(dlDate))
  fileToLook = paste('dailyFiles/FNYXshvol',yearDL,monDL,dayDL,'.txt',sep="")
  urlToLook  = paste('http://regsho.finra.org/FNYXshvol',yearDL,monDL,dayDL,'.txt',sep="")
  if (!file.exists(fileToLook)){
    if (url.exists(urlToLook)){
      print(urlToLook)
      download.file(urlToLook,destfile=paste(fileToLook,sep=""),quiet = TRUE)
    }
  }
  fileToLook = paste('dailyFiles/FNSQshvol',yearDL,monDL,dayDL,'.txt',sep="")
  urlToLook  = paste('http://regsho.finra.org/FNSQshvol',yearDL,monDL,dayDL,'.txt',sep="")
  if (!file.exists(fileToLook)){
    if (url.exists(urlToLook)){
      print(urlToLook)
      download.file(urlToLook,destfile=paste(fileToLook,sep=""),quiet = TRUE)
    }
  }
  dlDate = dlDate + 1
}