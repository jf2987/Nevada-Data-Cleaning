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
#JanData<-read_excel("Total Voters by County and Party 1.22.xlsx", range = "A7:J24", col_names=TRUE)

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


#### Converting a pdf to  csv ####
## https://stackoverflow.com/questions/21646717/convert-pdf-to-csv-with-r
## https://github.com/expersso/pdftables
# https://stackoverflow.com/questions/18078303/scraping-large-pdf-tables-which-span-across-multiple-pages

system(paste('"C:/Program Files/Xpdf/pdftotext.exe"', '"C:/Documents and Settings/rM/Desktop/club.pdf"'), wait=FALSE)


convert_pdf('test/index.pdf', output_file = NULL, format = "xlsx-single", message = TRUE, api_key = "insert_API_key")


### https://medium.com/@ketanrd.009/how-to-extract-pdf-tables-in-r-e994c0fe4e28
#install.packages("remotes")
library(remotes)
# https://stackoverflow.com/questions/43884603/installing-tabulizer-package-in-r

remotes::install_github(c("ropensci/tabulizerjars", "ropensci/tabulizer"), INSTALL_opts = "--no-multiarch", dependencies = c("Depends", "Imports"))
# library(plyr)
# 
# packs <- c('stringi', 'httpuv', 'digest', 'htmltools', 'sourcetools', 'evaluate', 'markdown', 
#            'stringr', 'yaml', 'rJava', 'testthat')
# 
# laply(packs, function(x){
#   install.packages(x)  
#   readline(prompt="Press [enter] to continue")
# }
# )

library(tabulizer)
#library(tabulizerjars)
library(tidyverse)

# https://support.rstudio.com/hc/en-us/articles/200486138-Changing-R-versions-for-the-RStudio-Desktop-IDE

#install.packages("pdftools")
library(pdftools)
pdf<-pdf(file="January2017TotalVotersbyCO.pdf")
View(pdf)
gpi_table <- extract_tables(pdf,
                            output = "data.frame",
                            guess = FALSE)

## https://datascienceplus.com/extracting-tables-from-pdfs-in-r-using-the-tabulizer-package/
library(tabulizer)
library(dplyr)


## http://applied-r.com/extract-data-tables-from-pdf-files-in-r/
# Load Tabula functions
library(tabulizer)
library(tabulizerjars)
# Define path to PDF file
pdf.file <- "C:/Users/cogps/Downloads/January2017ActiveVotersbyA.pdf"

## locate area
# install.packages("miniUI")
library(miniUI)
f <- locate_areas(pdf.file)
#f
# 
gpi_table <- extract_tables(file=pdf.file,
                            output = "data.frame",
                            guess = TRUE)
View(gpi_table)

gpi_table_clean <- reduce(gpi_table, bind_rows)
View(gpi_table_clean)

# Extract data table
pdf.dat <- extract_tables(pdf.file)
View(pdf.dat)
# Coerce output matrix to data.frame
pdf.tbl <- data.frame(pdf.dat[[1]][-1, ])
names(pdf.tbl) <- pdf.dat[[1]][1, ]
# Display first 5 rows of data
head(pdf.tbl)
View(pdf.tbl)


## Different way to convert PDFS to CSV's 
## https://www.rdocumentation.org/packages/pdftables/versions/0.1/topics/convert_pdf
library(pdftables)
pdf.file <- "C:/Users/cogps/Downloads/January2017ActiveVotersbyA.pdf"

library(pdftools)
pdf<-pdf(file="January2017TotalVotersbyCO.pdf")
View(pdf)

convert_pdf(pdf.file,output_file = NULL, format = "csv", message = TRUE)


## Attempt 3 https://www.youtube.com/watch?v=kw67vMFSjEw
library(pdftools)
library(readr)
library(dplyr)
library(stringr)

bank1<-pdf_text("C:/Users/cogps/Downloads/January2017ActiveVotersbyA.pdf") %>%
  read_lines()

bank2<-bank1[2:17]%>%
  str_squish()%>%
  strsplit(split=" ")

bank3<-ldply(bank2)
View(bank2)


## Attempt 4
## https://www.youtube.com/watch?v=DhY3V4LCdps


## Apparently I am not the only one having issues with teh Tabulizer package
## https://community.rstudio.com/t/rstudio-crashing-with-tabulizer-need-to-install-the-legacy-java-se-6-runtime/87937/3
## https://stackoverflow.com/questions/72033264/rstudio-fatal-error-when-loading-tabulizer



## Forgetting PDF Files for now and Cleaning the CSV's

## https://stackoverflow.com/questions/54013961/r-how-to-read-data-from-multiple-workbooks-having-multiple-worksheets-into-r


#### Cleaning AD XLSX Files in Bilk ####

library(purrr)
library(readxl)
library(dplyr)
library(tidyr)

data_path <- "C:/Users/cogps/Downloads/Assembly District 2018_2022"

files <- dir(data_path, pattern = "*.xlsx")


weights_data <- data.frame(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ read_excel(file.path
                                          (data_path,  .))))

Un_Nested<-unnest(weights_data)
View(Un_Nested)
## the name of the files in that folder are repeating rows in the Un_Nested file 
dim(Un_Nested)
# 4126 rows and 33 columns

names(Un_Nested)

## I need to figure out a way to delete colummns that have county names
## in "...2"
levels(as.factor(Un_Nested$"...2"))

# "Carson City" "Churchill"   "Clark"       "Douglas"    
# "Elko"        "Esmeralda"   "Eureka"      "Humboldt"    "Lander"     
# "Lincoln"     "Lyon"        "Mineral"     "Nye"         "Pershing"   
# "Storey"      "Total"       "Washoe"      "White Pine"
# https://stackoverflow.com/questions/15294573/deleting-a-row-in-r-based-on-value-in-column
#https://stackoverflow.com/questions/46652012/subsetting-data-by-multiple-values-in-multiple-variables-in-r
?subset

View(Un_Nested[Un_Nested$"...2" %in% c("Carson City", "Churchill", "Clark","Douglas",
  "Elko","Esmeralda","Eureka","Humboldt","Lander","Lincoln","Lyon","Mineral","Nye",         
"Pershing","Storey","Total","Washoe","White Pine"), ])

excluded<-Un_Nested[Un_Nested$"...2" %in% c("Carson City", "Churchill", "Clark","Douglas",
                                            "Elko","Esmeralda","Eureka","Humboldt","Lander","Lincoln","Lyon","Mineral","Nye",         
                                            "Pershing","Storey","Total","Washoe","White Pine"), ]
dim(excluded)
## deleting 1251 rows 

dim(Un_Nested)
## 4217

4217-1251
## I should be left with 2966
# https://www.tutorialspoint.com/how-to-subset-rows-that-do-not-contain-na-and-blank-in-one-of-the-columns-in-an-r-data-frame


Un_Nested<-Un_Nested[!(Un_Nested$"...2" %in% c("Carson City", "Churchill", "Clark","Douglas",
                                            "Elko","Esmeralda","Eureka","Humboldt","Lander","Lincoln","Lyon","Mineral","Nye",         
                                            "Pershing","Storey","Total","Washoe","White Pine")), ]

dim(Un_Nested)
## 2966
### WORKED

## Deleting from main data set 
View(Un_Nested)



## Delete rows that which have all columns empty
## https://www.r-bloggers.com/2021/06/remove-rows-that-contain-all-na-or-certain-columns-in-r/
## https://stackoverflow.com/questions/51596658/remove-rows-which-have-all-nas-in-certain-columns
## https://www.r-bloggers.com/2021/06/remove-rows-that-contain-all-na-or-certain-columns-in-r/
dim(Un_Nested) # 2966 rows 33 columns
Un_Nested<-Un_Nested[!apply(is.na(Un_Nested[,1:33]), 1, all),]
dim(Un_Nested) # 2966 rows 33 columns

## Replacing Unecessary characters from the File Names
names(Un_Nested)

levels(as.factor(Un_Nested$filename))
library(stringr)
library(tidyverse)

Clean_Data<-Un_Nested

levels(as.factor(Clean_Data$filename))
Clean_Data$filename<-Clean_Data$filename %>% str_replace(".xlsx", "")
levels(as.factor(Clean_Data$filename))
Clean_Data$filename<-Clean_Data$filename %>% str_replace("Active Voters Voter Registration by ASSEMBLY DISTRICT ", "")
levels(as.factor(Clean_Data$filename))
View(Clean_Data)

## I need to make sure that the files are named in an easily cleanble way
levels(as.factor(Clean_Data$filename))
 ## get rid of "Active Voters by Assembly District
levels(as.factor(Clean_Data$filename))
Clean_Data$filename<-Clean_Data$filename %>% str_replace("Active Voters by Assembly District", "")
levels(as.factor(Clean_Data$filename))
## https://www.statology.org/replace-values-in-data-frame-r/
## Clean
## https://www.statology.org/subset-data-frame-in-r/
levels(as.factor(Clean_Data$filename))
sub_S<-subset(Clean_Data, filename == "Active Voters Voter Registration by ASSEMBLY DISTRICT")
View(sub_S)
## this data set is from December 2018 -- it was also hyper linked in the 
## government web cite to its correct month and year

## replace that value with its year and month
## "Active Voters Voter Registration by ASSEMBLY DISTRICT"
Clean_Data[Clean_Data == "Active Voters Voter Registration by ASSEMBLY DISTRICT"] <- "12.18"
levels(as.factor(Clean_Data$filename))

## Apparently there is another csv file with 12.18 in it
## 12.18 Voter Registration by ASSEMBLY DISTRICT
View(subset(Clean_Data, filename == "12.18 Voter Registration by ASSEMBLY DISTRICT"))
## this is actually January 2019

Clean_Data[Clean_Data == "12.18 Voter Registration by ASSEMBLY DISTRICT"] <- "1.19"
levels(as.factor(Clean_Data$filename))

## But apparently tehre is already another file from Jan 19 "1.2019"
## this one was derived from the correct year and month in the govt web cite
View(subset(Clean_Data, filename == "1.2019"))
## this one has higher numbers per cell than the previous one. 

## This files columns are all over the place-- they are like 12 columns to the right

sub_T<-subset(Clean_Data, filename == "1.19")
View(sub_T)

## I will figure that out later-- I need to keep cleaning the file name column
# Active Voters BY ASSEMBLY DISTRICT# this one does not have a date or month-- I need to
## figure out why that is the case

View(subset(Clean_Data, filename == "Active Voters BY ASSEMBLY DISTRICT"))
## this one is June 2019
## I will rename it to 6.19

Clean_Data[Clean_Data == "Active Voters BY ASSEMBLY DISTRICT"] <- "6.19_2"

levels(as.factor(Clean_Data$filename))
## Clean
## "Active Voters by ASSEMBLY DISTRICT"

Clean_Data$filename<-Clean_Data$filename %>% str_replace("Active Voters by ASSEMBLY DISTRICT", "")

levels(as.factor(Clean_Data$filename))

## Clean
## Active Voters BY ASSEMBLY DISTRICT
Clean_Data$filename<-Clean_Data$filename %>% str_replace("Active Voters BY ASSEMBLY DISTRICT", "")

levels(as.factor(Clean_Data$filename))

## I need to figure out what day and Month this file is 
# Copy of Active Voters Voter Registration by ASSEMBLY DISTRICT

View(subset(Clean_Data, filename == "Copy of Active Voters Voter Registration by ASSEMBLY DISTRICT"))
## this one is April 2019
## I will rename it to 4.19
levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "Copy of Active Voters Voter Registration by ASSEMBLY DISTRICT"] <- "4.19"

levels(as.factor(Clean_Data$filename))


## Same for this one
## March Active Voters BY ASSEMBLY

View(subset(Clean_Data, filename == "March Active Voters BY ASSEMBLY"))

## this one is March 2019
## I will rename it to 3.19
levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "March Active Voters BY ASSEMBLY"] <- "3.19"

levels(as.factor(Clean_Data$filename))

## Clean this one
## Voter Registration by ASSEMBLY DISTRICT Jan.18
View(subset(Clean_Data, filename == "Voter Registration by ASSEMBLY DISTRICT Jan.18"))
## this one is actually Feb 2018


## I will rename it to 2.18_
## although there is technically already a 2.18 file there

levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "Voter Registration by ASSEMBLY DISTRICT Jan.18"] <- "2.18_2"

levels(as.factor(Clean_Data$filename))

## Now I need to view the data 
View(Clean_Data)

## Name Cleaning
library(stringr)
Clean_Data$filename<-Clean_Data$filename %>% str_replace("Active Voters  ASSEMBLY DISTRICT", "")
levels(as.factor(Clean_Data$filename))

## replacing any space with no space 

Clean_Data$filename<-Clean_Data$filename %>% str_replace(" ", "")
levels(as.factor(Clean_Data$filename))




## Remove rows with empty cells from column 2 to column 33
dim(Clean_Data) # 2966
Clean_Data<-Clean_Data[!apply(is.na(Clean_Data[,2:33]), 1, all),]
dim(Clean_Data) # 2576 left

View(Clean_Data)

## Now if column 3 to column 33 is empty

dim(Clean_Data) # 2576
Clean_Data<-Clean_Data[!apply(is.na(Clean_Data[,3:33]), 1, all),]
dim(Clean_Data) # 2292 left

View(Clean_Data)


## I need to remove the below rows 
# https://www.statology.org/remove-rows-in-r/
# View(Clean_Data[45:75,])
# Clean_Data<-Clean_Data[-c(45:75),]
# View(Clean_Data[45:75,])

## what is the NA percentage per column 
## https://stackoverflow.com/questions/33512837/calculate-using-dplyr-percentage-of-nas-in-each-column
## well, now i know the map function is in the purrr library
library(purrr)
Clean_Data %>% map(~ mean(is.na(.)))

## most of the columns to the right are NA-- they have like 96 percent missingness
## now i need to choose a column of choice from the lot
## then I see if there are any patterns in the values that are within 
## the mostly empty columns 
# https://stackoverflow.com/questions/7980622/subset-of-rows-containing-na-missing-values-in-a-chosen-column-of-a-data-frame
names(Clean_Data)
dim(Clean_Data)
## 2292
dim(dplyr::filter(Clean_Data,is.na(Democrat)))
## 2206

## I need to do the same but for values that which is NOT NA
## https://www.statology.org/r-is-not-na/
View(Clean_Data[!(is.na(Clean_Data$Democrat)), ])
dim(Clean_Data[!(is.na(Clean_Data$Democrat)), ])
## there are 86 rows that which are messing this up then

## I might need to separate the data based on the previous conditions, clean them 
## and then add rows 
Clean<-dplyr::filter(Clean_Data,is.na(Democrat))
Dirty<-Clean_Data[!(is.na(Clean_Data$Democrat)), ]


View (Clean)
dim(Clean)

## Delete empty columns 
## https://www.codingprof.com/3-easy-ways-to-remove-empty-columns-in-r/
library(tidyverse)
dim(Clean)
## 33 columns
library(purrr)
Clean<-Clean %>% discard(~all(is.na(.) | . ==""))
dim(Clean)
## 22 columns 
View(Clean)
## 10.18 has a pattern

#5:53pm 6:01pm

## if ..2 is empty then move the contents from columm3:5 one space to the left
## test run
Copy<-Clean
names(Copy)
## https://datacornering.com/ifelse-and-na-problem-in-r/
# https://stackoverflow.com/questions/34071875/replace-a-value-na-with-the-value-from-another-column-in-r
Copy$"...2" <- ifelse(is.na(Copy$"...2"), Copy$"...3", Copy$"...2")
View(Copy)
## if ..2 --- ..3 then NA, else ..3
Copy$"...3" <- ifelse(Copy$"...2"==Copy$"...3",NA, Copy$"...3")
View(Copy)

## if ...3 is NA then ...5, else.. ..3
Copy$"...3" <- ifelse(is.na(Copy$"...3"), Copy$"...5", Copy$"...3")
View(Copy)
## Now if ...3 and 
Copy$"...5" <- ifelse(Copy$"...3"==Copy$"...5",NA, Copy$"...5")
View(Copy)

## if .4 is empty then make it ...7 else keep it ...4
Copy$"...4" <- ifelse(is.na(Copy$"...4"), Copy$"...7", Copy$"...4")
View(Copy)

## if ...4 and ...7 are equal, then delete ...7 else ...7
Copy$"...7" <- ifelse(Copy$"...4"==Copy$"...7",NA, Copy$"...7")
View(Copy)

### if ...5 is empty then ..9 else ...5
Copy$"...5" <- ifelse(is.na(Copy$"...5"), Copy$"...9", Copy$"...5")
View(Copy)

## if .5 and .9 are the same, then delete .9 else keep .9

Copy$"...9" <- ifelse(Copy$"...5"==Copy$"...9",NA, Copy$"...9")
View(Copy)

## if ...6 is NA then ...11 else ...6

Copy$"...6" <- ifelse(is.na(Copy$"...6"), Copy$"...11", Copy$"...6")
View(Copy)

## if ...11 is the same as ...6 then NA, else ....11

Copy$"...11" <- ifelse(Copy$"...6"==Copy$"...11",NA, Copy$"...11")
View(Copy)

## if ...7 is NA then ...14 else ...7
Copy$"...7" <- ifelse(is.na(Copy$"...7"), Copy$"...14", Copy$"...7")
View(Copy)

## if 14 and 7 match then delete 14 else keep 14

Copy$"...14" <- ifelse(Copy$"...7"==Copy$"...14",NA, Copy$"...14")
View(Copy)

## if 8 is NA then 16 else 8
Copy$"...8" <- ifelse(is.na(Copy$"...8"), Copy$"...16", Copy$"...8")
View(Copy)
## if 8 and 16 are the same then delete 16 else 16
Copy$"...16" <- ifelse(Copy$"...8"==Copy$"...16",NA, Copy$"...16")
View(Copy)


## if 9 is NA then 18 else 9
Copy$"...9" <- ifelse(is.na(Copy$"...9"), Copy$"...18", Copy$"...9")
View(Copy)
## if 9 and 18 are the same then delete 18 else 18
Copy$"...18" <- ifelse(Copy$"...9"==Copy$"...18",NA, Copy$"...18")
View(Copy)

## if 10 is NA then 21 else 10
Copy$"...10" <- ifelse(is.na(Copy$"...10"), Copy$"...21", Copy$"...10")
View(Copy)

## if 10 and 21 are the same then delete 21 else 21
Copy$"...21" <- ifelse(Copy$"...10"==Copy$"...21",NA, Copy$"...21")
View(Copy)


## Delete all empty columns
## https://www.codingprof.com/3-easy-ways-to-remove-empty-columns-in-r/
library(tidyverse)
dim(Copy)
## 22 columns
library(purrr)
Copy<-Copy %>% discard(~all(is.na(.) | . ==""))
dim(Copy)
## 18 columns 
View(Copy)


# 2.2019 is in an odd format4.19 too 3.19 too 

## I need to look at the columsn wherein ...11 is not NA-- these are the ones
## that are messed up
## I also need to remember to clean the dirty subset and to join it with the "Clean"
## more like add it to the clean


## # 2.2019 is in an odd format4.19 too 3.19 too  
## subset based on condition to view patterns
View(subset(Copy, filename == "2.2019"))
## if 2.2019 and ...9 is NA, then ...10 else ...9
##
Test<-Copy
Test$"...9" <- ifelse(is.na(Test$"...9")& Test$"filename"=="2.2019", Test$"...10", Test$"...9")
View(Copy)
View(subset(Test, filename == "2.2019"))

## if 2.2019 and 9 is equal to 10 then NA else 10
Test$"...10" <- ifelse(Test$"filename"=="2.2019" & Test$"...10"==Test$"...9",NA, Test$"...10")
View(Test)
View(subset(Test, filename == "2.2019"))

## so if file name is 2.2019 and 10 is NA, then 11, else 10
Test$"...10" <- ifelse(is.na(Test$"...10")& Test$"filename"=="2.2019", Test$"...11", Test$"...10")
View(subset(Test, filename == "2.2019"))
## if 10 and 11 are the same and file name is 2.2019, then NA else 11. 
Test$"...11" <- ifelse(Test$"filename"=="2.2019" & Test$"...10"==Test$"...11",NA, Test$"...11")
View(Test)
View(subset(Test, filename == "2.2019"))

## okay, now I need to look at the hiccups related to the other year and month
## 4.19 too 3.19 too
View(subset(Test, filename == "4.19"))

## if the file name is 4.19 and 9 is NA then 10 else 9-- this one literally has 
## the same patter as 2/2019-- i could have added an or statement with the 
## stuff I coded above and saved myself lines of code
View(subset(Test, filename == "3.19"))
## the same pattern occurs for 3.19 as well--
## so, i am going to try to clean them both at the same time
View(subset(Test, filename == "3.19"|filename == "4.19"))

## if the file name is 4.19 or 3.19 and 9 is NA then 10 else 9-- this one literally has 
Test$"...9" <- ifelse(is.na(Test$"...9")& Test$"filename"=="3.19"|Test$filename == "4.19", Test$"...10", Test$"...9")
View(subset(Test, filename == "3.19"|filename == "4.19"))
### if file name is 3.19 or 4.19 and 10 is equal to 9 then delete 10, else 10
Test$"...10" <- ifelse(Test$"filename"=="3.19"|Test$filename == "4.19" & Test$"...10"==Test$"...9",NA, Test$"...10")
View(subset(Test, filename == "3.19"|filename == "4.19"))

## if filename is 3.19 or 4.19 and  10 is NA then 11 else 11
Test$"...10" <- ifelse(is.na(Test$"...10")& Test$"filename"=="3.19"|Test$filename == "4.19", Test$"...11", Test$"...10")
View(subset(Test, filename == "3.19"|filename == "4.19"))

## if file name is 3.19 or 4.19 and 10 and 11 are the same delte 11 else 11
Test$"...11" <- ifelse(Test$"filename"=="3.19"|Test$filename == "4.19" & Test$"...10"==Test$"...11",NA, Test$"...11")
View(subset(Test, filename == "3.19"|filename == "4.19"))


## 
View(Test)
## I haven't even clean the dirty subset

## Delete ...11 onwards 12:18
#https://www.statology.org/remove-columns-in-r/
names(Test)
library(dplyr)

Test<-Test %>% select(-(12:18))
dim(Test)
## 11 columns
names(Test)
## Make the first Row the Column Names
# https://stackoverflow.com/questions/20956119/assign-headers-based-on-existing-row-in-dataframe-in-r

library(janitor)
Clean_Data<-janitor::row_to_names(Test,1)
View(Clean_Data)

## Rename first two columsn 
## https://www.statology.org/how-to-rename-data-frame-columns-in-r/
names(Clean_Data)
names(Clean_Data)[names(Clean_Data)=="08.2018"] <- "Month_Year"
names(Clean_Data)

names(Clean_Data)
names(Clean_Data)[names(Clean_Data)=="County Name\r\n"] <- "Assembly_District"
names(Clean_Data)

## delete Total Column 11
library(dplyr)

Clean_Data<-Clean_Data %>% select(-(11))
dim(Clean_Data)

names(Clean_Data)


## Now, focus on Cleaning Dirty data
View(Dirty)
dim(Dirty)
## 86 rows 33 columns
## Delete empty Columns
## https://www.codingprof.com/3-easy-ways-to-remove-empty-columns-in-r/
library(tidyverse)
dim(Dirty)
## 33 columns
library(purrr)
Dirty<-Dirty %>% discard(~all(is.na(.) | . ==""))
dim(Dirty)
## 11 columns 
View(Dirty)

# delete column 11
library(dplyr)
names(Dirty)
Dirty<-Dirty %>% select(-(11))
names(Dirty)
names(Clean_Data)

## Rename the first two columns as 
#"Month_Year" and "Assembly_District" respectively 
names(Dirty)
names(Dirty)[names(Dirty)=="filename"] <- "Month_Year"
names(Dirty)

names(Dirty)
names(Dirty)[names(Dirty)=="County Name\r\n"] <- "Assembly_District"
names(Dirty)


## add rows from Dirty and Clean_Data together for a final product
library(dplyr)
names(Clean_Data)
## 2205 rows
names(Dirty)
## 86
Final<-bind_rows(Clean_Data,Dirty) 
## Error in `bind_rows()`:
# ! Can't combine `..1$Democrat` <character> and `..2$Democrat` <double>.
# Run `rlang::last_error()` to see where the error occurred

## It's struggling to combine them because there are 
## strings still present in the Clean_Data file
## the columns need to be the same type if they will be 
## added as rows

# Delete rows based on condition from Clean_Data
View(Clean_Data)
# if Assembly District is "Total" or "County Name" delete row
## https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
dim(Clean_Data)
## currently 2205 riws 
Clean_Data_1<-Clean_Data
dim(Clean_Data_1)
## 2205
levels(as.factor(Clean_Data_1$Assembly_District))
Clean_Data_1<-Clean_Data_1[!(Clean_Data_1$Assembly_District=="Total" | Clean_Data_1$Assembly_District=="County Name\n"|Clean_Data_1$Assembly_District=="County Name\r\n"),]
dim(Clean_Data_1)
## 2024
View(Clean_Data_1)
## They are still being read as characters-- but let me see if I can joing them now
library(dplyr)
dim(Clean_Data_1)
## 2024 rows
dim(Dirty)
## 86
Final<-bind_rows(Clean_Data_1,Dirty) 
## it doesn't work-- things need to be the same type
## https://statisticsglobe.com/convert-data-frame-column-to-numeric-in-r
sapply(Clean_Data_1, class)  
sapply(Dirty, class)
## making range of columsn numeric in R 3:10
names(Clean_Data_1)
i<-c(3:10)
Clean_Data_2<-Clean_Data_1
Clean_Data_2[ , i] <- apply(Clean_Data_2[ , i], 2,            # Specify own function within apply
                    function(x) as.numeric(as.character(x)))
sapply(Clean_Data_2, class)
## it worked

library(dplyr)
dim(Clean_Data_2)
## 2024 rows
dim(Dirty)
## 86
Final<-bind_rows(Clean_Data_2,Dirty) 
dim(Final)
##2110
2024+86
# 2110
View(Final)

## Now i Need to figure out what to do with the dates that have doubles 
levels(as.factor(Final$Month_Year))

# "6.19" "6.19_2"
## https://www.statology.org/subset-data-frame-in-r/
levels(as.factor(Final$Month_Year))
View(subset(Final, Month_Year == "6.19"))
View(subset(Final, Month_Year == "6.19_2"))
## the one with _2 has lower values so -- it should be delete
levels(as.factor(Final$Month_Year))
dim(Final)
##2110
dim(subset(Final, Month_Year == "6.19_2"))
## 42
2110-42
## we should get 2068

Final<-Final[!(Final$Month_Year=="6.19_2"),]
dim(Final)
## we do 
## 2068

levels(as.factor(Final$Month_Year))


## now we got to clean 
## "2.18"    "2.18_2"
View(subset(Final, Month_Year == "2.18"))
View(subset(Final, Month_Year == "2.18_2"))
## the one with the _2 has less-- so it will be deleted
dim(subset(Final, Month_Year == "2.18_2"))
##42 
dim(Final)
## 2068
2068-42
## we should end up with 2026
Final<-Final[!(Final$Month_Year=="2.18_2"),]
dim(Final)
## we do 

levels(as.factor(Final$Month_Year))

## "1.19" "1.2019"
View(subset(Final, Month_Year == "1.19"))
View(subset(Final, Month_Year == "1.2019"))

## 1.19 has less so it will be deleted
dim(subset(Final, Month_Year == "1.19"))
## 42
dim(Final)
# 2026
2026-42
## we should be left with 1984
Final<-Final[!(Final$Month_Year=="1.19"),]
dim(Final)
## we are 
levels(as.factor(Final$Month_Year))


## replacing 08.2018 with 8.18
## weitf, I just noticed that there is no column name for the above line of code

Final[Final == "08.2018"] <- "8.18"
levels(as.factor(Final$Month_Year))
## i will replace 1.2019 with 1.19
Final[Final == "1.2019"] <- "1.19"
levels(as.factor(Final$Month_Year))
## i will replace 2.2019 with 2.19
Final[Final == "2.2019"] <- "2.19"
levels(as.factor(Final$Month_Year))
## they still have the "Total" value in the Assembly_District Column
## I need to delete it 

## nOw explore how many rows are within each level
## this will help me identify double ups
table(Final$Month_Year)
## all have 42 except 4.19 which for some reason has 43
View(subset(Final, Month_Year == "1.19"))
levels(as.factor(Final$Assembly_District))
#"Total"
dim(Final)
# 1984
Final<-Final[!(Final$Assembly_District=="Total"),]
dim(Final)
## 1982
table(Final$Month_Year)
## they all have 42 per month and year

## 
View(Final)

## Split the Month and Year Column into separate columns
# https://www.delftstack.com/howto/r/separate-in-r/
library(tidyr)
library(dplyr)
library(stringr)
Final_C<-Final
names(Final_C)
Final<-Final %>% separate(Month_Year, c('Month', 'Year'))
View(Final)

## now I need to add 2000 to the year 

Final$Year<-2000 + as.numeric(Final$Year)
View(Final)

## ## Clean Month COlumn
## https://www.rdocumentation.org/packages/lubridate/versions/1.8.0/topics/month

library(lubridate)
levels(as.factor(Final$Month))
Final$Month<-month(as.numeric(Final$Month), label=TRUE, abbr = FALSE)
View(Final)

## Delete Assembly District extra wordings 
library(stringr)
library(tidyverse)
names(Final)

levels(as.factor(Final$Assembly_District))
Final_1<-Final
Final$Assembly_District<-Final$Assembly_District %>% str_replace("Assembly Dist. ", "")
View(Final)
