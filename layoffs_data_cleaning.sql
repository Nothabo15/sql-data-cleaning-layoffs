-- Look at the data
SELECT
	*
FROM
	Layoffs.layoff_table;
-- Create an empty staging table with the same structure
CREATE TABLE Layoffs.layoff_table_staging
LIKE Layoffs.layoff_table;
-- Copy all rows into the staging table
INSERT
	INTO
	Layoffs.layoff_table_staging
SELECT
	*
FROM
	Layoffs.layoff_table;

SELECT
	COUNT(*) AS source_count
FROM
	Layoffs.layoff_table;

SELECT
	COUNT(*) AS staging_count
FROM
	Layoffs.layoff_table_staging;
-- Peek at the first few rows of the staging table
SELECT
	*
FROM
	Layoffs.layoff_table_staging
LIMIT 10;

SELECT
	*,
	ROW_NUMBER() OVER (
        PARTITION BY company,
	industry,
	total_laid_off,
	percentage_laid_off,
	date
ORDER BY
	date
    ) AS row_num
FROM
	Layoffs.layoff_table_staging;

WITH duplicate_cte AS 
(
SELECT
	*,
	ROW_NUMBER() OVER (
            PARTITION BY company,
	location,
	industry,
	total_laid_off,
	percentage_laid_off,
	date,
	stage,
	country,
	funds_raised_millions
ORDER BY
	date
        ) AS row_num
FROM
	Layoffs.layoff_table_staging
)
SELECT
	*
FROM
	duplicate_cte
WHERE
	row_num > 1;

SELECT
	*
FROM
	Layoffs.layoff_table_staging
WHERE
	company = 'Casper';

CREATE TABLE Layoffs.layoff_table_staging2 (
    company VARCHAR(255),
    location VARCHAR(255),
    industry VARCHAR(255),
    total_laid_off INT DEFAULT NULL,
    percentage_laid_off VARCHAR(50),
    date DATE,
    stage VARCHAR(255),
    country VARCHAR(255),
    funds_raised_millions INT DEFAULT NULL,
    row_num INT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

SELECT
	*
FROM
	Layoffs.layoff_table_staging2;

INSERT
	INTO
	Layoffs.layoff_table_staging2 (
    company,
	location,
	industry,
	total_laid_off,
	percentage_laid_off,
	date,
	stage,
	country,
	funds_raised_millions,
	row_num
)
SELECT
	company,
	location,
	industry,
	NULLIF(total_laid_off, 'NULL') AS total_laid_off,
	percentage_laid_off,
	CASE
		WHEN date = 'NULL' THEN NULL
		ELSE STR_TO_DATE(date, '%m/%d/%Y')
	END AS date,
	stage,
	country,
	NULLIF(funds_raised_millions, 'NULL') AS funds_raised_millions,
	ROW_NUMBER() OVER (
        PARTITION BY company,
	location,
	industry,
	total_laid_off,
	percentage_laid_off,
	date,
	stage,
	country,
	funds_raised_millions
ORDER BY
	CASE
		WHEN date = 'NULL' THEN NULL
		ELSE STR_TO_DATE(date, '%m/%d/%Y')
	END
    ) AS row_num
FROM
	Layoffs.layoff_table_staging;

DELETE
FROM
	Layoffs.layoff_table_staging2
WHERE
	row_num > 1;

SELECT
	*
FROM
	Layoffs.layoff_table_staging2;
-- Standardizing Data
SELECT
	company,
	TRIM(company)
FROM
	Layoffs.layoff_table_staging2;

UPDATE
	Layoffs.layoff_table_staging2
SET
	company = TRIM(company);

SELECT
	*
FROM
	Layoffs.layoff_table_staging2
WHERE
	industry LIKE 'Crypto%';

UPDATE
	Layoffs.layoff_table_staging2
SET
	industry = 'Crypto'
WHERE
	industry LIKE 'Crypto%';

SELECT
	DISTINCT industry
FROM
	Layoffs.layoff_table_staging2;

SELECT
	DISTINCT country,
	TRIM(TRAILING '.' FROM country)
FROM
	Layoffs.layoff_table_staging2
ORDER BY
	1;

UPDATE
	Layoffs.layoff_table_staging2
SET
	country = TRIM(TRAILING '.' FROM country)
WHERE
	country LIKE 'United States%';

SELECT
	`date` AS original_date,
	STR_TO_DATE(`date`, '%Y-%m-%d') AS converted_date
FROM
	Layoffs.layoff_table_staging2;

UPDATE
	Layoffs.layoff_table_staging2
SET
	`date` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE Layoffs.layoff_table_staging2
MODIFY COLUMN `date` DATE;

SELECT
	*
FROM
	Layoffs.layoff_table_staging2
WHERE
	(total_laid_off IS NULL
		OR total_laid_off = 'NULL')
	AND (percentage_laid_off IS NULL
		OR percentage_laid_off = 'NULL');

UPDATE
	Layoffs.layoff_table_staging2
SET
	industry = NULL
WHERE
	industry = '';

SELECT
	DISTINCT industry
FROM
	Layoffs.layoff_table_staging2
WHERE
	industry IS NULL
	OR industry = ''
	OR industry = 'NULL';

SELECT
	*
FROM
	Layoffs.layoff_table_staging2
WHERE
	company LIKE 'Bally%';

SELECT
	*
FROM
	Layoffs.layoff_table_staging2 t1
JOIN Layoffs.layoff_table_staging2 t2
	ON
	t1.company = t2.company
WHERE
	(t1.industry IS NULL
		OR t1.industry = '')
	AND t2.industry IS NOT NULL;

SELECT
	t1.industry,
	t2.industry
FROM
	Layoffs.layoff_table_staging2 t1
JOIN Layoffs.layoff_table_staging2 t2
	ON
	t1.company = t2.company
WHERE
	(t1.industry IS NULL
		OR t1.industry = '')
	AND t2.industry IS NOT NULL;

UPDATE
	Layoffs.layoff_table_staging2 t1
JOIN Layoffs.layoff_table_staging2 t2
	ON
	t1.company = t2.company 
SET
	t1.industry = t2.industry
WHERE
	t1.industry IS NULL
	AND t2.industry IS NOT NULL;

SELECT
	*
FROM
	Layoffs.layoff_table_staging2;

SELECT
	*
FROM
	Layoffs.layoff_table_staging2
WHERE
	(total_laid_off IS NULL
		OR total_laid_off = 'NULL')
	AND (percentage_laid_off IS NULL
		OR percentage_laid_off = 'NULL');

DELETE
FROM
	Layoffs.layoff_table_staging2
WHERE
	(total_laid_off IS NULL)
	AND (percentage_laid_off IS NULL
		OR percentage_laid_off = 'NULL');

SELECT
	*
FROM
	Layoffs.layoff_table_staging2;

ALTER TABLE Layoffs.layoff_table_staging2
DROP COLUMN row_num;














