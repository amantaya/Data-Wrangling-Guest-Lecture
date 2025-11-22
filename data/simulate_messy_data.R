set.seed(123)

# function to generate unique cow IDs
generate_ids <- function(n) {
  prefix <- sample(LETTERS, n, replace = TRUE)
  digits <- sample(0:9999, n, replace = FALSE)
  ids <- paste0(prefix, digits)

  if (length(unique(ids)) != n) {
    stop("Generated IDs are not unique. Please try again.")
  }

  ids
}

cow_ids <- generate_ids(80)

milk_milk_df <- data.frame(
  cow_ID = sample(cow_ids, size = 1000, replace = TRUE),
  # NOTE: note the `Date` column is deliberately capitalized and students will need to
  # convert to a lowercase
  Date = sample(
                seq(
                    as.Date("2024-01-01"),
                    as.Date("2024-12-31"),
                    by = "day"),
                size = 1000,
                replace = TRUE),
  # NOTE: the `milk L` deliberately has a space and students will need to
  # replace the space with an underscore
  `milk L` = round(
                 rnorm(
                       1000,
                       mean = 30,
                       sd = 5),
                 digit = 2),
  # NOTE: the `fat %` column name has a special character `%`
  # that students will need to replace with `percent`
  `fat %` = round(
                      rnorm(
                            1000,
                            mean = 3.5,
                            sd = 0.5),
                      digit = 2)
)

# Negative Values ------------------------------------------------------

# Introduce some negative values for `milk L` and `fat %`
set.seed(42)
neg_indices_milk <- sample(seq_len(nrow(milk_df)), size = 20)
milk_df$`milk L`[neg_indices_milk] <- -abs(milk_df$`milk L`[neg_indices_milk])

set.seed(43)
neg_indices_fat <- sample(seq_len(nrow(milk_df)), size = 10)
milk_df$`fat %`[neg_indices_fat] <- -abs(milk_df$`fat %`[neg_indices_fat])

# Missing Values -------------------------------------------------------

# Introduce some missing values for `milk L` and `fat %`
set.seed(34)
missing_indices_milk <- sample(seq_len(nrow(milk_df)), size = 50)
milk_df$`milk L`[missing_indices_milk] <- NA

set.seed(56)
missing_indices_fat <- sample(seq_len(nrow(milk_df)), size = 30)
milk_df$`fat %`[missing_indices_fat] <- NA

# Messy Date Formats ---------------------------------------------------

# Introduce some messy date formats
date_formats <- c("%Y-%m-%d", "%m/%d/%Y", "%m-%d-%Y", "%d %b %Y")

milk_df$Date <- sapply(milk_df$Date, function(d) {
  format_choice <- sample(date_formats, 1)
  format(as.Date(d), format_choice)
})

# Duplicate Observations -----------------------------------------------

# TODO: add some duplicate observations

# TODO: add some outliers

# Write to CSV
write.csv(milk_df, file = "data/raw/milk_yield.csv", row.names = FALSE)

set.seed(123)

# Simulate feed_intake.csv similarly
feed_milk_df <- data.frame(
  # TODO: check that all of the cow ids from the milk data are in the feed data
  # the seed should be the same to ensure the same cow IDs are generated
  vid = sample(cow_ids, size = 1000, replace = TRUE),
  date = sample(
    seq(
      as.Date("2024-01-01"),
      as.Date("2024-12-31"),
      by = "day"),
    size = 1000,
    replace = TRUE),
  feed_kg = round(
    rnorm(
      1000,
      mean = 20,
      sd = 3),
    digit = 2),
  feed_type = sample(
    c(
      "silage",
      " silage",
      "silage ",
      "corn silage",
      "Silage",
      "silge", # this is a deliberate typo to simulate messy data
      "corn",
      "Corn",
      "hay",
      "Hay",
      " hay "),
    size = 1000,
    replace = TRUE)
)

# Messy date formats
feed_milk_df$Date <- sapply(feed_milk_df$Date, function(d) {
  format_choice <- sample(date_formats, 1)
  format(as.Date(d), format_choice)
})

# Missing values
set.seed(90)

missing_indices_feed <- sample(seq_len(nrow(feed_milk_df)), size = 100)

feed_milk_df$feed_kg[missing_indices_feed] <- NA

# Write to CSV
write.csv(feed_milk_df, file = "data/raw/feed_intake.csv", row.names = FALSE)

