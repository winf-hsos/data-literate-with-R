#### Explore new data ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# Load the sales data
orders <- read_csv("data/orders.csv")

# 1. Get information about columns ####

# Get an overview of columns (names, data types, example values)
orders %>%
  glimpse()

# Get a list of column names as a vector
orders %>% 
  colnames()

# 2. Explore the dimensions of the data ####
orders %>% 
  dim()

orders %>% 
  ncol()

orders %>% 
  nrow()

orders %>% 
  count()

# 3. View samples of the data ####

# Get the first few rows
orders %>% 
  head()

orders %>% 
  head(10)

# Get the last few rows
orders %>% 
  tail()

orders %>% 
  tail(10)

# Get 20 random samples of the data
orders %>% 
  slice_sample(n = 20)

# Sample 1% of the data
orders %>% 
  slice_sample(prop = 0.01)

# 4. Retrieve information about columns and their data

# Get unique values
orders %>% 
  distinct(payment_details_gateway)

# The same, but result as a vector
orders %>% 
  distinct(payment_details_gateway) %>% 
  pull()

# Get unique values with ordered counts
orders %>% 
  count(payment_details_gateway, sort = TRUE)

# Summary of a column
orders %>% 
  select(total_price) %>% 
  summary()

# or...
summary(orders$total_price)

# For non-numeric data
summary(as.factor(orders$payment_details_gateway))

# 4. Get missing values ####

# Install package skimr (only once)
install.packages("skimr")

library(skimr)

orders %>% 
  skim()

orders %>% 
  skim() %>% 
  select(skim_variable, n_missing)