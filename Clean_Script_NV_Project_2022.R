## Clean Script for Nevada Voter registration data
## 2018-2022

# data_path <- "C:/Users/cogps/Downloads/Assembly District 2018_2022"
data_path <- "C:/Users/cogps/Downloads/ReDo"


files <- dir(data_path, pattern = "*.xlsx")
View(files)
## i need to make sure it also picks up CSV's

weights_data <- data.frame(filename = files) %>%
  mutate(file_contents = map(filename,
                             ~ read_excel(file.path
                                          (data_path,  .))))

Un_Nested<-unnest(weights_data)
View(Un_Nested)
levels(as.factor(Un_Nested$filename))
## the name of the files in that folder are repeating rows in the Un_Nested file 
## it did not pick up the CSV
dim(Un_Nested)
# 4126 rows and 33 columns
### Now with the new folder-- unlinke the old folder--
## we have 4403 rows

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
## second round 1281
dim(Un_Nested)
## 4217
## second round 4403
4217-1251
4403-1281
## I should be left with 2966
## second round, i should be left with 3122
# https://www.tutorialspoint.com/how-to-subset-rows-that-do-not-contain-na-and-blank-in-one-of-the-columns-in-an-r-data-frame


Un_Nested<-Un_Nested[!(Un_Nested$"...2" %in% c("Carson City", "Churchill", "Clark","Douglas",
                                               "Elko","Esmeralda","Eureka","Humboldt","Lander","Lincoln","Lyon","Mineral","Nye",         
                                               "Pershing","Storey","Total","Washoe","White Pine")), ]

dim(Un_Nested)
## 2966
### WORKED
## 3122
## Worked

## Deleting from main data set 
View(Un_Nested)



## Delete rows that which have all columns empty
## https://www.r-bloggers.com/2021/06/remove-rows-that-contain-all-na-or-certain-columns-in-r/
## https://stackoverflow.com/questions/51596658/remove-rows-which-have-all-nas-in-certain-columns
## https://www.r-bloggers.com/2021/06/remove-rows-that-contain-all-na-or-certain-columns-in-r/
dim(Un_Nested) # 2966 rows 33 columns
## 3122, 41 columns
#Un_Nested<-Un_Nested[!apply(is.na(Un_Nested[,1:33]), 1, all),]
Un_Nested<-Un_Nested[!apply(is.na(Un_Nested[,2:41]), 1, all),]
dim(Un_Nested) # 2966 rows 33 columns
## 2720 after deletion of empty rows from the second column onwards
## this is from the 3122 that were left before this argument

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
## But in my excel file-- this is actually November 2018

## replace that value with its year and month
## "Active Voters Voter Registration by ASSEMBLY DISTRICT"
levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "Active Voters Voter Registration by ASSEMBLY DISTRICT"] <- "11.18"
levels(as.factor(Clean_Data$filename))

## Apparently there is another csv file with 12.18 in it
## 12.18 Voter Registration by ASSEMBLY DISTRICT
View(subset(Clean_Data, filename == "12.18 Voter Registration by ASSEMBLY DISTRICT"))
## this is actually January 2019 ## but in the file I put together
## this is actually the corrupted excel file
## and it is in fact 12.18-- despite the future date within
## the xcel file

Clean_Data[Clean_Data == "12.18 Voter Registration by ASSEMBLY DISTRICT"] <- "12.18"
levels(as.factor(Clean_Data$filename))

## But apparently tehre is already another file from Jan 19 "1.2019"
## this one was derived from the correct year and month in the govt web cite
View(subset(Clean_Data, filename == "1.2019"))


## I need to rename this one 1.19

Clean_Data[Clean_Data == "1.2019"] <- "1.19"


View(subset(Clean_Data, filename == "Active Voters BY ASSEMBLY DISTRICT"))
## this one is June 2019 in the file
## but May 19 in the govt. webcite
levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "Active Voters BY ASSEMBLY DISTRICT"] <- "5.19"

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
## this one is April 19th -- 4.19

View(subset(Clean_Data, filename == "Copy of Active Voters Voter Registration by ASSEMBLY DISTRICT"))
## this one is April 2019
## I will rename it to 4.19
levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "Copy of Active Voters Voter Registration by ASSEMBLY DISTRICT"] <- "4.19"

levels(as.factor(Clean_Data$filename))


## Same for this one
## March Active Voters BY ASSEMBLY
## in the govt web cite this is March 19th

View(subset(Clean_Data, filename == "March Active Voters BY ASSEMBLY"))

## this one is March 2019
## I will rename it to 3.19
levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "March Active Voters BY ASSEMBLY"] <- "3.19"

levels(as.factor(Clean_Data$filename))

## Clean this one
## Voter Registration by ASSEMBLY DISTRICT Jan.18
## this one is 1.18 in the  govt webcite despite it 
## being feb 18 in the file
## so i will go for the govt. web cite def. 
View(subset(Clean_Data, filename == "Voter Registration by ASSEMBLY DISTRICT Jan.18"))



## I will rename it to 1.18

levels(as.factor(Clean_Data$filename))
Clean_Data[Clean_Data == "Voter Registration by ASSEMBLY DISTRICT Jan.18"] <- "1.18"

levels(as.factor(Clean_Data$filename))

## Now I need to view the data 
View(Clean_Data)

## Name Cleaning
library(stringr)
Clean_Data$filename<-Clean_Data$filename %>% str_replace("Active Voters  ASSEMBLY DISTRICT", "")
levels(as.factor(Clean_Data$filename))

## renaming this one 
## 12.18 Voter Registration by ASSEMBLY DISTRICT (1)
## this one is 12.18
Clean_Data[Clean_Data == "12.18 Voter Registration by ASSEMBLY DISTRICT (1)"] <- "12.18"
levels(as.factor(Clean_Data$filename))
## replacing any space with no space 

## 1.22 (1)
## this one is 2.22
Clean_Data[Clean_Data == " 1.22 (1)"] <- "2.22"
levels(as.factor(Clean_Data$filename))


# 2.2019 
## this one is 2.19
Clean_Data[Clean_Data == "2.2019 "] <- "2.19"
levels(as.factor(Clean_Data$filename))

# 08.2018 
## this one is 08.18
Clean_Data[Clean_Data == "08.2018 "] <- "8.18"
levels(as.factor(Clean_Data$filename))


## 1018CloseActiveVotersBYNEV_CSV
## this one is 10.18
Clean_Data[Clean_Data == "1018CloseActiveVotersBYNEV_CSV"] <- "10.18"
levels(as.factor(Clean_Data$filename))

## replace empty spaces
Clean_Data$filename<-Clean_Data$filename %>% str_replace(" ", "")
levels(as.factor(Clean_Data$filename))


## Remove rows with empty cells from column 2 to column 33
dim(Clean_Data) # 2966
## 2720

## there is still missing data
# [1] "1.18"  "1.19"  "1.20"  "1.21"  "1.22"  "10.18" "10.19"
# [8] "10.20" "10.21" "11.18" "11.19" "11.20" "11.21" "12.18"
# [15] "12.19" "12.20" "12.21" "2.18"  "2.19"  "2.20"  "2.21" 
# [22] "2.22"  "3.18"  "3.19"  "3.20"  "3.21"  "3.22"  "4.18" 
# [29] "4.19"  "4.20"  "4.21"  "4.22"  "5.18"  "5.19"  "5.20" 
# [36] "5.21"  "6.18"  "6.19"  "6.20"  "6.21"  "7.18"  "7.19" 
# [43] "7.20"  "7.21"  "8.18"  "8.19"  "8.20"  "8.21"  "9.19" 
# [50] "9.20"  "9.21"
## i am missing 9.18
## in the downloaded file this one is named
## 10.18 Active Voters by ASSEMBLY DISTRICT
## so it is likely this one was collapsed in the 10.18 month

## if that is the case, there should be twice as many rows in that
## subset
View(subset(Clean_Data, filename == "10.18"))
## there are twice as many rows 
## so, this one needs to be cleaned immediately-- before i start deleting
## 10.18 Active Voters by ASSEMBLY DISTRICT
## strong patterns

## I mean, I could also just clean it here-- for there is a clear
## pattern too

#Test<-Clean_Data
#### if filename 10.18 and 3 is not NA, then filename is 9.18 else 10.18 ####
Clean_Data$filename <- ifelse(!is.na(Clean_Data$"...3")& Clean_Data$filename=="10.18", "9.18", Clean_Data$filename)
View(subset(Clean_Data, filename == "10.18"))
View(subset(Clean_Data, filename == "9.18"))

## the format for 10.18 data is a bit odd-- so I will have to 
## clean that one later

dim(Clean_Data)
Clean_Data<-Clean_Data[!apply(is.na(Clean_Data[,2:41]), 1, all),]
dim(Clean_Data) # 2576 left
# 2720 remaining

View(Clean_Data)

## Now if column 3 to column 33 is empty

dim(Clean_Data) # 2576
## 2720
Clean_Data<-Clean_Data[!apply(is.na(Clean_Data[,3:41]), 1, all),]
dim(Clean_Data) # 2292 left
# 2428
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
## they are the ones with filen name is equal to 1.19 and 7.18

#### I might need to separate the data based on the previous conditions, clean them ####
## and then add rows 

# Clean_Data$filename <- ifelse(!is.na(Clean_Data$"...3")& Clean_Data$filename=="10.18", "9.18", Clean_Data$filename)

## I need to take them out, clean them, and then put them back in 

## count of rows in dirty subset 
dim(Clean_Data[!(is.na(Clean_Data$Democrat)), ])
## 86
dim(Clean_Data[(is.na(Clean_Data$Democrat)), ])
## count of rows not in dirty
## 2342
dim(dplyr::filter(Clean_Data,is.na(Democrat)))
## 2342

Clean<-dplyr::filter(Clean_Data,is.na(Democrat))
dim(Clean)
# 2342
Dirty<-Clean_Data[!(is.na(Clean_Data$Democrat)), ]
dim(Dirty)
# 86

#### Delete empty columns for Dirty###
names(Dirty)

library(tidyverse)
dim(Dirty)
## 41 columns
library(purrr)
Dirty<-Dirty %>% discard(~all(is.na(.) | . ==""))
dim(Dirty)
## 11 columns left 

View(Dirty)

names(Clean)
names(Dirty)

## I will add the rows of Dirty once I have cleaned the Clean 
## subset 

## Delete empty columns 
## https://www.codingprof.com/3-easy-ways-to-remove-empty-columns-in-r/
library(tidyverse)
dim(Clean)
## 41 columns
library(purrr)
Clean<-Clean %>% discard(~all(is.na(.) | . ==""))
dim(Clean)
## 30 columns 
View(Clean)
## 10.18 has a pattern


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
## 30 columns
library(purrr)
Copy<-Copy %>% discard(~all(is.na(.) | . ==""))
dim(Copy)
## 26 columns 
View(Copy)
View(Dirty)


## View if ...11 is not NA

# 10.18 weird format of its own, 2.19, 4.19, and 3.19 have a 
## comparable format



## I need to look at the columsn wherein ...11 is not NA-- these are the ones
## that are messed up
View(Copy[!(is.na(Copy$'...11')), ])
## same pattern for 2, 3, and 4 nineteen

View(subset(Copy, filename == "10.18"))
## 10.18 might need to be cleaned on its own

## I also need to remember to clean the dirty subset and to join it with the "Clean"
## more like add it to the clean

## if the file name is 4.19 and 9 is NA then 10 else 9-- this one literally has 
## the same patter as 2/2019-- i could have added an or statement with the 
## stuff I coded above and saved myself lines of code
View(subset(Test, filename == "3.19"))
## the same pattern occurs for 3.19 as well--
## so, i am going to try to clean them both at the same time
View(subset(Test, filename == "3.19"|filename == "4.19"))

Test<-Copy
## if the file name is 4.19 or 3.19 and 9 is NA then 10 else 9-- this one literally has 
Test$"...9" <- ifelse(is.na(Test$"...9")& Test$"filename"=="3.19"|Test$filename == "4.19"|Test$filename == "2.19", Test$"...10", Test$"...9")
View(subset(Test, filename == "3.19"|filename == "4.19"))
### if file name is 3.19 or 4.19 and 10 is equal to 9 then delete 10, else 10
Test$"...10" <- ifelse(Test$"filename"=="3.19"|Test$filename == "4.19"|Test$filename == "2.19" & Test$"...10"==Test$"...9",NA, Test$"...10")
View(subset(Test, filename == "3.19"|filename == "4.19"))

## if filename is 3.19 or 4.19 and  10 is NA then 11 else 11
Test$"...10" <- ifelse(is.na(Test$"...10")& Test$"filename"=="3.19"|Test$filename == "4.19"|Test$filename == "2.19", Test$"...11", Test$"...10")
View(subset(Test, filename == "3.19"|filename == "4.19"))

## if file name is 3.19 or 4.19 and 10 and 11 are the same delte 11 else 11
Test$"...11" <- ifelse(Test$"filename"=="3.19"|Test$filename == "4.19"|Test$filename == "2.19" & Test$"...10"==Test$"...11",NA, Test$"...11")
View(subset(Test, filename == "3.19"|filename == "4.19"|Test$filename == "2.19"))

## Now I need to take care of 10.18
## I might need to subset it out

#### Cleaning 10.18 ####

View(Test[(Test$filename=="10.18"), ])
dim(Test[(Test$filename=="10.18"), ])
## there are 48 rows and 26 columns

View(Test[(Test$filename!="10.18"), ])
dim(Test[(Test$filename!="10.18"), ])
### 2294 rows and 26 columns

2294+48
# 2342
dim(Test)
# 2342

## Create subsets-- to clean 10.18 alone 

SubSet<-Test[(Test$filename=="10.18"), ]
Clean_Data<-Test[(Test$filename!="10.18"), ]

## Delete empty columns from the 10.18 subset

library(tidyverse)
dim(SubSet)
## 26 columns
library(purrr)
SubSet<-SubSet %>% discard(~all(is.na(.) | . ==""))
dim(SubSet)
## 19 columns 
View(SubSet)

#### Delete first two rows of SubSet ####
# # https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
library(dplyr)
SubSet <- SubSet %>% slice(-c(1:2))
View(SubSet)

## Delete empty columns again
dim(SubSet)
## 19 columns
library(purrr)
SubSet<-SubSet %>% discard(~all(is.na(.) | . ==""))
dim(SubSet)
## 9 COlumns
View(SubSet)

## if X is NA, make it "District
names(SubSet)
SubSet$X <- ifelse(is.na(SubSet$X),"District", SubSet$X)
View(SubSet)

## Delete first row
library(dplyr)
SubSet <- SubSet %>% slice(-c(1))
View(SubSet)

## Clean Clean_Data
View(Clean_Data)

## Delete empty Columns
library(tidyverse)
dim(Clean_Data)
## 26 columns
library(purrr)
Clean_Data<-Clean_Data %>% discard(~all(is.na(.) | . ==""))
dim(Clean_Data)
## 17 columns 
View(Clean_Data)

## View if 13 is not NA

View(Clean_Data[!(is.na(Clean_Data$'...13')), ])
dim(Clean_Data[!(is.na(Clean_Data$'...13')), ])
## there is 86 rows

## if 13 is NA
View(Clean_Data[(is.na(Clean_Data$'...13')), ])
dim(Clean_Data[(is.na(Clean_Data$'...13')), ])
## 2208 rows

2208+86
## 2294
dim(Clean_Data)
## 2294

## subset to where 13 is NA
Clean_Data_C<-Clean_Data
Clean_Data<-Clean_Data[(is.na(Clean_Data$'...13')), ]

dim(Clean_Data)
## 2208

## Delete empty columns of Clean_Data Subset
library(tidyverse)
dim(Clean_Data)
## 17 columns
library(purrr)
Clean_Data<-Clean_Data %>% discard(~all(is.na(.) | . ==""))
dim(Clean_Data)
## 12 columns 
View(Clean_Data)

## Delete row if Voter registration figures is "Total" or "County Name"
levels(as.factor(Clean_Data$`Voter Registration Figures`))

#"County Name\n", "County Name\r\n", Total"

## https://www.datasciencemadesimple.com/delete-or-drop-rows-in-r-with-conditions-2/
names(Clean_Data)
dim(Clean_Data[(Clean_Data$`Voter Registration Figures`=="County Name\r\n"| Clean_Data$`Voter Registration Figures`=="Total"| Clean_Data$`Voter Registration Figures`=="County Name\n"),])
## 108 rows
dim(Clean_Data)
## 2208
dim(Clean_Data[!(Clean_Data$`Voter Registration Figures`=="County Name\r\n"| Clean_Data$`Voter Registration Figures`=="Total"| Clean_Data$`Voter Registration Figures`=="County Name\n"),])
# 2108

## subset out the ones that do not satisfy the condition 
Clean_Data<-Clean_Data_C
View(Clean_Data)
#### Name columns as first row ####
library(janitor)
Clean_Data<-janitor::row_to_names(Clean_Data,1)
View(Clean_Data)

names(Clean_Data)
# County Name\r\n
#"8.18"
# NA
View (Clean_Data)
## Rename 8.18 Column into Month_Year
names(Clean_Data)
names(Clean_Data)[names(Clean_Data)=="08.18"] <- "Month_Year"
names(Clean_Data)

## View if NA Column is not empty
names(Clean_Data)
View(Clean_Data[!(is.na(Clean_Data$`NA`)), ])
## it seems the last two columns are expendable
#### I will therefore delete columns 11:12 ####
library(dplyr)
names(Clean_Data)
Clean_Data_C<-Clean_Data
Clean_Data<-Clean_Data %>% select(-(11:12))
names(Clean_Data)

## Delete empty columns
library(tidyverse)
dim(Clean_Data)
## 10 columns
library(purrr)
Clean_Data<-Clean_Data %>% discard(~all(is.na(.) | . ==""))
dim(Clean_Data)
# 10 2207
View(Clean_Data)

# Delete rows if Count Name 
names(Clean_Data)
levels(as.factor(Clean_Data$`County Name\r\n`))
## delete these "County Name\n"     "County Name\r\n"  "Total"
dim(Clean_Data[(Clean_Data$`County Name\r\n`=="County Name\r\n"|Clean_Data$`County Name\r\n`=="County Name\n"| Clean_Data$`County Name\r\n`=="Total"),])
## 107 will be excluded 
dim(Clean_Data[!(Clean_Data$`County Name\r\n`=="County Name\r\n"|Clean_Data$`County Name\r\n`=="County Name\n"| Clean_Data$`County Name\r\n`=="Total"),])
## 2108 will be kept

dim(Clean_Data)
## together there is a total of 2207 before clean up

2207-107
# the final should have 2100? weird--
Clean_Data_C<-Clean_Data
Clean_Data<-Clean_Data[!(Clean_Data$`County Name\r\n`=="County Name\r\n"|Clean_Data$`County Name\r\n`=="County Name\n"| Clean_Data$`County Name\r\n`=="Total"),]
dim(Clean_Data)
## 2108

levels(as.factor(Clean_Data$`County Name\r\n`))
## I mean, it worked-- now i have no more levels that 
## are named as the before conditions
## But i am unsure where the extra person came from-- could it be an NA?

View(Clean_Data)

## don't forget to add rows from Dirty, SubSet and Clean Data
View(Dirty)
View(SubSet)

## Name the columns as the first row of Subset
library(janitor)
SubSet_C<-SubSet
SubSet<-janitor::row_to_names(SubSet,1)
View(SubSet)

#### Delete Total Column for both SubSet and Dirty ####
names(SubSet)
# Column 9 for Subset

## COlumn 11 for Dirty

## its starting to worry me that they do not have the same number 
## of columns
dim(Clean_Data)
# 10 

names(Dirty)
library(dplyr)
Dirty_C<-Dirty
Dirty<-Dirty %>% select(-(11))
names(Dirty)

## Delete Total Column for SubSet
library(dplyr)
names(SubSet)
SubSet_C<-SubSet
SubSet<-SubSet %>% select(-(9))
names(SubSet)
#3 for t

## Figure out where the column discrepancy is occuring
names(SubSet)
dim(SubSet)
## 8 columns
## Add the columns of Green Party, and Natural Law Party
## just leave them empty cuz there is no info on them 
## https://www.statology.org/add-empty-column-to-data-frame-r/
SubSet_C<-SubSet
SubSet[ , 'Green Party'] <- NA
SubSet[ , 'Natural Law Party'] <- NA
names(SubSet)
dim(SubSet)
## 44 rows and 10 columns

names(Dirty)
dim(Dirty)
## 86 rows and 10 columns

names(Clean_Data)
dim(Clean_Data)
## 2108 rows and 10 columns 
names(SubSet)
## rename 10.18, American should be Independent
# https://www.statology.org/how-to-rename-data-frame-columns-in-r/
names(SubSet)[names(SubSet)=="10.18"] <- "Month_Year"
names(SubSet)
names(SubSet)[names(SubSet)=="American"] <- "Independent"
names(SubSet)

names(SubSet)[names(SubSet)=="Green Party"] <- "Green"

names(SubSet)[names(SubSet)=="Natural Law Party"] <- "Natural Law"

## Now renaming the Dirty Columns
names(Dirty)
## renaming File Name into Month_Year and 
## County Name\r\n into "District"
names(Dirty)[names(Dirty)=="filename"] <- "Month_Year"
names(Dirty)

names(Dirty)[names(Dirty)=="County Name\r\n"] <- "District"

names(Dirty)

names(Dirty)[names(Dirty)=="Other (All Others)"] <- "Other"
names(Dirty)

names(Dirty)[names(Dirty)=="Independent American Party"] <- "Independent"

names(Dirty)[names(Dirty)=="Natural Law Party"] <- "Natural Law"

names(Dirty)[names(Dirty)=="Libertarian Party"] <- "Libertarian"

names(Dirty)

## Names for Clean Data

names(Clean_Data)
names(Clean_Data)[names(Clean_Data)=="8.18"] <- "Month_Year"

names(Clean_Data)[names(Clean_Data)=="Other (All Others)"] <- "Other"

names(Clean_Data)[names(Clean_Data)=="Libertarian Party"] <- "Libertarian"

names(Clean_Data)[names(Clean_Data)=="Green Party"] <- "Green"

names(Clean_Data)[names(Clean_Data)=="Independent American Party"] <- "Independent"

names(Clean_Data)[names(Clean_Data)=="Natural Law Party"] <- "Natural Law"

names(Clean_Data)[names(Clean_Data)=="County Name\r\n"] <- "District"

names(Clean_Data)

#### Now I need to make sure the Columns are in the same order ####
names(SubSet)
## https://www.tutorialspoint.com/how-to-change-the-order-of-columns-in-an-r-data-frame
## Before that, I need to rename Nonpartisan into "Non-Partisan
SubSet_C<-SubSet
names(SubSet)[names(SubSet)=="Nonpartisan"] <- "Non-Partisan"
names(Clean_Data)
names(SubSet)
SubSet_C<-SubSet
SubSet<-SubSet[, c("Month_Year", "District", "Democrat", "Green", "Independent" 
                   ,"Libertarian", "Natural Law", "Non-Partisan", "Other"
                   ,"Republican")]

names(SubSet)
names(Clean_Data)
names(Dirty)
## renaming Green Party into Green
names(Dirty)[names(Dirty)=="Green Party"] <- "Green"
names(Clean_Data)
names(Dirty)


## Perfect 
## Now I need to make sure the columns are the same type 
## on the three objects I want to join
summary(Dirty)
## first 2 are character-- the rest are numeric
summary(Clean_Data)
names(Clean_Data)
#### All are character-- I need to make 3:10 numeric####
## https://statisticsglobe.com/convert-data-frame-column-to-numeric-in-r
## making range of columsn numeric in R 3:10
names(Clean_Data)
i<-c(3:10)
Clean_Data_C<-Clean_Data
Clean_Data[ , i] <- apply(Clean_Data[ , i], 2,            # Specify own function within apply
                          function(x) as.numeric(as.character(x)))
sapply(Clean_Data, class)
## it worked
## checking the type for the SubSet
sapply(SubSet, class)
names(SubSet)
## I also need to change 3:10 of the SubSet into numeric
SubSet_C<-SubSet
SubSet[ , i] <- apply(SubSet[ , i], 2,            # Specify own function within apply
                      function(x) as.numeric(as.character(x)))

sapply(SubSet, class)
## it worked 

#### Now I need to add rows of the 3 objects ####

dim(SubSet)
## 44
dim(Clean_Data)
## 2108

dim(Dirty)
## 86
86+2108+44
## 2238

library(dplyr)
Final<-bind_rows(Clean_Data,Dirty, SubSet) 
dim(Final)
## 2238

## Rename the District into Assembly_District
names(Final)
names(Final)[names(Final)=="District"] <- "Assembly_District"
names(Final)


#### I totally forgot to clean the Month_Year Column ####
## Split the Month and Year Column into separate columns
# https://www.delftstack.com/howto/r/separate-in-r/
library(tidyr)
library(dplyr)
library(stringr)
Final_C<-Final
names(Final)
Final<-Final %>% separate(Month_Year, c('Month', 'Year'))
names(Final)
View(Final)

#### Add 2000 to the year #### 

Final$Year<-2000 + as.numeric(Final$Year)
View(Final)

#### Clean Month COlumn ####
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
Final<-Final_1
Final$Assembly_District<-Final$Assembly_District %>% str_replace("Assembly Dist. ", "")
View(Final)
levels(as.factor(Final$Assembly_District))

## there are addotonal levels that I might need to get 
## rid of 
## "No District" "Statewide"   "Total"
## https://www.statology.org/r-select-rows-by-condition/
View(Final[Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total', ])
dim(Final[Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total', ])
## 12 rows 
dim(Final)
## 2238
2238-12

## 2226
## there appears to also be rows that are completely empty that which 
## I should delete empty rows first 
dim(Final[!(Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total'),])
## 2234 -- why?
Final_C<-Final
names(Final)
## were 3:11 are empty
dim(Final)
## 2238
Final<-Final[!apply(is.na(Final[,3:11]), 1, all),]
dim(Final)
## 2230
# Final_C<-Final
dim(Final[!(Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total'),])
## 2226
dim(Final[(Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total'),])
## 4
2226-4
### 2222
View(Final[(Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total'),])
Final_C<-Final
Final<-Final[!(Final$Assembly_District == 'No District'|Final$Assembly_District == 'Statewide'|Final$Assembly_District == 'Total'),]
dim(Final)
### 2226

## I am unsure why i am not getting 2222 as expected
levels(as.factor(Final$Assembly_District))

## I mean -- the values are gone-- So I am unsure what happened

## I need to replace these values by taking away their
## 0's 
## "01" "02" "03" "04" "05" "06" "07" "08" "09"
# https://www.geeksforgeeks.org/how-to-replace-specific-values-in-column-in-r-dataframe/
Final_C<-Final

Final$Assembly_District[Final$Assembly_District == "01"] <- "1"
Final$Assembly_District[Final$Assembly_District == "02"] <- "2"
Final$Assembly_District[Final$Assembly_District == "03"] <- "3"
Final$Assembly_District[Final$Assembly_District == "04"] <- "4"
Final$Assembly_District[Final$Assembly_District == "05"] <- "5"
Final$Assembly_District[Final$Assembly_District == "06"] <- "6"
Final$Assembly_District[Final$Assembly_District == "07"] <- "7"
Final$Assembly_District[Final$Assembly_District == "08"] <- "8"
Final$Assembly_District[Final$Assembly_District == "09"] <- "9"
levels(as.factor(Final$Assembly_District))

View(Final)

## replace NA's with the number 0
names(Final)
Final<-Final_C
# https://www.geeksforgeeks.org/replace-na-values-with-zeros-in-r-dataframe/
Final[is.na(Final)] = 0
#### write a CSV ####

write.csv(Final, "C:/Users/cogps/Desktop/No_NA_Clean_AD_2018_22.csv", row.names=FALSE)
View(Final)
#### Fin ####
