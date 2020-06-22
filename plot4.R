myurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#Defines the URL to download data from

download.file(myurl,"./CP1")
#Downloads the data from myurl and places it in the cwd as file CP1

unzip("./CP1",junkpaths = TRUE)
#Unzips the CP1 file to the directory

mydata <- read.csv("./household_power_consumption.txt",header=TRUE,sep=";")
#Reads the unzipped file with ; as the delimitor

mydata$Date<-as.Date(strptime(mydata$Date,format="%d/%m/%Y"))
#Formats the entries in the Date column as Date variables in R

subdata <- subset(mydata,mydata$Date=="2007-02-01")
#Subsets the data on the date 2007-02-01 and stores it in the subdata variable

subdata <- rbind(subdata,subset(mydata,mydata$Date=="2007-02-02"))
#Binds the data on the date 2007-02-01 to the subdata variable

subdata$Time<-format(strptime(subdata$Time,format="%R:%S"),"%R:%S")
#Formats the entries in the time column as Date variables in R

subdata$Global_active_power<-as.numeric(subdata$Global_active_power)
subdata<-cbind(subdata,subdata$Global_active_power/1000)
names(subdata)[10]<-"Global Active Power (kilowatts)"
#Scales the global active power variable by a factor of 1000

subdata <- cbind(subdata,as.POSIXct(paste(subdata$Date,subdata$Time)))
names(subdata)[11]<-"TotDate"
#Combines the data and time entries to one variable in column TotDate

scaledVolt<-as.numeric(subdata$Voltage)/10
subdata <- cbind(subdata,scaledVolt)
#Adds a column to subdata that scales voltage by a factor of ten

subdata$Global_reactive_power<-as.numeric(subdata$Global_reactive_power)/10
#Replaces and scales Global_reactive_power by a factor of ten

par(mfrow=c(2,2))
#Creates 2 rows and 2 columns to be filled by plots

with(subdata, {
        plot(TotDate,`Global Active Power (kilowatts)`,type="l",
             xlab="",ylab="Global Active Power (kilowatts)")
        #plots top left graph
        
        plot(TotDate, scaledVolt, type="l", xlab="datetime", ylab="Voltage")
        #plots top right graph
        
        plot(TotDate, Sub_metering_1, type="n", xlab="", 
             ylab="Energy sub metering", yaxt="none", ylim = c(0,35))
        axis(2,at=c(0,10,20,30))
        lines(TotDate,Sub_metering_1,col="black")
        lines(TotDate,Sub_metering_2,col="red")
        lines(TotDate,Sub_metering_3,col="blue")
        legend(legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
               ,"topright", col=c("black", "red", "blue"), lty=1,bty="n")
        #plots bottom left graph
        
        plot(TotDate, Global_reactive_power, type="l", xlab="datetime")
        #plots bottom right graph
})

dev.copy(device=png,filename = "plot4.png",width=480,height=480,units="px")
dev.off() 
#Copies the plots to a png file