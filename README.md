# Job Change of Data Scientists – SQL Project

This project analyzes the **Job Change of Data Scientists** dataset using MySQL.  
It includes a normalized schema, data loading steps, and 45 SQL queries ranging from basic to advanced analytics.

## Files
- `Haniya Khan - SQL - Final Project File.sql` — full project script  
- `archive/aug_train.csv` — training data  
- `archive/aug_test.csv` — test data  
- `archive/sample_submission.csv` — prediction file  

## Schema
The project uses three tables:

- **city** — unique city + development index  
- **train** — labeled data (includes `target`)  
- **test** — unlabeled data  

`train.city` and `test.city` both reference `city.city`.

## Skills Demonstrated
- Joins, grouping, filtering  
- Window functions (RANK, ROW_NUMBER, AVG OVER)  
- CTEs, subqueries, unions  
- Data normalization (3NF)  
- Real-world HR analytics  

## Highlights
Some examples of analysis completed:

- Job-seeking rate by experience level, gender, city, and education  
- Ranking enrollees by training hours  
- Calculating prediction accuracy from sample submission  
- Identifying “at-risk” enrollees using multi-condition filters  
- Comparing job-change behavior across low vs high development cities  

---

**Author:** Haniya Khan  
GitHub: @haniyakhann
