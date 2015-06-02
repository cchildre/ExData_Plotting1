## plot4 script creates plots from the Electric Power 
## Consumption Database from data corresponding to 2/1/2007 and 2/2/2007


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
png(filename = "plot4.png",
    width = 480,
    height = 480)

# set up plot area for 4 plots
par(mfrow = c(2,2))

# first plot (same as plot2.R)
with(data, plot(x = DateTime,
                y = Global_active_power, 
                type = "l",
                xlab = "",
                ylab = "Global Active Power"))

# second plot

with(data, plot(x = DateTime, 
                y = Voltage, 
                type = "l",
                xlab = "datetime",
                ylab= "Voltage"))


# 3rd plot (same as plot3.R)
{ # bracket to keep plot grouped together
        with(data, plot(x = DateTime,
                y = Sub_metering_1, 
                type = "n",
                xlab = "",
                ylab = "Energy sub metering"))

# plot Sub metering 1 in black
with(data, lines(DateTime, Sub_metering_1, col = "black"))

# plot sub metering 2 in red
with(data, lines(DateTime, Sub_metering_2, col = "red"))

# plot sub metering 3 in blue
with(data, lines(DateTime, Sub_metering_3, col = "blue"))

# add legend
legend("topright",
       lty = 1,
       col = c("black", "red", "blue"), 
       legend = names(data)[6:8])
}

# plot 4
with(data, plot(x = DateTime,
                y = Global_reactive_power,
                xlab = "datetime",
                type = "l"))

# Close device
dev.off()