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
  Date = sample(
                seq(
                    as.Date("2024-01-01"),
                    as.Date("2024-12-31"),
                    by = "day"),
                size = 1000,
                replace = TRUE),
  milk_L = round(
                 rnorm(
                       1000,
                       mean = 30,
                       sd = 5),
                 digit = 2),
  feed_kg = round(
                  rnorm(
                        1000,
                        mean = 20,
                        sd = 3),
                  digit = 2),
  feed_type = sample(
                     c(
                       "silage",
                       "corn silage",
                       "Silage",
                       "silge",  # this is a deliberate typo to simulate messy data
                       "corn",
                       "Corn",
                       "hay",
                       "Hay",
                       "roughage"),
                     size = 1000,
                     replace = TRUE)
)

# Introduce some messy date formats
date_formats <- c("%Y-%m-%d", "%m/%d/%Y", "%m-%d-%Y", "%dth %b %Y")

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

# TODO: add some duplicate observations

# TODO: add some outliers

# Write to CSV
write.csv(df, file = "data/milk_yield.csv", row.names = FALSE)

# TODO: simulate feed_intake.csv similarly