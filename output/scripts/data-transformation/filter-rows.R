#### Filter rows ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# Load the sales data
orders <- read_csv("data/orders.csv")

# 1. Equal and not equal operators ####
orders %>% 
  filter(customer_gender == "f")


# Read more...
# https://dplyr.tidyverse.org/reference/filter.html