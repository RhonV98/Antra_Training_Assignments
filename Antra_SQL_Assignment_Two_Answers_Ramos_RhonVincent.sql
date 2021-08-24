/* This .sql file holds all responses for each question 
in the SQL Assignment Two doc file.

Author: Rhon Vincent Ramos */

-- Part One
-- 1. What is a result set? 
-- A result set is a table retrieved by an SQL query from a database.

-- 2. What is the difference between UNION and UNION ALL?
-- UNION retrieves a table of distinct values resulting from a combination of two or more SELECT statements.
-- UNION ALL does nearly the same but retrieves all values, including duplicates.

-- 3. What are the other Set Operators SQL server has?
-- SQL also has the Set Operators INTERSECT and MINUS.

-- 4. What is the difference between a UNION and a JOIN?
-- A UNION concatonates tables based on two or more SELECT statements regardless of table values. 
-- A JOIN concatonates tables based on two or more equal table values.

-- 5. What is the difference between INNER JOIN and FULL JOIN?
-- INNER JOIN retrieves a concatonation of two tables comprised of values that are equivalent in both tables.
-- FULL JOIN retrieves a concatonation of two tables comprised of all values that appear in both tables.

-- 6. What is the difference between a LEFT JOIN and an OUTER JOIN?
-- A LEFT JOIN retrieves a concatonation of two tables with all values on the "left table" and values in the "right table" that have an equivalent value on the left table.
-- An OUTER JOIN retrieves a concatonation of two tables that excludes equivalent values in both tables.

-- 7. What is a CROSS JOIN?
-- A CROSS JOIN retrieves a concatonation of two tables with all possible combination of values from both tables.

-- 8. What is the difference between WHERE clause and HAVING clause?
-- A WHERE clause filters the result set based on specific conditions. It cannot filter aggregate functions.
-- A HAVING clause is similar but can be used with aggregate functions.

-- 9. Can there be multiple GROUP BY columns?
-- Yes, a result set can be grouped by multiple columns. But there cannot be multiple GROUP BY clauses in the query.

SELECT *
FROM Production.Product;

-- Part Two: Using AdventureWorks2019 Database
-- 1. How many products can you find in the Production.Product table?
SELECT COUNT(ProductID) AS 'num_products'
FROM Production.Product;

-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. 
--    The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) as 'num_products'
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductID) AS 'CountedProducts'
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL
GROUP BY ProductSubcategoryID;

-- 4. How many products that do not have a product subcategory. 
SELECT COUNT(ProductID) AS 'num_products_no_subcategory'
FROM Production.Product
WHERE ProductSubcategoryID IS NULL;

-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) AS 'products_quantity'
FROM Production.ProductInventory
GROUP BY ProductID;

-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 
--    and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) as 'TheSum'
FROM Production.ProductInventory
WHERE LocationID = 40 
GROUP BY ProductID
HAVING SUM(Quantity) < 100;


-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 
--    and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) as 'TheSum'
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) < 100;

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) as 'avg_quantity'
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID;

-- 9. Write a query to see the average quantity of products by shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS 'TheAvg'
FROM Production.ProductInventory
GROUP BY ProductID, Shelf;

-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that
--     has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) as 'TheAvg'
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf;

-- 11.List the members (rows) and average list price in the Production.Product table. This should be grouped independently 
--    over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT Color, Class, COUNT(ListPrice) AS 'TheCount', AVG(ListPrice) AS 'AvgPrice'
FROM Production.Product
WHERE Color IS NOT NULL OR Class IS NOT NULL
GROUP BY Color, Class;

-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. 
--     Join them and produce a result set similar to the following. 
SELECT country_region.name AS 'Country', state_province.name AS 'Province'
FROM Person.CountryRegion AS country_region
INNER JOIN Person.StateProvince AS state_province
ON country_region.CountryRegionCode = state_province.CountryRegionCode;

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. 
--     StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT country_region.name AS 'Country', state_province.name AS 'Province'
FROM Person.CountryRegion AS country_region
INNER JOIN Person.StateProvince AS state_province
ON country_region.CountryRegionCode = state_province.CountryRegionCode
WHERE country_region.name IN ('Germany', 'Canada');

