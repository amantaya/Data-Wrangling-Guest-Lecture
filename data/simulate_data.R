set.seed(123)

# function to generate unique cow IDs
generate_ids <- function(n) {
    prefix <- sample(LETTERS, n, replace = TRUE)
    digits <- sample(0:9999, n, replace = FALSE)
    ids <- paste0(prefix, digits)

    if (length(unique(ids)) != n) {
        stop("Generated IDs are not unique. Please try again.")
    }

    return(ids)
}

df <- data.frame(
  cow_ID = generate_ids(100),
  Date = sample(
                seq(
                    as.Date("2024-01-01"),
                    as.Date("2024-12-31"),
                    by = "day"),
                size = 100,
                replace = TRUE),
  milk_L = round(
                 rnorm(
                       100,
                       mean = 30,
                       sd = 5),
                 digit = 2),
  feed_kg = round(
                  rnorm(
                        100,
                        mean = 20,
                        sd = 3),
                  1),
  feed_type = sample(
                     c(
                       "silage",
                       "corn silage",
                       "Silage",
                       "silge",
                       "corn",
                       "Corn",
                       "hay",
                       "Hay",
                       "roughage"),
                     size = 100,
                     replace = TRUE)
)

# Introduce some messy date formats
date_formats <- c("%Y-%m-%d", "%d/%m/%Y", "%m-%d-%Y")

df$Date <- sapply(df$Date, function(d) {
    format_choice <- sample(date_formats, 1)
    format(as.Date(d), format_choice)
})

# Introduce some missing values
missing_indices_milk <- sample(1:nrow(df), size = 10)
missing_indices_feed <- sample(1:nrow(df), size = 10)
df$milk_L[missing_indices_milk] <- NA
df$feed_kg[missing_indices_feed] <- NA

# Write to CSV
write.csv(df, file = "data/milk_yield.csv", row.names = FALSE)