library("readr") # for read_csv
library("janitor") # for clean_names and get_dupes

# NOTE: I use the package::function() notation to be explicit about which package a function comes from.

# This is especially helpful in teaching materials and larger projects to avoid confusion when multiple packages have functions with the same name.

milk_df <- readr::read_csv(
  here::here("data", "raw", "milk_yield.csv")
)

# Glimpse the data to see structure and data types
dplyr::glimpse(milk_df)

# The console shows helpful information about the data as it is read in, including the number of rows and columns, and the data types of each column.
# Pay attention to this printout!

# We know from our exploration that there are several data quality issues in this dataset.

# First we will clean the column names to make them easier to work with.
# Super easy way to clean column names!
milk_df <- janitor::clean_names(milk_df, case = "snake")

# Glimpse the data to see updated column names
dplyr::glimpse(milk_df)

