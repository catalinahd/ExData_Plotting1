#Loading the data
#This assignment uses data from the UC Irvine Machine Learning Repository 
#Dataset: Electric power consumption [20Mb]
#Description: Measurements of electric power consumption in one household with a one-minute sampling rate over 
#a period of almost 4 years. Different electrical quantities and some sub-metering values are available.
#The following descriptions of the 9 variables in the dataset are taken from the UCI web site:
  
#Date: Date in format dd/mm/yyyy
#Time: time in format hh:mm:ss
#Global_active_power: household global minute-averaged active power (in kilowatt)
#Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#Voltage: minute-averaged voltage (in volt)
#Global_intensity: household global minute-averaged current intensity (in ampere)
#Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.



#packages 
library(data.table)
library(lubridate)

# create data folder
if (!file.exists('source data')) {
  dir.create('source data')}

# download the data if the file doesn't exist already
if (!file.exists('source data/power_consumption.txt')) {
  
  # go to the URL and download the zip file + unzip
  file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(file.url,destfile='source data/power_consumption.zip')
  unzip('source data/power_consumption.zip',exdir='source data',overwrite=TRUE)
  
  # We will only be using data from the dates 2007-02-01 and 2007-02-02
  variable.class<-c(rep('character',2),rep('numeric',7))
  power.consumption<-read.table('source data/household_power_consumption.txt',header=TRUE,
                                sep=';',na.strings='?',colClasses=variable.class)
  power.consumption<-power.consumption[power.consumption$Date=='1/2/2007' | power.consumption$Date=='2/2/2007',]
  
  # clean up the variable names and convert date/time fields
  cols<-c('Date','Time','GlobalActivePower','GlobalReactivePower','Voltage','GlobalIntensity',
          'SubMetering1','SubMetering2','SubMetering3')
  colnames(power.consumption)<-cols
  power.consumption$DateTime<-dmy(power.consumption$Date)+hms(power.consumption$Time)
  power.consumption<-power.consumption[,c(10,3:9)]
  
  # write a clean data set to the directory
  write.table(power.consumption,file='source data/power_consumption.txt',sep='|',row.names=FALSE)
} else {
  
  power.consumption<-read.table('source data/power_consumption.txt',header=TRUE,sep='|')
  power.consumption$DateTime<-as.POSIXlt(power.consumption$DateTime)
  
}

