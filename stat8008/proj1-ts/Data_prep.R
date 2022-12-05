#STAT8008 Project 1 Time Series Analysis

# Data import, cleaning and transformation

#libs
library(forecast)
library(fpp2)
library(xts)
library(astsa)
library(tidyverse)
library(tsibble)
library(finalfit)
library(imputeTS)
library(ggthemes)

# import the data
elec <- read_csv2("household_power_consumption dataset.txt",
                  locale = locale(date_format = "%d/%m/%Y"),
                  col_types = 'Dtn')[,1:3]

# some preliminary checking of the data
problems(elec)
head(elec, 10)
tail(elec)
typeof(elec)
summary(elec)
colnames(elec)
spec(elec)
glimpse(elec)
ff_glimpse(elec)

# check missing values with finalfit
missing_glimpse(elec)
missing_plot(elec)
# check missing values with imputeTS
statsNA(elec$Global_active_power)
# Prepare text output of statsNA test
sink("NA.txt")
print(summary(statsNA(elec$Global_active_power)))
sink()  
NA.txt

ggplot_na_intervals(elec$Global_active_power)
ggplot_na_gapsize(elec$Global_active_power)

# Missing rows in %
(25979/2075259)*100

# how long is the 7226 gap in hours/days?
7226/60 # 120 consecutive hours
120/24 # 5 consecutive days
(21*94329)/(60*24)
# locate NA's
which(is.na(imppwr))

# Imputation using imputeTS
imppwr <- na_ma(elec$Global_active_power, k=1, weighting = "simple", maxgap=Inf)

# join imputed data to original dataframe
imp_data <- bind_cols(elec, imppwr)
colnames(imp_data)[4] <- "Imp_power"
head(imp_data); tail(imp_data)

# use lubridate to extract year and month into new cols
imp_data$Year <- lubridate::year(imp_data$Date)
imp_data$Month <- lubridate::month(imp_data$Date)

# Create time series of variable of interest: Global_active_power
Mon_mean <- imp_data %>% group_by(Year, Month) %>% summarise(Mon_mean = mean(Imp_power))
Mon_mean <- ts(Mon_mean3,frequency=12, start=c(2006,12))
Mon_mean <- Mon_mean[,2]
Mon_mean # check the output

# save data
saveRDS(object = Mon_mean, file = "Final_ts.rds")
saveRDS(object = elec, file = "elec.rds")