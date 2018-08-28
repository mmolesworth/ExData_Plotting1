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
data$Date_Time <- strptime(data$Date_Time, "%d/%m/%Y %H:%M:%S")

#Convert factors to numeric data types where applicable
data$Global_active_power <- as.numeric(levels(data$Global_active_power))[data$Global_active_power]
data$Global_reactive_power <- as.numeric(levels(data$Global_reactive_power))[data$Global_reactive_power]
data$Voltage <- as.numeric(levels(data$Voltage))[data$Voltage]
data$Sub_metering_1 <- as.numeric(levels(data$Sub_metering_1))[data$Sub_metering_1]
data$Sub_metering_2 <- as.numeric(levels(data$Sub_metering_2))[data$Sub_metering_2]
data$Sub_metering_3 <- as.numeric(levels(data$Sub_metering_3))[data$Sub_metering_3]

#Plot histogram to the screen
hist(data$Global_active_power, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)",
     col = "red")

#Copy plot to PNG file
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()

print("Finished plot.")