library(tabulizer)
library(tabulizerjars)
# Define path to PDF file
pdf.file <- "C:/Users/cogps/Downloads/ReDo/1018CloseActiveVotersBYNEV.pdf"

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
library(purrr)
library(dplyr)
gpi_table_clean <- reduce(gpi_table, bind_rows)
View(gpi_table_clean)
write.csv(gpi_table_clean, "C:/Users/cogps/Downloads/ReDo/1018CloseActiveVotersBYNEV_CSV.csv", row.names=FALSE)
??bind_rows