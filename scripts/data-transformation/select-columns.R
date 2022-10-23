#### Select columns ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# Load the sales data
orders <- read_csv("data/orders.csv")

# 1. Select columns by name ####

# Listing the column names
orders %>% 
  select(order_id, total_price)

# Select columns that start with a prefix
orders %>% 
  select(starts_with("shipping_"))

# Select columns that end in a prefix
orders %>% 
  select(ends_with("_at"))

# Select columns that contain a specific string
orders %>% 
  select(contains("price"))

# Select columns that are matched by a regular expression (here same as ends_with)
orders %>% 
  select(matches("_at$"))

# 2. Select columns by their data type ####
orders %>% 
  select(where(is.numeric))

orders %>% 
  select(where(is.logical))

orders %>% 
  select(where(is.character))

orders %>% 
  select(where(is.factor))

orders %>% 
  select(where(is.list))

# The package lubridate provides a function to check for date (without time)
library(lubridate)
orders %>% 
  select(where(lubridate::is.Date))

# Select all date/time columns
orders %>% 
  select(where(lubridate::is.POSIXct))

# 3. Exclude columns from selection ####
orders %>% 
  select(-order_id)

# All columns that end in count, but exclude two of them
orders %>% 
  select(ends_with("_at"), -closed_at, -processed_at)

# 4. Select columns by position ####

# Select last column
orders %>% 
  select(last_col())

# Select last second last column 
orders %>% 
  select(last_col(2))

# Select first column
orders %>% 
  select(1)

# Select a range of columns
orders %>% 
  select(2:6)

# Select everything but the last two columns
orders %>% 
  select(1:last_col(2))

# Define a set of columns in a vector and select this set
cols <- c("created_at", "updated_at")

orders %>% 
  select(all_of(cols))

# Read more...
# Wickham & Grolemund 2017: Kapitel 3 ab S. 49
# Sauer 2019: Kapitel 7.2.3 ab S. 81
# https://dplyr.tidyverse.org/reference/select.html
# https://analytics.datalit.de/r/15-daten-veraendern/spalten-auswaehlen