## Cleaning Data for Redshift Server


## I need to figure out how to download files automatically with Python
## https://stackoverflow.com/questions/63251117/automate-a-downloading-of-csv-file-from-a-random-url-with-python
## Apparently R studio can also be used as an IDE for Python
## https://www.rstudio.com/blog/three-ways-to-program-in-python-with-rstudio/
## https://www.youtube.com/watch?v=U3ByGh8RmSc
#https://stackoverflow.com/questions/41774578/locate-python-binary-location-in-windows-tensorflow
library(reticulate)
library(png)

#Sys.setenv(RETICULATE_PYTHON="C:\\Users\\cogps\\AppData\\Local\\Programs\\Python\\Python310\\python.exe")

# repl_python(import pandas as pd)
# x=7
# import pandas as pd

###
setwd("C:/Users/cogps/Downloads/Total Voters By County")

data.files = list.files()

library(readxl)
JanData<-read_excel("Total Voters by County and Party 1.22.xlsx", range = "A7:J24", col_names=TRUE)

# install.packages("gdata")
## installing Rtools
# https://www.rdocumentation.org/packages/installr/versions/0.23.2/topics/install.Rtools
# library(installr)
# #install.Rtools()
# 
# install.packages("rJava")
# library(rJava)
# # https://www.rdocumentation.org/packages/XLConnect/versions/1.0.5/topics/readWorksheetFromFile
# 
# require(devtools)
# install_version("XLConnect", version = "1.0.2", repos = "http://cran.us.r-project.org")
# 
# 
# library(XLConnect)
# 
# 
# 
# for (file in data.files[-1]) {
#   newFile = readWorksheetFromFile(file=file)
#   df = merge(df, newFile, all=TRUE)
# }

### Next try
## https://stackoverflow.com/questions/54013961/r-how-to-read-data-from-multiple-workbooks-having-multiple-worksheets-into-r

library(purrr)
library(readxl)
library(dplyr)
library(tidyr)

data_path <- "C:/Users/cogps/Downloads/Total Voters By County"

files <- dir(data_path, pattern = "*.xlsx")


weights_data <- data.frame(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ read_excel(file.path
                                          (data_path,  .))))

Un_Nested<-unnest(weights_data)
View(Un_Nested)


# library(tibble)
# library(dplyr)
# library(tidyr)
# library(purrr)
# library(readxl)
# 
# data_frame(
#   path = list.files(path = "C:/Users/cogps/Downloads/Total Voters By County/", pattern = "*.xlsx", full.names = TRUE)
# ) %>%
#   mutate(sheets = map(path, excel_sheets))
# 
# data_frame(
#   path = list.files(path = "C:/Users/cogps/Downloads/Total Voters By County/", pattern = "*.xlsx", full.names = TRUE)
# ) %>%
#   mutate(sheets = map(path, excel_sheets)) %>%
#   unnest(sheets)
# 
# 
# data_frame(
#   path = list.files(path = "C:/Users/cogps/Downloads/Total Voters By County/", pattern = "*.xlsx", full.names = TRUE)
# ) %>%
#   mutate(sheets = map(path, excel_sheets)) %>%
#   unnest(sheets) %>%
#   mutate(data = map2(path, sheets, ~ read_excel(path = .x, sheet = .y)))

## Now what I need to do is clean the data derived from the reading and merging
## of the data files
# https://datascience.stackexchange.com/questions/15589/remove-part-of-string-in-r


### 
# http://www.sthda.com/english/wiki/reading-data-from-excel-files-xls-xlsx-into-r
# install.packages("XLConnect")
# library(readxl)
# 
# JanData<-read_excel("Total Voters by County and Party 1.22.xlsx", range = "A7:J24", col_names=TRUE)
# View(JanData)
# names(JanData)

## delete additional ...8 column 
# https://statisticsglobe.com/r-remove-data-frame-columns-by-name

# JanData <- subset(JanData, select = - c(...8)) 
# 
# names(JanData)
# 
# View(JanData)


# plot(JanData$`County Name
# `, JanData$Democrat)


## turning from wide format into long format
## http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/

# library(tidyr)
# 
# View(JanData)
## It might be ideal to just keep it as wide
# 
# JanData_long <- gather(JanData, Party, Regis_Voters, Democrat:Republican, factor_key=TRUE)
# View(JanData_long)
# 
# write.csv(JanData_long, "C:/Users/cogps/Desktop/JanL_2022_Total_Voters_Long.csv", row.names=FALSE)


## add column title month, and another one for year
## https://statisticsglobe.com/add-column-to-data-frame-in-r

# JanData$month <- "January"   
# View(JanData)
# 
# JanData$Year <- "2022"

## Read data from February
# library(readxl)
# 
# FebData<-read_excel("Total Voters by County and Party 2.22.xlsx", range = "A7:J24", col_names=TRUE)
# 
# FebData <- subset(FebData, select = - c(...8)) 
# 
# names(FebData)
# 
# FebData$month <- "February"   
# View(FebData)
# 
# FebData$Year <- "2022"
# 
# View(FebData)
# 
# ## Jan 2021 Data
# 
# JanData_21<-read_excel("Total Voters by County and Party 1.21.xlsx", range = "A7:J24", col_names=TRUE)
# 
# JanData_21 <- subset(JanData_21, select = - c(...8)) 
# 
# names(JanData_21)
# 
# JanData_21$month <- "January"   
# View(JanData_21)
# 
# JanData_21$Year <- "2021"
# 
# View(JanData_21)
# 

# https://stackoverflow.com/questions/9704213/remove-part-of-a-string
## I want to create a loop that reads and merges xlsx files for they all seem to have the same
## pattern

names(Un_Nested)

levels(as.factor(Un_Nested$filename))
library(stringr)
library(tidyverse)

Clean_Data<-Un_Nested

Clean_Data$filename<-Clean_Data$filename %>% str_replace("Total Voters by County and Party ", "")
Clean_Data$filename<-Clean_Data$filename %>% str_replace(".xlsx", "")
Clean_Data$filename<-Clean_Data$filename %>% str_replace("Total Voters by COUNTY AND PARTY ", "")
#Clean_Data$filename<-Clean_Data$filename %>% str_replace("Total Voters BY COUNTY AND PARTY ", "")
levels(as.factor(Clean_Data$filename))

## Now I need to figure out how to create two split one string into two columns based on 
## a condition
# https://www.statology.org/split-column-in-r/
# https://datacornering.com/how-to-split-one-column-into-multiple-columns-in-r/

library(stringr)
library(tidyr)

# Test_Run_2<-Test_Run
# # Test_Run_2[c('Month', 'Year')] <- str_split_fixed(Test_Run$filename, '.', 2)
# # 
# # View(Test_Run)
# colmn <- c('Month', 'Year')

# Test_Run_2 <-
#   tidyr::separate(
#     data = Test_Run_2,
#     col = filename,
#     sep = ".",
#     into = colmn,
#     remove = FALSE
#   )
# 
# View(Test_Run_2)

# require(dplyr)
# require(tidyr)
# 
# 
# Test_Run_2 <- Test_Run_2 %>% separate(filename, sep = ".", into = colmn, remove = FALSE)
# View(Test_Run_2)

## Next Try
# Test_Run_2<-Test_Run
# https://www.delftstack.com/howto/r/separate-in-r/
library(tidyr)
library(dplyr)
library(stringr)

Clean_Data<-Clean_Data %>% separate(filename, c('Month', 'Year'))
View(Clean_Data)
# this worked

## Delete rows that have NA's in certain columns
# https://stackoverflow.com/questions/51596658/remove-rows-which-have-all-nas-in-certain-columns
# Test_Run_3<-Test_Run_2

names(Clean_Data)
View(Clean_Data)
library(tidyr)
Clean_Data<-Clean_Data[!apply(is.na(Clean_Data[,4:13]), 1, all),]
View(Clean_Data)


## delete rows that have missing values in the democrat columm [3]

# Test_Run_4<-Test_Run_3
# View(Clean_Data)
# Test_Run_4<-Test_Run_4[!apply(is.na(Test_Run_3[,3]), 1, all),]
# View(Test_Run_4)

## deleting COlumns
library(dplyr)
names(Clean_Data)
View(Clean_Data)

Clean_Data<-select(Clean_Data, -c(10, 13))

names(Clean_Data)

## Making the first row the column Names
# https://stackoverflow.com/questions/20956119/assign-headers-based-on-existing-row-in-dataframe-in-r


Clean_Data<-janitor::row_to_names(Clean_Data,1)
View(Clean_Data)

## Delete row if the column has "either or of these two values in there"County Name"
## https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
names(Clean_Data)
levels(as.factor(Clean_Data$`County Name\r\n`))

Clean_Data<-Clean_Data[!(Clean_Data$`County Name\r\n`=="County Name\r\n"| Clean_Data$`County Name\r\n`=="Total"),]
levels(as.factor(Clean_Data$`County Name\r\n`))
View(Clean_Data)
head(Clean_Data)


## Renaming COunty Name, Month and Year  
## https://www.statology.org/how-to-rename-data-frame-columns-in-r/

names(Clean_Data)[names(Clean_Data)=="County Name\r\n"] <- "County Name"
names(Clean_Data)

names(Clean_Data)[names(Clean_Data)=="1"] <- "Month"
names(Clean_Data)[names(Clean_Data)=="20"] <- "Year"
names(Clean_Data)


## Clean Month COlumn
## https://www.rdocumentation.org/packages/lubridate/versions/1.8.0/topics/month

library(lubridate)
levels(as.factor(Clean_Data$Month))
Clean_Data$Month<-month(as.numeric(Clean_Data$Month), label=TRUE, abbr = FALSE)
View(Clean_Data)

## Clean Year Column

year(as.numeric(Clean_Data$Year))
?year
Clean_Data$Year<-2000 + as.numeric(Clean_Data$Year)
View(Clean_Data)
## Creating CSV from clean data from 2020: 2022
write.csv(Clean_Data,"C:/Users/cogps/Desktop/VoterReg_By_County_20_to_22.csv", row.names =FALSE)
?write.csv
