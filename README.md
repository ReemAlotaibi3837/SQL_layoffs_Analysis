# Tech Layoffs 2020-2026: Data Cleaning & EDA in MySQL
## Overview
This project cleans and explores a dataset of global tech layoffs using MySQL. The raw data was obtained from Kaggle, where it was then cleaned and analyzed.  

This project was completed following [Alex The Analyst](https://youtu.be/4UltKCnnnTA) on data cleaning and exploratory data analysis. 

## Dataset
- Source: [Layoffs Dataset - Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- Rows: 3853
- Time range: 2020-2026
- Columns: company, location, total_laid_off, date, percentage_laid_off, industry, source, stage, funds_raised, country, date_added

## Tools Used
- MySQL 9.1
- MySQL Workbench

## Data Cleaning 
Raw data had duplicates, inconsistent text formatting, and missing values. Steps taken in [`sql/01_data_cleaning.sql`](sql/01_data_cleaning.sql):

1. Removed duplicates; used row_num() over  all relevant columns (no primary key exists) and deleted rows where the row number was greater than 1.
2. Standardized text fields: trimmed whitespace
3. Fixed data types: converted the date column from text to a proper DATE type.
4. Removed unusable rows: deleted rows where both total_laid_off and percentage_laid_off were blank.
5. Dropped helper columns: removed temporary columns (row_num) once cleaning was complete.

## Exploratory Data Analysis
Analysis queries are in [`sql/02_EDA.sql`](sql/02_EDA.sql). Key questions explored:

- Which companies laid off 100% of their staff, and how much funding had they raised?
- Which companies had the highest total layoffs overall, and which had the highest average percentage laid off?
- How did total layoffs trend by year, and on a rolling monthly basis?
- Which companies had the most layoffs in each year, and who were the top 5 per year?

### Data type fix mid-analysis
While trying to find the MAX(total_laid_off), I found the column was imported as text rather than a number, so aggregate functions weren't behaving correctly. I corrected this along with funds_raised.

### Key Findings
- The largest single layoff event was Amazon, with 59,560 employees laid off.
- Britishvolt raised 2.4 billion in funding before laying off 100% of their employees.
- Industries labeled as 'other' and 'Retail' had the highest total layoffs across the dataset.
- The dataset spans from '2020-03-11' to '2026-09-08'.
- 2023 had the highest total layoffs at 265,660 total.
- The top 5 companies by layoffs varied significantly year to year, with Uber leading in 2020 and Meta leading in 2022.

## Acknowledgments
Cleaning and EDA approach based on [Alex The Analyst](https://youtu.be/4UltKCnnnTA). Dataset from [Layoffs Dataset - Kaggle](https://www.kaggle.com/datasets/swaptr/layoffs-2022). 





