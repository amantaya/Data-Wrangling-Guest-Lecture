# TODO List

## `milk_yield.csv`

1. Clean the column names
    - remove spaces and replace with underscores
    - remove special characters `%` and replace with words `percent`
2. Standardize date formats in the 'Date' column to "YYYY-MM-DD".
3. Correct inconsistencies in the 'feed_type' column (e.g., unify "silage", "Silage", "silge" to "silage").
4. Handle missing values in 'milk_L' and 'feed_kg' columns by removing rows with missing values.
5. Remove any duplicate rows from the dataset.
6. Validate data types for each column (e.g., ensure 'milk_L' and 'feed_kg' are numeric, 'Date' is Date type).
7. Save a clean version of the dataset to "data/clean_milk_yield.csv" after cleaning is complete.

## `feed_intake.csv`

7.

## Combine Datasets

8. Join the clean_milk_yield.csv with clean_feed_intake.csv on 'cow_id' and 'Date' to create a combined dataset for analysis.
    - the `milk_yield.csv` uses `cow_id` as the identifier whereas the `feed_intake.csv` uses `vid` as the identifier. We will need to join on these two columns.
