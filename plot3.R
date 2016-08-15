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

png("plot3.png")
with(data, plot(date_time, sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(data, lines(date_time, sub_metering_2, col = "red"))
with(data, lines(date_time, sub_metering_3, col = "blue"))
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()