# TODO List
# 1. Standardize date formats in the 'Date' column to "YYYY-MM-DD".
# 2. Correct inconsistencies in the 'feed_type' column (e.g., unify "silage", "Silage", "silge" to "silage").
# 3. Handle missing values in 'milk_L' and 'feed_kg' columns by imputing with the mean of their respective columns or by removing rows with missing values.
# 4. Remove any duplicate rows from the dataset.
# 5. Validate data types for each column (e.g., ensure 'milk_L' and 'feed_kg' are numeric, 'Date' is Date type).
# 6. Save a clean version of the dataset to "data/clean_milk_yield.csv" after cleaning is complete.