data1 <- read.table("/Users/jiaodavy/household_power_consumption.txt", header = T, 
                    sep = ";", na.strings = "?", check.names = F, stringsAsFactors = F)
data1$Date <- as.Date(data1$Date, format="%d/%m/%Y")
data2 <- subset(data1, subset = (Date >= "2007-02-01" & Date <= "2007-02-02"))

datetime <- paste(as.Date(data2$Date), data2$Time)
data2$Datetime <- as.POSIXct(datetime)

data2$Global_active_power <- as.numeric(data2$Global_active_power)
hist(data2$Global_active_power, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red")

dev.copy(png, file = "plot1.png", height = 480, width = 480)
dev.off()
