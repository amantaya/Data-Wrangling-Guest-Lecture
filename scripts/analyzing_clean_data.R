library("readr")
library("here")
library("dlookr")

# Read in the Clean Data -----------------------------------------------
combined_df <- readr::read_csv(
  here::here("data", "clean", "combined_milk_feed_clean.csv")
)

# Explore the Clean Data -----------------------------------------------
glimpse(combined_df)

# Summary Statistics ---------------------------------------------------
dlookr::describe(combined_df)

# Visualize Distributions ----------------------------------------------
dlookr::plot_normality(combined_df)

# Ask yourself:
# Are there any variables that do not appear to be normally distributed?
# Do I need to transform any variables before running analyses?

# Visualize Outliers ---------------------------------------------------
dlookr::plot_outlier(combined_df)

# Ask yourself:
# Are there any variables that appear to have outliers?
# If so, are the outliers legitimate values or data entry errors?
# If they are data entry errors, how should I handle them?
# If they are legitimate values, do I need to use a non-parametric test for my analyses?

# What Are The Underlying Assumptions for T-Tests? ---------------------

# 1. The dependent variable is continuous
# 2. The observations are independent
# 3. The dependent variable is approximately normally distributed for each group of the independent variable (T-Test is robust to moderate violations of normality)
# 4. Homogeneity of variances (homoscedasticity)

# If the data is not normally distributed, consider using a transformation (e.g., log, square root) or a non-parametric test (e.g., Mann-Whitney U test).

# 1. Is our dependent variable continuous?
# TRUE for milk_liters and fat_percent

# 2. Are our observations independent?
# FALSE if the same cows are measured multiple times such as in a repeated measures design.

# 3. Is our dependent variable approximately normally distributed for each group of the independent variable?
# Use dlookr::plot_normality() to check this assumption.

# 4. Is there homogeneity of variances?
# Plotting residuals can help assess this assumption.

# Create residual plots to assess homogeneity of variances
milk_yield_residuals <- lm(milk_liters ~ feed_type, data = combined_df)

par(mfrow = c(2, 2))

plot(milk_yield_residuals)

# Assumption 2 may be violated if the same cows are measured multiple times.
# Therefore, a Student's T-Test may not be appropriate.
# Consider using a linear mixed-effects model to account for repeated measures.

# Fitting a Two-Sample T-Test ------------------------------------------

# Effect of Feed Type on Milk Production -------------------------------

# H0: There is no difference in milk production between cows fed different types of feed.
# H1: There is a difference in milk production between cows fed different types of feed.

milk_yield_model <- t.test(
  milk_liters ~ feed_type,
  data = combined_df,
  var.equal = TRUE
)
print(milk_yield_model)

# Exercise 1: In plain English, what do the results of the t-test above tell you about milk production between cows fed different types of feed?

# Effect of Feed Type on Milk Fat Percentage ---------------------------

# H0: There is no difference in milk fat percentage between cows fed different types of feed.
# H1: There is a difference in milk fat percentage between cows fed different types of feed.

milk_fat_model <- t.test(
  fat_percent ~ feed_type,
  data = combined_df,
  var.equal = TRUE
)

print(milk_fat_model)

# Exercise 2: In plain English, what do the results of the t-test above tell you about milk fat percentage between cows fed different types of feed?

# Next Steps -----------------------------------------------------------

# Depending on the results of the t-tests, you may want to explore further analyses, such as:
# - ANOVA if you have more than two groups to compare
# - Regression analysis (linear models) to control for additional variables
# - Non-parametric tests if assumptions are violated
