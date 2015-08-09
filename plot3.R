data1 <- read.table("/Users/jiaodavy/household_power_consumption.txt", header = T, 
                    sep = ";", na.strings = "?", check.names = F, stringsAsFactors = F)
data1$Date <- as.Date(data1$Date, format="%d/%m/%Y")
data2 <- subset(data1, subset = (Date >= "2007-02-01" & Date <= "2007-02-02"))

datetime <- paste(as.Date(data2$Date), data2$Time)
data2$Datetime <- as.POSIXct(datetime)

data2$Global_active_power <- as.numeric(data2$Global_active_power)
with(data2, {
    plot(Sub_metering_1~Datetime, type="l",
         ylab="Global Active Power (kilowatts)", xlab="")
    lines(Sub_metering_2~Datetime,col='Red')
    lines(Sub_metering_3~Datetime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.copy(png, file = "plot3.png", height = 480, width = 480)
dev.off()
