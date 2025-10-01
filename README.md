# Layoffs Data Cleaning Project

## Overview
This project demonstrates a complete workflow for cleaning and standardizing a dataset of company layoffs. The goal was to prepare the data for analysis by handling duplicates, missing values, inconsistent text entries, and date formatting issues.

The dataset contains information about layoffs, including:
- `company` – Company name  
- `location` – Location of the company  
- `industry` – Industry type  
- `total_laid_off` – Number of employees laid off  
- `percentage_laid_off` – Percentage of workforce laid off  
- `date` – Date of layoff announcement  
- `stage` – Company stage  
- `country` – Country of operation  
- `funds_raised_millions` – Funding raised by the company (in millions)

## Tools
- **Database:** MySQL  
- **SQL Client:** DBeaver  
- **Scripts:** `layoffs_data_cleaning.sql`

## Project Steps

### 1. Creating Staging Tables
- Created `layoff_table_staging` and `layoff_table_staging2` with the same structure as the original table.
- Inserted all rows from the original `layoff_table` into the staging tables for safe cleaning operations.

### 2. Handling Duplicates
- Used `ROW_NUMBER()` with `PARTITION BY` to identify and remove duplicate rows.

### 3. Managing Missing and Invalid Values
- Replaced string `'NULL'` with actual SQL `NULL`.  
- Deleted rows where both `total_laid_off` and `percentage_laid_off` were NULL.  
- Standardized `industry` and `country` columns and removed trailing periods.  

### 4. Date Formatting
- Converted date strings from `MM/DD/YYYY` to proper `DATE` format using `STR_TO_DATE`.  
- Updated the `date` column in the staging table to the correct `DATE` data type.

### 5. Standardizing Text Data
- Trimmed extra spaces in `company`, `industry`, and `country` columns.  
- Standardized industry names (e.g., consolidated `Crypto*` to `Crypto`).  

### 6. Verification
- Counted rows before and after cleaning.  
- Queried distinct values to check for inconsistencies.  
- Verified that duplicates and invalid rows were removed.  

## How to Use
1. Open the project in DBeaver or any SQL client.  
2. Run the script `layoffs_data_cleaning.sql` step by step or as a whole.  
3. The cleaned and standardized data will be in the table `layoff_table_staging2`.

## Outcome
The resulting `layoff_table_staging2` is a clean, standardized, and ready-to-analyze dataset. This table can be used for further analysis, reporting, or visualization tasks.

## File Structure
- `layoffs_data_cleaning.sql` – SQL script containing the entire data cleaning workflow.

---

*Author: Nothabo Michelle Moyo*  
*Project Date: 01 October 2025*  
