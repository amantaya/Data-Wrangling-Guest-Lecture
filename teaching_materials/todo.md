# TODO List

## `milk_yield.csv`

1. Clean the column names
    - remove spaces and replace with underscores
    - remove special characters `%` and replace with words `percent`
2. Handle missing values in `milk L` and `fat %` columns by removing rows with:
    - duplicates
    - missing values
    - negative values (where such a value is impossible)
3. Standardize date formats in the 'Date' column to "YYYY-MM-DD".
4. Arrange `date` column in chronological order
5. Validate data types for each column (e.g., ensure `milk_liters` and `fat_percent` are numeric, `date` is Date type).
6. Save a clean version of the dataset to "data/clean/milk_yield_clean.csv"

## `feed_intake.csv`

7. Clean the column names
8. Remove missing observations
9. Rename the `vid` column to `cow_id`
10. Convert `date` column to Date class
11. Arrange `date` column in chronological order
12. Correct inconsistencies in the 'feed_type' column
    - trim whitespace: " silage " to "silage"
    - unify variables: merge "silage" into "Silage"
    - correct typos:  "silge" to "silage"
13. Validate data types in columns
14. Save a clean version of the dataset to "data/clean/feed_intake_clean.csv"

## Combine Datasets

15. Join the clean_milk_yield.csv with clean_feed_intake.csv on 'cow_id' and 'date' to create a combined dataset for analysis.
