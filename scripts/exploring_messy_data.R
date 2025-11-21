library("readr") # for read_csv
library("dplyr") # for glimpse and pipe operator
library("here") # for file path management
library("dlookr") # for data exploration

# Load Messy Data ------------------------------------------------------

# Not OK
# messy_data <- read.csv("a/very/specific/file/path/that/will/only/work/on/your/computer/milk_yield.csv")

# OK
messy_data <- read.csv("data/milk_yield.csv") # class: data.frame

# Better
messy_data <- read_csv(
  file.path("data", "milk_yield.csv") # class: tibble
)

# Best
messy_data <- readr::read_csv(
  here::here("data", "milk_yield.csv") # class: tibble
)

# Explore Messy Data ---------------------------------------------------

# Not Great
print(messy_data)

# OK
View(messy_data)

# Better
dplyr::glimpse(messy_data)

# Best
dlookr::diagnose(messy_data)

# Amazing
dlookr::diagnose_paged_report(messy_data)

# Visualize Messy Data -------------------------------------------------

dlookr::plot_bar_category(messy_data)

# Outliers -------------------------------------------------------------

dlookr::plot_outlier(messy_data)
