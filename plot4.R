# this will download the data set, if it is not found on working directory

if(!file.exists("./household_power_consumption.txt")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile="./household_power_consumption.zip")
  unzip(zipfile="./household_power_consumption.zip")
}

# loads the file

if(!require(readr)) install.packages("readr")

cnames <- c("date", "time", "global_active_power", "global_reactive_power", "voltage", 
            "sub_metering_1", "sub_metering_2", "sub_metering_3")
data <- read_delim("./household_power_consumption.txt", delim = ";", col_names = cnames, 
                   col_types = "ccddd_ddd", skip = 66637, n_max = 2880)

# tidies date and time

if(!require(tidyr)) install.packages("tidyr")
data <- unite(data, date_time, date, time, sep = " ")
if(!require(lubridate)) install.packages("lubridate")
data$date_time <- as.POSIXct(dmy_hms(data$date_time))

# plots

png("plot4.png")
par(mfcol = c(2, 2))

with(data, plot(date_time, global_active_power, type = "l", ylab = "Global Active Power", xlab = ""))

with(data, plot(date_time, sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(data, lines(date_time, sub_metering_2, col = "red"))
with(data, lines(date_time, sub_metering_3, col = "blue"))
legend("topright", bty = "n", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

with(data, plot(date_time, voltage, type = "l", ylab = "Voltage", xlab = "datetime"))

with(data, plot(date_time, global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "datetime"))

dev.off()