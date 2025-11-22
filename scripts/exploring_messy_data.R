library("readr") # for read_csv
library("dplyr") # for glimpse and pipe operator
library("here") # for file path management
library("dlookr") # for data exploration

# Load Messy Data ------------------------------------------------------

# Not OK - hard-coded file path that only works on one computer
# messy_data <- read.csv("a/very/specific/file/path/that/will/only/work/on/your/computer/milk_yield.csv")

# OK - but not portable across operating systems
messy_milk_data_df <- read.csv("data/raw/milk_yield.csv") # class: data.frame

# Better - using file.path for cross-platform paths
# and uses class `tibble` for better data handling
messy_milk_data_tb <- read_csv(
  file.path("data", "raw", "milk_yield.csv") # class: tibble
)

# Best - using here for project-root-relative paths
# and uses class `tibble` for better data handling
messy_milk_data_tb <- readr::read_csv(
  here::here("data", "raw", "milk_yield.csv") # class: tibble
)

# Exploring Messy Data ---------------------------------------------------

# Not great - raw printout
print(messy_milk_data_df)

# print() method depends on the class of the object

# class `data.frames`` have a basic print method that shows all rows and columns

# class `tibble`` has a more sophisticated print method that shows
# only a few rows and columns but also shows data types

print(messy_milk_data_tb)

# OK - overall view of the data
View(messy_milk_data_tb)

# Better - concise overview of the data structure
dplyr::glimpse(messy_milk_data_tb) # Includes data types and a preview of data

# Best - detailed diagnosis of data issues
dlookr::diagnose(messy_milk_data_tb)

# Amazing - paged report for easier navigation
dlookr::diagnose_paged_report(messy_milk_data_tb)

# Exercise 1: Based on your exploration, list at least 5 specific data quality issues you identified in the messy dataset.

# Exercise 2: For each data quality issue you identified, suggest a specific data cleaning step that could address the issue.

# TODO: what other `dlookr` functions should I introduce them too?

# There is a fancy name for what we did here today, it's called:
# Exploratory Data Analysis (EDA)
