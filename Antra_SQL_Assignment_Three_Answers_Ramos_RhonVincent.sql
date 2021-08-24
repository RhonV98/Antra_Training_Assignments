/* This .sql file holds all responses for each question 
in the SQL Assignment Three doc file.

Author: Rhon Vincent Ramos */

-- Part One
-- 1. In SQL Server, assuming you can find the result by using both joins and subqueries, which one would you prefer to use and why?
/* While a JOIN would be easier to write, I would prefer using a subquery. Specifically, I would write a subquery in the SELECT
 * statement. It functions nigh identical to a JOIN but it can also fine-tune which parts of a table that would join using its own filters.
 * This, of course, depends on whether the initial table requires further filtering initially. Otherwise, JOINs would be preferable.
 */

-- 2. What is CTE and when to use it?
/* CTE stands for "Common Table Expressions" and it is used to create "temporary" tables that subsequent queries can retrieve
 * tables from. We can say that this is like using a subquery on the database table itself before using the actual queries. CTEs
 * are used when the user wants to increase query speeds by creating a temporary table with only values of interest.
 */

-- 3. What are Table Variables? What is their scope and where are they created in SQL Server?
/* A Table Variable is a variable that can hold records akin to SQL tables. They exist only within the 
 * the session they are declared in and are created in the tempdb database.
 */

-- 4. What is the difference between DELETE and TRUNCATE? Which one will have better performance and why?
/* DELETE differentiates from TRUNCATE because the DELETE statement logs the deletion while TRUNCATE does not.
 * Since TRUNCATE does not log the deletion, less system resources are used since the deletion of table
 * data is not logged. Therefore, TRUNCATE is typically faster than DELETE.
 */

-- 5. What is Identity column? How does DELETE and TRUNCATE affect it?
/* The Identity column is a unique column that identifies a row in a table. DELETE does not affect it
 * but TRUNCATE resets the column to its seed value. In fact, if DELETE is used to remove a table
 * of its values, the starting value in the Identity column will be the next value that would have
 * succeeded the last Identity column value prior to deletion.
 */

-- 6. What is difference between “delete from table_name” and “truncate table table_name”?
/* Both expressions are functionally identical. However, TRUNCATE TABLE table_name allows
 * rolling back the action.
 */

-- Part Two: Using Northwind Database
-- 1. List all cities that have both Employees and Customers.
SELECT Employees.City AS 'City with Employees and Customers'
FROM dbo.Employees AS Employees
	FULL OUTER JOIN dbo.Customers AS Customers
	ON Employees.City = Customers.City
WHERE Employees.City = Customers.City;

-- 2a. List all cities that have Customers but no Employee. Use a subquery.
SELECT Customers.City AS 'City with Customers and No Employees'
FROM dbo.Customers AS Customers
WHERE Customers.City NOT IN 
	(SELECT Employees.City FROM dbo.Employees AS Employees);

-- 2b. List all cities that have Customers but no Employee. Don't use a subquery.
SELECT Customers.City AS 'City with Customers and No Employees'
FROM dbo.Customers AS Customers
	FULL OUTER JOIN dbo.Employees AS Employees
	ON Customers.City != Employees.City;

-- 3. List all products and their total order quantities throughout all orders.
SELECT Products.ProductName AS 'Product Name', COUNT(OrderDetails.Quantity) AS 'Order Quantity'
FROM dbo.Products AS Products
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName

-- 4. List all Customer Cities and total products ordered by that city.
SELECT Customers.City AS 'Customer City', COUNT(OrderDetails.Quantity) AS 'Product Quantity'
FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	INNER JOIN dbo.Products AS Products
	ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.City;

-- 5a. List all Customer Cities that have at least two customers. Use a UNION.
-- Author's Note: found no use for UNION keyword.
SELECT Customers.City AS 'Customer City', COUNT(Customers.CustomerID) AS 'Number of Customers'
FROM dbo.Customers AS Customers
GROUP BY Customers.City
HAVING COUNT(Customers.CustomerID) >= 2;

-- 5b. List all Customer Cities that have at least two customers. Use a subquery.
SELECT Customers.City AS 'Customer City', COUNT(Customers.CustomerID) AS 'Number of Customers'
FROM dbo.Customers AS Customers
WHERE Customers.City IN
	(SELECT Orders.ShipCity 
	 FROM dbo.Orders AS Orders)
GROUP BY Customers.City
HAVING COUNT(Customers.CustomerID) >= 2;

-- 6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT Customers.City AS 'Customer City with >2 Products', COUNT(Products.ProductID) AS 'Number of Ordered Products'
FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	INNER JOIN dbo.Products AS Products
	ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.City
HAVING COUNT(Products.ProductID) >= 2;

-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT Customers.ContactName AS 'Customer Name'
FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
WHERE Customers.City != Orders.ShipCity
GROUP BY Customers.ContactName;

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 Products.ProductName AS 'Product Name', AVG(Products.UnitPrice) AS 'Average Price', Customers.City AS 'Customer City', OrderDetails.Quantity AS 'Product Quantity'
	FROM dbo.Products AS Products
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Products.ProductID = OrderDetails.ProductID
	INNER JOIN dbo.Orders AS Orders
	ON OrderDetails.OrderID = Orders.OrderID
	INNER JOIN dbo.Customers AS Customers
	ON Orders.CustomerID = Customers.CustomerID
GROUP BY Products.ProductName, Customers.City, OrderDetails.Quantity
ORDER BY OrderDetails.Quantity DESC;

-- 9a. List all cities that have never ordered something but we have employees there. Use a subquery.
SELECT Customers.City AS 'Cities with No Orders but with Employees'
FROM dbo.Customers AS Customers
WHERE Customers.CustomerID NOT IN
	(SELECT Orders.CustomerID 
	 FROM dbo.Orders AS Orders
	 WHERE Orders.EmployeeID IN 
		(SELECT Employees.EmployeeID
		 FROM dbo.Employees AS Employees));

-- 9b. List all cities that have never ordered something but we have employees there. Don't use a subquery.
SELECT Customers.City AS 'Cities with No Orders but with Employees'
FROM dbo.Customers AS Customers
	FULL OUTER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	FULL OUTER JOIN dbo.Employees AS Employees
	ON Orders.EmployeeID = Employees.EmployeeID
WHERE Orders.OrderID IS NULL;

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--    and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT TOP 1 Employees.City AS 'Employee City', OrderDetails.Quantity AS 'Order Quantity', SUM(OrderDetails.Quantity) AS 'Total Product Quantity'
FROM dbo.Employees AS Employees
	INNER JOIN dbo.Orders AS Orders
	ON Employees.EmployeeID = Orders.EmployeeID
	JOIN 
		(SELECT Quantity, OrderID 
		 FROM dbo."Order Details") AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Employees.City, OrderDetails.Quantity
ORDER BY SUM(OrderDetails.Quantity) DESC;

--11. How do you remove duplicate records of a table?
/* We can use the RANK() function followed by PARTITION BY to specify which columns to check
 * for duplicate values. RANK() increments its value by one every time it encounters a duplicate
 * in the table. We can then use the DELETE keyword to delete any retrieved row with a RANK 
 * value greater than one.
 */

 --Part Three: using the sample table
 /* EMPLOYEE(empid integer, mgrid integer, deptid integer, salary mmoney)
  * DEPT(deptid integer, deptname varchar(20))
  */

-- 12. Find employees who do not manage anybody.
SELECT empid
FROM EMPLOYEE 
WHERE mgrid IS NULL;

-- 13. Find departments with maximum number of employees
-- Author's Note: using variable to assume maximum employee count
DECLARE @MaxEmployeeNum INT;
SET @MaxEmployeeNum = 200;
SELECT deptname, COUNT(empid) AS 'Count of Employees'
FROM DEPT
	INNER JOIN EMPLOYEE
	ON DEPT.deptid = EMPLOYEE.deptid
HAVING COUNT(empid) = @MaxEmployeeNum
ORDER BY deptname

-- 14. Find top 3 employees (salary based) in every department. Result should have deptname, empid, 
--     salary sorted by deptname and then employee with high to low salary.
SELECT TOP 3 department.deptname, department.empid, department.salary
FROM 
	(SELECT deptname, empid, salary, ROW_NUMBER() OVER 
		(PARTITION BY deptname ORDER BY salary DESC) AS dept
	) AS department  
WHERE department.dept <= 3;




