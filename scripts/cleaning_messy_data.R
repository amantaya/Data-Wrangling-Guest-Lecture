# Setup ----------------------------------------------------------------

library("readr") # for read_csv
library("dplyr") # for glimpse, rename, and pipe operator
library("here") # for file path management
library("janitor") # for clean_names and get_dupes
library("tidyr") # for drop_na
library("lubridate") # for date parsing functions

# library("tidylog") # this is optional but provides helpful messages when using dplyr functions. It 'masks' dplyr functions, meaning it takes precedence when both packages are loaded. I really like using this package when doing interactive data cleaning.

# NOTE: I use the package::function() notation to be explicit about which package a function comes from.

# This is especially helpful in teaching materials and larger projects to avoid confusion when multiple packages have functions with the same name.

# Load Messy Data ------------------------------------------------------

milk_df <- readr::read_csv(
  here::here("data", "raw", "milk_yield.csv")
)

# Glimpse the data to see structure and data types
dplyr::glimpse(milk_df)

# The console shows helpful information about the data as it is read in, including the number of rows and columns, and the data types of each column.
# Pay attention to this printout!

# We know from our exploration that there are several data quality issues in this dataset.

# Cleaning Column Names ------------------------------------------------

# First we will clean the column names to make them easier to work with.
# Super easy way to clean column names!
milk_df <- janitor::clean_names(milk_df, case = "snake")

# Glimpse the data to see updated column names
dplyr::glimpse(milk_df)

# I don't think the `milk_l` column is clear enough, so let's rename it to `milk_liters`

milk_df <- milk_df %>%
    dplyr::rename(milk_liters = milk_l)

# Note: the `%>%` is the pipe operator from the `magrittr` package, which is also loaded with `dplyr`
# You can also use `|>` which comes with base R as of R 4.1.0

# Glimpse the data to see updated column names
dplyr::glimpse(milk_df)

# Handling Duplicate Rows ----------------------------------------------

# Now let's identify and handle duplicate rows
duplicate_rows <- janitor::get_dupes(milk_df)

# Additionally, `get_dupes()` allows you to specify specific columns to check for duplicates
# Example: `janitor::get_dupes(milk_df, cow_id, date)`

# Note: if there are no duplicate rows, `duplicate_rows` will be an empty tibble

# View duplicate rows
print(duplicate_rows)

# OR

# View duplicate rows in a paged viewer for easier navigation
# Helpful if you have a lot of duplicates
View(duplicate_rows)

# In our case, it looks like we have straight-up duplicates
# Our solution will be to keep the first observation and remove the rest
milk_df <- milk_df %>%
  dplyr::distinct() # keeps only unique rows

# After removing duplicates, I want to verify that there are no more duplicates
duplicate_rows_after <- janitor::get_dupes(milk_df)

print(duplicate_rows_after) # should be empty

# Handling Incomplete Observations -------------------------------------

# Now we will handle incomplete observations (missing data)

# Let's see how much missing data we have in each column
missing_data_summary <- milk_df %>%
    dplyr::summarise(across(everything(), ~ sum(is.na(.))))

# Don't feel overwhelmed by this special syntax! It's specific to the dplyr package.
# The `across()` function allows us to apply a function (in this case, counting NAs) to multiple columns at once.

print(missing_data_summary)

# Based on our exploration, we know that the `milk_liters` and the `fat_percent` columns have some missing values.

# For this example, we will remove rows with missing values in either of these columns

# Using dplyr
milk_df <- milk_df %>%
  dplyr::filter(!is.na(milk_liters) & !is.na(fat_percent))

# OR - using tidyr
milk_df <- milk_df %>%
  tidyr::drop_na(milk_liters, fat_percent)

# OR - base R way
milk_df <- stats::na.omit(milk_df)

# Verify that there are no more missing values in these columns
missing_data_summary_after <- milk_df %>%
    dplyr::summarise(across(c(milk_liters, fat_percent), ~ sum(is.na(.))))

print(missing_data_summary_after) # should show 0 for both columns

# Handling Negative and Zero Values ------------------------------------

# Based on our exploration, we know there are other data quality issues (e.g., negative values, zero values, outliers, messy date formats)

# Remove rows with negative or zero values in `milk_liters` and `fat_percent`
milk_df <- milk_df %>%
    dplyr::filter(milk_liters > 0 & fat_percent > 0)

# Remember in the data quality report it said "judgement" for negative and zero values?
# That's because it requires your own understanding of the data and context.
# It will be up to you to decide what to do with those values in your own data cleaning projects.

# In this case, we are assuming negative and zero values are invalid and removing them.

# Verify that there are no more negative or zero values
negative_zero_summary <- milk_df %>%
    dplyr::summarise(
      negative_zero_milk = sum(milk_liters <= 0),
      negative_zero_fat = sum(fat_percent <= 0)
    )

print(negative_zero_summary) # should show 0 for both columns

# Handling Messy Date Formats ------------------------------------------

# Now let's move onto messy date formats...

# Dates are special data types in R and require special handling.

# Here are some common date formats we might encounter:

# "2023-01-15" (YYYY-MM-DD)
# "01/15/2023" (MM/DD/YYYY)
# "15 Jan 2023" (DD MMM YYYY)
# "01-15-2023" (MM-DD-YYYY)
# "15-01-2023" (DD-MM-YYYY) for non-US formats.

# If we have a mix of these formats, we need to standardize them.

# Note: if you are collecting dates from multiple sources, you might end up with a mix of these formats. It can be especially tricky if the day and month can be confused (e.g., 01-05-2023 could be January 5 or May 1). Try to get ahead of this problem by standardizing date formats at the point of data collection if possible.

# Here, we will use the lubridate package which provides convenient functions for parsing dates in various formats.

milk_df <- milk_df %>%
  dplyr::mutate(
    date = lubridate::parse_date_time(
      date,
      orders = c("ymd", "mdy", "dmy", "mdY", "d b Y")
    )
  )

# Note that a warning message may appear indicating that some dates failed to parse.
# We will handle those invalid dates in the next section.

# In the `orders` argument, we specify the possible date formats we expect to encounter.

# The letter codes represent:
# y = year
# m = month
# d = day
# b = abbreviated month name (e.g., Jan, Feb)
# Y = four-digit year

# There are many more codes available in the lubridate documentation if you need them.
# See: https://lubridate.tidyverse.org/reference/parse_date_time.html

# Verify that the date column is now in Date format
dplyr::glimpse(milk_df)

# The `date` column should now show as `dttm` type in the glimpse output

str(milk_df$date) # should return "POSIXct"

# class `POSIXct` represents date-time values in R
# it is a numeric representation of the number of seconds since January 1, 1970 aka the Unix epoch

# Handling Invalid Dates -----------------------------------------------

# Sometimes, dates may be invalid (e.g., "2024-02-30" or "2024-04-31") and fail to parse correctly.

# Let's check for any NA values in the date column.

bad_dates <- milk_df %>%
  dplyr::filter(is.na(date))

print(bad_dates) # should be empty if all dates parsed correctly

# Oh no!
# It looks like we have 5 bad dates that failed to parse

# There are many ways to handle bad date values, depending on the context and your judgement.

# Option 1: Manually correct bad dates in the original data if you have the correct information.

# Option 2: Remove rows with bad dates

# Option 3: Impute bad dates based on other information (e.g., previous observation's date, median date, etc.)
# This option is more advanced and requires careful consideration of the implications.

# For this example, we will go with Option 2 and remove rows with bad dates
milk_df <- milk_df %>%
  dplyr::filter(!is.na(date))

# Verify that there are no more bad dates
bad_dates_after <- milk_df %>%
  dplyr::filter(is.na(date))

print(bad_dates_after) # should be empty

# Removing Time Component from Datetimes -------------------------------

# Our original data did not include a time component, so we want to strip out the time part
# and keep only the date.
# This is optional but can help avoid confusion later on.

# Using the `as.Date()` function to convert POSIXct to Date
milk_df <- milk_df %>%
  dplyr::mutate(
    date = as.Date(date)
  )

# Verify that the date column is now in Date format without time
dplyr::glimpse(milk_df)

str(milk_df$date) # should return "Date"

# Arranging Data by Date -----------------------------------------------

# Data may come to you out of order. Let's sort by date.
milk_df <- milk_df %>%
    dplyr::arrange(date)

# Verify that the data is sorted by date
print(head(milk_df, 10)) # should show the earliest dates at the top
print(tail(milk_df, 10)) # should show the latest dates at the bottom

# Verifying Column Data Types ------------------------------------------

# Finally, let's verify that all column data types are appropriate

dplyr::glimpse(milk_df)

# Based on our exploration, the appropriate data types should be:
# cow_id: character
# date: Date
# milk_liters: numeric
# fat_percent: numeric

# If any columns are not of the appropriate type, we can convert them using `mutate()` and appropriate conversion functions (e.g., `as.character()`, `as.numeric()`, etc.)

# Why? Because having the correct data types is crucial for accurate analysis and prevents errors in calculations and visualizations later on.

# For example, if `milk_liters` was read in as character, we would not be able to perform numerical operations on it until we convert it to numeric.

# Save Cleaned Data ----------------------------------------------------
readr::write_csv(
  milk_df,
  here::here("data", "clean", "milk_yield_clean.csv")
)

# I prefer `readr::write_csv()` because it is faster and more consistent than base R's `write.csv()`
# However, `readr::write_csv()` will convert datetimes to UTC by default, which may not be desired in all cases.

# OR using base R
write.csv(
  milk_df,
  here::here("data", "clean", "milk_yield_clean.csv"),
  row.names = FALSE
)