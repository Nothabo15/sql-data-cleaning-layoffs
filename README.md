 Layoffs Data Cleaning & Analysis (SQL Project)
 Project Overview

This project focuses on analyzing global layoffs data using SQL. The workflow was divided into two main phases:

Data Cleaning → Preparing and standardizing the dataset for accuracy and consistency.

Data Analysis (Exploratory Data Analysis - EDA) → Running SQL queries to uncover insights, trends, and patterns.

This project highlights SQL best practices in data cleaning and analysis, making the dataset reliable for business decision-making and future visualization.

 Tools Used

MySQL (via DBeaver) – Data cleaning & analysis

GitHub – Project versioning and portfolio showcase

 Phase 1: Data Cleaning

The dataset required multiple cleaning steps to ensure consistency and accuracy:

1. Removing Duplicates
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
               ORDER BY date
           ) AS row_num
    FROM Layoffs.layoff_table_staging
)
DELETE 
FROM Layoffs.layoff_table_staging2
WHERE row_num > 1;


Used ROW_NUMBER() to find and remove duplicate records.

2. Standardizing Text Fields
UPDATE Layoffs.layoff_table_staging2
SET company = TRIM(company);


Trimmed extra spaces in company names.

UPDATE Layoffs.layoff_table_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


Standardized variations like "Crypto / Blockchain" → "Crypto".

UPDATE Layoffs.layoff_table_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


Fixed country formatting inconsistencies (e.g., United States., United States..).

3. Fixing Date Fields
UPDATE Layoffs.layoff_table_staging2
SET date = STR_TO_DATE(date, '%Y-%m-%d');


Converted all dates into a proper DATE format.

4. Handling Null & Blank Values
UPDATE Layoffs.layoff_table_staging2
SET industry = NULL
WHERE industry = '';


Replaced blank industries with NULL.

DELETE
FROM Layoffs.layoff_table_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;


Removed irrelevant rows with missing key information.

After cleaning, the dataset was free of duplicates, standardized, and ready for analysis.

 Phase 2: Data Analysis (EDA)

Using the cleaned dataset (layoff_table_staging2), SQL queries were performed to extract insights:

1. Maximum Layoffs & Percentages
SELECT MAX(total_laid_off), MAX(CAST(percentage_laid_off AS DECIMAL(5,2)))
FROM Layoffs.layoff_table_staging2;


Found the largest layoffs and 100% shutdowns.

2. Companies with 100% Layoffs
SELECT *
FROM Layoffs.layoff_table_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

3. Total Layoffs by Company
SELECT company, SUM(total_laid_off)
FROM Layoffs.layoff_table_staging2
GROUP BY company
ORDER BY 2 DESC;

4. Date Range of Layoffs
SELECT MIN(date), MAX(date)
FROM Layoffs.layoff_table_staging2;

5. Layoffs by Industry
SELECT industry, SUM(total_laid_off)
FROM Layoffs.layoff_table_staging2
GROUP BY industry
ORDER BY 2 DESC;

6. Layoffs by Country
SELECT country, SUM(total_laid_off)
FROM Layoffs.layoff_table_staging2
GROUP BY country
ORDER BY 2 DESC;

7. Layoffs by Year
SELECT YEAR(date), SUM(total_laid_off)
FROM Layoffs.layoff_table_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

8. Monthly Layoff Trends & Rolling Totals
WITH Rolling_Total AS (
    SELECT SUBSTRING(date,1,7) AS MONTH, SUM(total_laid_off) AS total_off
    FROM Layoffs.layoff_table_staging2
    GROUP BY MONTH
    ORDER BY 1 ASC
)
SELECT MONTH, total_off,
       SUM(total_off) OVER(ORDER BY MONTH) AS rolling_total
FROM Rolling_Total;

9. Yearly Top 5 Companies by Layoffs
WITH Company_Year AS (
    SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
    FROM Layoffs.layoff_table_staging2
    GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

📈 Key Insights

Some companies laid off 100% of employees (complete shutdowns).

Tech & Crypto industries were among the hardest hit.

The United States recorded the highest layoffs by country.

Layoffs peaked during certain years (e.g., downturn cycles).

Startups and growth-stage companies were more vulnerable.

Rolling totals showed layoffs accelerating over time.
*Author: Nothabo Michelle Moyo*  
*Project Date: 01 October 2025*  
