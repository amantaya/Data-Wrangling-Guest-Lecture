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

df <- data.frame(
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

# TODO: introduce some negative values


# Introduce some messy date formats
date_formats <- c("%Y-%m-%d", "%m/%d/%Y", "%m-%d-%Y", "%d %b %Y")

df$Date <- sapply(df$Date, function(d) {
  format_choice <- sample(date_formats, 1)
  format(as.Date(d), format_choice)
})

# Introduce some missing values
set.seed(34)
missing_indices_milk <- sample(seq_len(nrow(df)), size = 100)
set.seed(56)
missing_indices_feed <- sample(seq_len(nrow(df)), size = 100)
df$milk_L[missing_indices_milk] <- NA
df$feed_kg[missing_indices_feed] <- NA

# TODO: add invalid column names

# TODO: add some duplicate observations

# TODO: add some outliers

# Write to CSV
write.csv(df, file = "data/raw/milk_yield.csv", row.names = FALSE)

set.seed(123)

# Simulate feed_intake.csv similarly
feed_df <- data.frame(
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
feed_df$Date <- sapply(feed_df$Date, function(d) {
  format_choice <- sample(date_formats, 1)
  format(as.Date(d), format_choice)
})

# Missing values
set.seed(90)

missing_indices_feed <- sample(seq_len(nrow(feed_df)), size = 100)

feed_df$feed_kg[missing_indices_feed] <- NA

# Write to CSV
write.csv(feed_df, file = "data/raw/feed_intake.csv", row.names = FALSE)

