#### Load data from Microsoft Excel ####

# Always load the tidyverse at the top of your script
library(tidyverse)

# 1. Install required packages (only once) ####
install.packages("readxl")

library(readxl)

sales <- read_excel("data/sales.xlsx")


# 2. Fix the column names ####
install.packages("janitor")

library(janitor)

sales <- sales %>%
  clean_names()

sales %>% 
  glimpse()