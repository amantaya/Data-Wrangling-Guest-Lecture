library("readr") # for read_csv
library("dplyr") # for glimpse and pipe operator
library("here") # for file path management
library("dlookr") # for data exploration

# Load Messy Data ------------------------------------------------------

# Not OK - hard-coded file path that only works on one computer
# messy_data <- read.csv("a/very/specific/file/path/that/will/only/work/on/your/computer/milk_yield.csv")

# OK - but not portable across operating systems
messy_data <- read.csv("data/milk_yield.csv") # class: data.frame

# Better - using file.path for cross-platform paths
# and uses class `tibble` for better data handling
messy_data <- read_csv(
  file.path("data", "milk_yield.csv") # class: tibble
)

# Best - using here for project-root-relative paths
# and uses class `tibble` for better data handling
messy_data <- readr::read_csv(
  here::here("data", "milk_yield.csv") # class: tibble
)

# Exploring Messy Data ---------------------------------------------------

# Not great - raw printout
print(messy_data)

# print() method depends on the class of the object

# class `data.frames`` have a basic print method that shows all rows and columns

# class `tibble`` has a more sophisticated print method that shows
# only a few rows and columns but also shows data types

# OK - overall view of the data
View(messy_data)

# Better - concise overview of the data structure
dplyr::glimpse(messy_data) # Includes data types and a preview of data

# Best - detailed diagnosis of data issues
dlookr::diagnose(messy_data)

# Amazing - paged report for easier navigation
dlookr::diagnose_paged_report(messy_data)

# Exercise 1: Based on your exploration, list at least 5 specific data quality issues you identified in the messy dataset.
