-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;


SELECT MAX(total_laid_off)
FROM layoffs_staging2;

-- Prior SQL did not work because total_laid_off is in text format, so we'll be fixing that and other columns and rerunning it.

ALTER TABLE layoffs_staging2 
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging2 
MODIFY COLUMN funds_raised INT;

-- Looking to see how big the layoffs were 
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- If we order by funds_raised, we can see how big these companies were
-- Which companies laid off 100% of their staff, and how much funding had they raised?
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off =1
ORDER BY funds_raised DESC;

-- Companies with the most layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- seeing what time span this data is 
SELECT min(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Inspecting industries
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Countries
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs each year
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- Seeing companies but with avg percentage laid off instead
SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Rolling total of layoffs per month each year
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Rolling total of layoffs per month each year, but with total laid off for comparison 
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7)IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

-- How many were laid off in each company 
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company 
ORDER BY 2 DESC;

-- Mistake should have turned all blank values into NULL during cleaning, and since I changed total_laid_off to INT, 0 was used here 
UPDATE layoffs_staging2
SET total_laid_off = NULL 
WHERE total_laid_off = 0;

-- What company had the most laid off and in what year
SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Companies with the most laid off per year but only the top 5
WITH Company_Year (company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`),SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(SELECT *, 
DENSE_RANK() OVER (partition by years ORDER BY total_laid_off desc) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
select * 
from Company_Year_Rank
WHERE Ranking <= 5
;

