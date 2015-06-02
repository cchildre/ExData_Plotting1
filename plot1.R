## plot1 script creates a histogram from the Electric Power 
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
png(filename = "plot1.png",
    width = 480,
    height = 480)


# Plot histogram with title, color, breaks and correct axis
with(data, hist(Global_active_power, 
                main = "Global Active Power", 
                col = "red", 
                breaks = seq(0, 8, 0.5),
                axes = FALSE,
                xlab = "Global Active Power (kilowatts)",
                xlim = c(0, 8),
                ylim = c(0, 1200)))
axis(side = 1, at = seq(0, 6, 2))
axis(side = 2, at = seq(0, 1200, 200))

# close device
dev.off()