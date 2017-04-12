#This assumes that getSHOFiles.R has been run
#try(setwd("/Users/lawtz/Dropbox/quantopian"))
try(setwd("C:/Users/tzuohann/Dropbox/quantopian"))
library(lubridate)
library(R.utils)
now            = Sys.Date()

num2Date <- function(dayIn=20000101){
  as.Date(as.character(dayIn), format="%Y%m%d")
}

if(!file.exists("sVol.csv")){
  #Updates/creates the masterFile of all the trades
  sVolNSQ = read.csv(file = "dailyFiles/FNSQshvol20100104.txt",sep = "|")
  sVolNYX = read.csv(file = "dailyFiles/FNYXshvol20100104.txt",sep = "|")
  sVolNSQ$Market = NULL
  sVolNYX$Market = NULL
  sVolNYX$ShortExemptVolume = NULL
  sVolNSQ$ShortExemptVolume = NULL
  sVolNSQ = sVolNSQ[!is.na(sVolNSQ$ShortVolume),]
  sVolNSQ = sVolNSQ[!is.na(sVolNSQ$TotalVolume),]
  sVolNSQ = sVolNSQ[!is.na(sVolNSQ$Symbol),]
  sVolNSQ = sVolNSQ[!is.na(sVolNSQ$Date),]
  sVolNYX = sVolNYX[!is.na(sVolNYX$ShortVolume),]
  sVolNYX = sVolNYX[!is.na(sVolNYX$TotalVolume),]
  sVolNYX = sVolNYX[!is.na(sVolNYX$Symbol),]
  sVolNYX = sVolNYX[!is.na(sVolNYX$Date),]
  sVol = rbind(sVolNYX,sVolNSQ)
  if (all(is.numeric(sVol$ShortVolume)) && all(is.numeric(sVol$TotalVolume))){
      sVol = sVol[order(sVol$Date,sVol$Symbol),]
      sVol <- aggregate(. ~  Date + Symbol, data = sVol, sum)
      write.csv(sVol,file = "sVol.csv", row.names = FALSE)
  }else{
    asdasd
  }
}

#Assumes that this file was created with the init code above and updated
nL <- countLines("sVol.csv")
sVol <- read.csv("sVol.csv", header=FALSE, skip=nL-1)
lastDayInData = num2Date(tail(sVol$V1,1))

updated = 0
while(lastDayInData<now){
  lastDayInData = lastDayInData + 1
  dayDL  = sprintf("%02d", day(lastDayInData))
  monDL  = sprintf("%02d", month(lastDayInData))
  yearDL = as.character(year(lastDayInData))
  fileToLookNSQ = paste('dailyFiles/FNSQshvol',yearDL,monDL,dayDL,'.txt',sep="")
  fileToLookNYX = paste('dailyFiles/FNYXshvol',yearDL,monDL,dayDL,'.txt',sep="")
  if(file.exists(fileToLookNSQ)){
    print(c("Updated ",as.character(lastDayInData)))
    updated = 1
    sVolNSQ = read.csv(file = fileToLookNSQ,sep = "|")
    sVolNYX = read.csv(file = fileToLookNYX,sep = "|")
    sVolNSQ$Market = NULL
    sVolNYX$Market = NULL
    sVolNYX$ShortExemptVolume = NULL
    sVolNSQ$ShortExemptVolume = NULL
    sVolNSQ = sVolNSQ[!is.na(sVolNSQ$ShortVolume),]
    sVolNSQ = sVolNSQ[!is.na(sVolNSQ$TotalVolume),]
    sVolNSQ = sVolNSQ[!is.na(sVolNSQ$Symbol),]
    sVolNSQ = sVolNSQ[!is.na(sVolNSQ$Date),]
    sVolNYX = sVolNYX[!is.na(sVolNYX$ShortVolume),]
    sVolNYX = sVolNYX[!is.na(sVolNYX$TotalVolume),]
    sVolNYX = sVolNYX[!is.na(sVolNYX$Symbol),]
    sVolNYX = sVolNYX[!is.na(sVolNYX$Date),]
    bla     = rbind(sVolNYX,sVolNSQ)
    bla     = bla[order(bla$Symbol),]
    if (nrow(bla) > 0){
      if (all(is.numeric(bla$ShortVolume)) && all(is.numeric(bla$TotalVolume))){
      bla <- aggregate(. ~  Date + Symbol, data = bla, sum)
      write.table(bla, file = "sVol.csv", sep = ",",
                  col.names = FALSE, row.names=FALSE, append=TRUE)
      }else{
        asdasd
      }
    }
  }
}
if (updated == 0){
  print("sVol.csv not updated. Check tail. Might be up-to-date")
}