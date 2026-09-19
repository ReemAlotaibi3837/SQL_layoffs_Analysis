-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank values
-- 4. Remove any Columns or Rows 

-- Creating a duplicate dataset to prevent any harm to the raw dataset in case of mistakes.
CREATE TABLE  layoffs_stating 
LIKE layoffs;

SELECT *
FROM layoffs_stating;

INSERT layoffs_stating
SELECT * 
FROM layoffs;


-- Duplicate removal  

-- Looked at only some rows 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_stating;

-- Looking at oda to confirm
SELECT *
FROM layoffs_stating
WHERE company = 'Oda';

-- Initial code is wrong upon further check. All entries are legitimate and should not be removed 

-- Look for duplicates using the majority of rows in the dataset
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date` , stage,
 country, funds_raised) AS row_num
FROM layoffs_stating
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Double-checking that the above SQL did actually show all duplicates.
SELECT *
FROM layoffs_stating 
WHERE company = 'Casper';

-- Below sql won't be used to delete rows; instead, we will add a new column and put row_num in it, and delete the duplicates from there to make the process easier 

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date` , stage,
 country, funds_raised) AS row_num
FROM layoffs_stating
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;

-- Creating a new table with row_num in it 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` text,
  `country` text,
  `date_added` text,
  `row_num` INT
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date` , stage,
 country, funds_raised) AS row_num
FROM layoffs_stating;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- Standardizing data

-- Trimming any spaces 
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- Following the tutorial, seeing if there are any recurring industry names
SELECT * 
FROM  layoffs_staging2
WHERE industry LIKE 'Crypto%';


-- Compared to the video, this dataset has no recurring industry names, so there will be no need to follow any further steps related to this part 

SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;

-- fixing the date columns
SELECT `date` 
FROM  layoffs_staging2;

UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2;


-- NULLS

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT * 
FROM layoffs_staging2
 WHERE company = 'Airbnb';
 
 SELECT t1.industry, t2.industry
 FROM layoffs_staging2 t1
 JOIN layoffs_staging2 t2 
	ON t1.company = t2.company 
WHERE  (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = ''
AND percentage_laid_off = '';

-- Deleting where both total laid off and percentage laid off are blank, as they are useless data we won't use 
DELETE
FROM layoffs_staging2
WHERE total_laid_off = ''
AND percentage_laid_off = '';

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;




