#Up to now, the SHO dates have been the dates of the actual SHO trades.
#For this use of the SHO data, we use the previous dau's
#Add 1 to make the date because March24th data is for trading on March25th;
rm(list = ls())
library(data.table)
library(zoo)
#try(setwd("/Users/lawtz/Dropbox/quantopian"))
try(setwd("C:/Users/tzuohann/Dropbox/quantopian"))

#UPDATE DATA
updateData  = TRUE
#How many days back to calculating short interest trade surprise
dayWin      = 15
#Number of calendar days back to output susir information
outputDays  = 20*1
#Number of symbols to keep per day top and bottom according to rank
#Be careful here that 2*cutOffNum does not exceed the number of symbols per day.
cutOffNum   = 50

if (updateData){
  source('getSHOFiles.R')
  source('updatesVol.R')
}
sVol = fread('sVol.csv')

print("Keeping SP500")
SP500List                 = read.csv(file = "SPconstituents.csv")
sVol = sVol[is.element(sVol$Symbol,SP500List$Symbol),]

print('Calculate the short interest')
sVol$SR = sVol$ShortVolume/sVol$TotalVolume
#sVol$SR = sVol$ShortVolume
sVol[,ShortVolume := NULL];
sVol[,TotalVolume := NULL];
sVol = sVol[order(sVol$Symbol,as.Date(as.character(sVol$Date), format="%Y%m%d")),]

sVol = split(sVol,as.factor(sVol$Symbol))
#sVol = Filter(function(s) nrow(s) >= dayWin,sVol)
sVol = lapply(sVol, 
              function(s) {s$ma = rollmean(s$SR,
                                           dayWin,
                                           fill = NA,
                                           align = "right");return(s)})
sVol = lapply(sVol, function(s) {s$sd = rollapply(s$SR,
                                                  dayWin,
                                                  sd,fill = NA,
                                                  align = "right");return(s)})
sVol = lapply(sVol, function(s) {s$susir = (s$SR - s$ma)/s$sd;return(s)})
sVol = lapply(sVol, function(s) {s = s[!is.na(s$susir),];return(s)})
sVol = lapply(sVol, function(s) {s[,c('SR','ma','sd') := NULL];return(s)})

sVol = do.call(rbind, sVol)
sVol = split(sVol,as.factor(sVol$Date))

sVol = lapply(sVol, 
              function(s) {s = s[order(s$susir),];return(s)})
sVolTail = lapply(sVol, 
              function(s) {s = tail(s,cutOffNum);return(s)})
sVolHead = lapply(sVol, 
              function(s) {s = head(s,cutOffNum);return(s)})

dailySUSIR = rbind(do.call(rbind, sVolTail),do.call(rbind, sVolHead))
rownames(dailySUSIR) = NULL
colnames(dailySUSIR) = tolower(colnames(dailySUSIR))
dailySUSIR = dailySUSIR[order(dailySUSIR$date,dailySUSIR$susir),]
dailySUSIR$date           = format(as.Date(as.character(dailySUSIR$date), format="%Y%m%d") + 1,"%Y/%m/%d")
dailySUSIR = dailySUSIR[difftime(Sys.Date(),dailySUSIR$date,units="days") <  outputDays,]
write.csv(dailySUSIR,file = "dailySUSIR.csv", row.names = FALSE)
