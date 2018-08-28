zipFile <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
sourceFile <- "household_power_consumption.txt"

#Unzip file
unzip(zipFile)

#Read source data
source <- read.csv2(sourceFile, header = TRUE, na.string = "?")

#Subset data for 2/1/2007 & 2/2/2007
data <- subset(source, source$Date %in% c("1/2/2007", "2/2/2007"))

#Add column with converted Date/Time class
data$Date_Time <- paste(data$Date, data$Time)
data$Date_Time <- as.POSIXct(strptime(data$Date_Time, "%d/%m/%Y %H:%M:%S"))

#Convert factors to numeric data types where applicable
data$Global_active_power <- as.numeric(levels(data$Global_active_power))[data$Global_active_power]
data$Global_reactive_power <- as.numeric(levels(data$Global_reactive_power))[data$Global_reactive_power]
data$Voltage <- as.numeric(levels(data$Voltage))[data$Voltage]
data$Sub_metering_1 <- as.numeric(levels(data$Sub_metering_1))[data$Sub_metering_1]
data$Sub_metering_2 <- as.numeric(levels(data$Sub_metering_2))[data$Sub_metering_2]
data$Sub_metering_3 <- as.numeric(levels(data$Sub_metering_3))[data$Sub_metering_3]

#Tidy sub_metering into one column sub_metering_type with sub_metering_value
library(tidyr)
library(dplyr)

tidy_data <-
  data %>% 
  gather(sub_metering_type, sub_metering_value, Sub_metering_1:Sub_metering_3) %>%
  mutate(sub_metering_type = gsub("Sub_metering_", "", sub_metering_type))

#Plot line graphs
par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,0,0))

#Plot1
plot(data$Date_Time, data$Global_active_power, 
     type = "l", 
     main = "", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")

#Plot2
plot(data$Date_Time, data$Voltage, 
     type = "l", 
     main = "", 
     xlab = "datetime", 
     ylab = "Voltage")

#Plot3
with(tidy_data, plot(Date_Time, sub_metering_value, 
                     type = "n", 
                     main ="", 
                     xlab = "", 
                     ylab = "Energy sub metering"))

with(subset(tidy_data, sub_metering_type == 1), 
     lines(Date_Time, sub_metering_value, col = "black"))

with(subset(tidy_data, sub_metering_type == 2), 
     lines(Date_Time, sub_metering_value, col = "red"))

with(subset(tidy_data, sub_metering_type == 3), 
     lines(Date_Time, sub_metering_value, col = "blue"))


legend(x = "topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"), lty=1, cex=0.5, y.intersp=0.3)

#Plot4
plot(data$Date_Time, data$Global_reactive_power, 
     type = "l", 
     main = "", 
     xlab = "datetime",
     ylab = "Global_reactive_power")

dev.copy(png, "plot4.png", width = 480, height = 480)
dev.off()