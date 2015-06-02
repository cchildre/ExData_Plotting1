## plot2 script creates a plot from the Electric Power 
## Consumption Database from data corresponding to 2/1/2007 and 2/2/2007
# plot is Global Active Power vs. Day of the week....

library(dplyr, warn.conflicts = FALSE)
library(lubridate)

# read the data set 

data <- tbl_df(read.table("household_power_consumption.txt", header = TRUE,
                          sep = ";", na.strings = "?",
                          colClasses = c("character", "character", "numeric", "numeric",
                                         "numeric", "numeric", "numeric", "numeric", 
                                         "numeric")
))

# filter to rows containing date 1/2/2007 and 2/2/2007
data <- filter(data, Date == "1/2/2007" | Date == "2/2/2007")

# change Date and Time columns to DateTime with POSIX time format
# and remove Date, Time columns

data <- data %>%
        mutate(DateTime = dmy_hms(paste(Date, Time))) %>%
        select(DateTime, Global_active_power:Sub_metering_3)

# Open device for plot with width and height 480 pixels
png(filename = "plot2.png",
    width = 480,
    height = 480)

# Create line plot for plot 2
with(data, plot(x = DateTime,
                y = Global_active_power, 
                type = "l",
                xlab = "",
                ylab = "Global Active Power (kilowatts)"))

# Close device
dev.off()