library("readr") # for read_csv
library("dplyr") # for glimpse and pipe operator
library("here") # for reproducible file path management
library("dlookr") # for data exploration

# Load Messy Data ------------------------------------------------------

# OK
messy_data <- read.csv("data/messy_data.csv")

# Better
messy_data <- read_csv("data/messy_data.csv")

# Best
messy_data <- readr::read_csv(
    here::here("data", "messy_data.csv")
    )

# Explore Messy Data ---------------------------------------------------

# OK
print(messy_data)

# Better
dplyr::glimpse(messy_data)

# Best
dlookr::diagnose(messy_data)
