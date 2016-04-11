### Read partial .txt file into R. The file includes data from the dates 2007-02-01 and 2007-02-02. 
data <- "household_power_consumption.txt"
fi <- file(data) ### Create a file connection.
library(sqldf) ### Load sqldf package.
mydata <- sqldf("select * from fi where Date = '1/2/2007' or Date ='2/2/2007'", file.format = list(header = TRUE, sep = ";"))
close(fi) ### Close the file connection.

head(mydata, n=3) ### Check the first three rows.
### Combine the Date and Time variables.
mydata$DateTime <- paste(mydata$Date,mydata$Time)
### Convert the DateTime variable to Date format.
mydata$DateTime <- strptime(mydata$DateTime, "%d/%m/%Y %H:%M:%S")
### Recode the missing value "?" to "NA".
mydata1 <- replace(mydata[,c(3:9)],mydata[,c(3:9)]=='?','NA')
mydata <- cbind(mydata[,c(1,2,10)], mydata1)

### Create plot2.
png(file = "plot2.png", width = 480, height = 480) ### Open the PNG device; create 'plot2.png' in my working directory
### Create plot and send to a png file.
with(mydata, plot(DateTime, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))
dev.off() ### Close the PNG file device.