#### Load data from Google Spreadsheets ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# 1. Install required packages (only once) ####

# Find more information for this package here: https://googlesheets4.tidyverse.org
install.packages("googlesheets4")

# Load the Google Spreadsheets library 
library(googlesheets4)

# 2. Read from a Google Spreadsheet with authentication ####

# Read data from a spreadsheet, will ask to authenticate (!)
limo <- read_sheet("https://docs.google.com/spreadsheets/d/1nRix1JnytJKy0rsX1urGKyEnkDn_tMUqxQldzT4hayY/edit#gid=847323912")

# You can also read only with the sheet ID
limo <- read_sheet("1nRix1JnytJKy0rsX1urGKyEnkDn_tMUqxQldzT4hayY")


# 3. Read from a shared Google Spreadsheet without authentication ####

# For this to work, you have to share the spreadsheet with read-option for everyone

# Build the URL from sheet ID and sheet name
sheet_id <- "1nRix1JnytJKy0rsX1urGKyEnkDn_tMUqxQldzT4hayY"
sheet_name <- "raw"
sheet_url <- paste0("https://docs.google.com/spreadsheets/d/", sheet_id, "/gviz/tq?tqx=out:csv&sheet=", sheet_name)

# Read the data with the plain read_csv() function
limo <- read_csv(sheet_url)

limo %>% 
  glimpse()
