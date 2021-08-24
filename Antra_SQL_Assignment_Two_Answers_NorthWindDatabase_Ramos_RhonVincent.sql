/* This .sql file holds all responses for the Northwind Database 
section of the SQL Assignment Part Two doc.

Author: Rhon Vincent Ramos */

-- Part Three: Using Northwind Database
-- 14. List all Products that has been sold at least once in last 25 years.
SELECT Products.ProductName AS 'Product Name'
FROM dbo.Products AS Products
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Products.ProductID = OrderDetails.ProductID
	INNER JOIN dbo.Orders AS Orders
	ON Orders.OrderID = OrderDetails.OrderID
WHERE Orders.ShippedDate <= DATEADD(year, -25, GETDATE());

-- 15. List top 5 locations (Zip Code) where the products sold most.
-- Author's Note: Database names 'Zip Code' as PostalCode
SELECT TOP 5 Orders.ShipPostalCode AS 'Zip Code', SUM(OrderDetails.Quantity) AS ProductQuantity
FROM dbo.Orders AS Orders
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
WHERE ShipPostalCode IS NOT NULL
GROUP BY ShipPostalCode
ORDER BY SUM(OrderDetails.Quantity) DESC;

-- 16. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 Orders.ShipPostalCode AS 'Zip Code', SUM(OrderDetails.Quantity) AS ProductQuantity
FROM dbo.Orders AS Orders
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
WHERE ShipPostalCode IS NOT NULL AND Orders.ShippedDate <= DATEADD(year, -25, GETDATE())
GROUP BY ShipPostalCode
ORDER BY SUM(OrderDetails.Quantity) DESC;

-- 17. List all city names and number of customers in that city.  
SELECT Customers.City AS City, COUNT(Customers.CustomerID) AS 'Number of Customers'
FROM dbo.Customers AS Customers
GROUP BY Customers.City;

-- 18. List city names which have more than 2 customers, and number of customers in that city 
SELECT Customers.City AS City, COUNT(Customers.CustomerID) AS 'Number of Customers'
FROM dbo.Customers AS Customers
GROUP BY Customers.City
HAVING COUNT(Customers.ContactName) > 2;

-- 19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT Customers.ContactName AS 'Customer Name', Orders.ShippedDate AS 'Order Date'
	FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
WHERE Orders.ShippedDate > '1/1/1998';

-- 20. List the names of all customers with most recent order dates 
-- Author's Note: assuming "most recent order dates" as ten most recent orders
SELECT TOP 10 Customers.ContactName AS 'Customer Name', Orders.ShippedDate AS 'Order Date'
	FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
WHERE Orders.ShippedDate <= DATEADD(year, 0, GETDATE())
ORDER BY Orders.ShippedDate DESC;

-- 21. Display the names of all customers along with the count of products they bought 
SELECT Customers.ContactName AS 'Customer Name', COUNT(Products.ProductID) AS 'Number of Products'
FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	INNER JOIN dbo.Products AS Products
	ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.ContactName;

-- 22. Display the customer ids who bought more than 100 Products with count of products.
SELECT Customers.CustomerID AS 'Customer ID', COUNT(Products.ProductID) AS 'Number of Products'
FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	INNER JOIN dbo.Products AS Products
	ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.CustomerID
HAVING COUNT(Products.ProductID) > 100;

-- 23. List all of the possible ways that suppliers can ship their products
SELECT Suppliers.CompanyName AS 'Supplier Company Name', Shippers.CompanyName AS 'Shipping Company Name'
FROM dbo.Suppliers AS Suppliers
	CROSS JOIN dbo.Shippers AS Shippers;

-- 24. Display the products order each day. Show Order date and Product Name.
SELECT Orders.OrderDate AS 'Order Date', Products.ProductName AS 'Product Name'
FROM dbo.Products AS Products
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Products.ProductID = OrderDetails.ProductID
	INNER JOIN dbo.Orders AS Orders
	ON OrderDetails.OrderID = Orders.OrderID
ORDER BY Orders.OrderDate DESC;

-- 25. Displays pairs of employees who have the same job title.
SELECT Employees.LastName, Employees2.LastName, Employees.Title
FROM dbo.Employees AS Employees, dbo.Employees AS Employees2
WHERE Employees.Title = Employees2.Title AND Employees.EmployeeID != Employees2.EmployeeID;

-- 26. Display all the Managers who have more than 2 employees reporting to them.
SELECT (Employee.FirstName + ' ' + Employee.LastName) AS 'Manager'
FROM dbo.Employees AS Employee
WHERE Employee.ReportsTo IS NULL OR Employee.Title LIKE '%Manager';

-- 27. Display the customers and suppliers by city. The results should have the following columns
SELECT Customers.City AS 'City Name', Customers.ContactName AS 'Customer Contact Name',
	CASE 
		WHEN Customers.ContactTitle = Suppliers.ContactTitle THEN 'Supplier'
		ELSE 'Customer'
	END AS 'Type'
FROM dbo.Customers AS Customers
	INNER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	INNER JOIN dbo.Products AS Products
	ON OrderDetails.ProductID = Products.ProductID
	INNER JOIN dbo.Suppliers AS Suppliers
	ON Products.SupplierID = Suppliers.SupplierID;

-- 28. Inner join two tables T1 and T2
-- Author's Note: T1 and T2 are example tables presented in the Doc file and therefore do not exist.

SELECT tee1.F1 AS teef1, tee2.F2 AS teef2
FROM T1 AS tee1
	INNER JOIN T2 AS tee2
	ON tee1.F1 = tee2.F2;

/* The result of Inner Joining T1 and T2 is a one row, two
 * column table - column names teef1 and teef2 - with both column cells
 * equal to integer three.
 */

 -- 29. Left Outer Join tables T1 and T2
 SELECT tee1.F1 AS teef1, tee2.F2 AS teef2
FROM T1 AS tee1
	LEFT OUTER JOIN T2 AS tee2
	ON tee1.F1 = tee2.F2;

/* The result of Inner Joining T1 and T2 is a three row, two
 * column table - column names teef1 and teef2. The column teef1 has all
 * values from table T1 while teef2 has only one value, integer 3. The row
 * with the values of integer 3 line up in both teef1 and teef2. The rows
 * that do not match teef1 from teef2 have the value NULL.
 */

