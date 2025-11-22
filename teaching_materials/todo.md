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
4. Arrange `Date` column in chronological order
5. Validate data types for each column (e.g., ensure `milk_liters` and `fat_percent` are numeric, `date` is Date type).
6. Save a clean version of the dataset to "data/clean_milk_yield.csv" after cleaning is complete.

## `feed_intake.csv`

8.
Correct inconsistencies in the 'feed_type' column (e.g., unify "silage", "Silage", "silge" to "silage").
9.

## Combine Datasets

10. Join the clean_milk_yield.csv with clean_feed_intake.csv on 'cow_id' and 'Date' to create a combined dataset for analysis.
    - the `milk_yield.csv` uses `cow_id` as the identifier whereas the `feed_intake.csv` uses `vid` as the identifier. We will need to join on these two columns.
