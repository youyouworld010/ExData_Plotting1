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

### Create plot3.
png(file = "plot3.png", width = 480, height = 480) ### Open the PNG device; create 'plot3.png' in my working directory
### Create plot and send to a png file.
library(reshape2)
mydata$f <- as.character(mydata$DateTime)
### Melt the dataset.
d <- melt(mydata, id.vars="f", measure.vars = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
names(d)
### Convert the DateTime variable back to the Date format.
d$DateTime <- strptime(d$f, "%Y-%m-%d %H:%M:%S")
### Draw the plot area, but not add data.
plot(d$DateTime, d$value, type="n", xlab="", ylab="Energy sub metering")
### Plot each group of data.
d1 <- d[d$variable=="Sub_metering_1", c(2,3,4)]
lines(d1$DateTime, d1$value, col="black")
d2 <- d[d$variable=="Sub_metering_2", c(2,3,4)]
lines(d2$DateTime, d2$value, col="red")
d3 <- d[d$variable=="Sub_metering_3", c(2,3,4)]
lines(d3$DateTime, d3$value, col="blue")
### Add legend to the plot.
legend("topright", col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1,1,1))
dev.off() ### Close the PNG file device.