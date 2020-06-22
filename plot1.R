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

hist(subdata$`Global Active Power (kilowatts)`,
     xlab="Global Active Power (kilowatts)", col = "red",
     main="Global Active Power")
#Creates a histogram of Global Active Power colored red with the title Global
#active power and the x label Global Active Power (kilowatts)

dev.copy(device=png,filename = "plot1.png",width=480,height=480,units="px")
dev.off()     
#Copies the histogram to a png file