#### Load data from JSON ####

# 1. Install required packages (only once) ####

# A package to convert JSON to a tibble
install.packages("tidyjson")

# A package for streaming large JSON-data in GZIP-compressed files
install.packages("jsonlite")

# 2. Load the packages (always before analysis) ####
library(tidyverse)
library(jsonlite)
library(tidyjson)

# This package has neat functions for date/time and is installed with tidyverse
library(lubridate)

# 3. Load the tweets from GZIP-JSON ####

# Load the original source file from a compressed JSON
tweets <- stream_in(file("./data/tweets_ampel.json.gz"))

# Convert the data into a tibble
tweets <- tidyjson::as_tibble(tweets)

# Take a sneak preview at the tibble
glimpse(tweets)

# 4. Transform some columns ####
# Convert all columns that end in "_count" into a numeric format
tweets <- 
  tweets %>% 
  mutate(across(ends_with("_count"), as.numeric))

# Set the locale to English (just to make sure..)
Sys.setlocale("LC_TIME", "English")

# Convert the column "created_at" into a date time format
tweets <- 
  tweets %>% 
  mutate(created_at = parse_date_time(created_at, "a b d H:M:S z Y"))

# Take another look... looks fine?
glimpse(tweets)

# 5. Save the data as R-native format for faster reload later ####
saveRDS(tweets, file = "./data/tweets_ampel.rds")

# That's it for loading the tweets - let's dive in!