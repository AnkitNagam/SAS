# SAS
Analysis of PUBG Player Statistics 

Objective/Goal: Build a model to predict player rating, to identify how a player can improve their play to increase the player rating.

Software: SAS
Technique : Multiple Regression

Output: About 86% of the predictions were accurate. My model could explain 85% variability in predicting ratings.

Dataset: PLAYERUNKNOWN'S BATTLEGROUNDS Player Statistics (source Kaggle).

Methodology: Choose randomly selected 3000 observation from the dataset of 85,000.

Apply feature selection to select 18 variables out of a total of 150 based on what I know about the type of data and what it represents. Created dummy variables for categorical data. Created interactive points to better understand the effect of variables on the dependent variable. Checked and remove 145 outliers and influential points. I split the data into training and testing set. Developed a model on the training set, Used 5- fold cross-validation on the testing set to check performance.
