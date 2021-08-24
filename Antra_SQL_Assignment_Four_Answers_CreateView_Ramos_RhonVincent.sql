/* This .sql file holds all responses for the View
 * section of the SQL Assignment Part Four doc.
 *
 * Author: Rhon Vincent Ramos 
 */

-- 4. Create a new View named "view_product_order_[your_last_name]," then list all
--    products and total ordered quantity for that product
CREATE VIEW view_product_order_Ramos
AS
SELECT DISTINCT Products.ProductName AS 'Product Name', SUM(OrderDetails.Quantity) AS 'Product Quantity'
FROM dbo.Products AS Products
	INNER JOIN dbo."Order Details" AS OrderDetails
	ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName;

SELECT * FROM view_product_order_Ramos;

DROP VIEW view_product_order_Ramos;

-- 5.Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accepts 
--   product id as an input and total quantities of order as output parameter.
CREATE PROCEDURE sp_product_order_quantity_Ramos 
	@ProductID int,
	@ProductQuantity int OUTPUT
AS
SET @ProductQuantity = 
( 
	SELECT SUM(OrderDetails.Quantity) AS Product_Quantity
	FROM dbo.Products AS Products
		INNER JOIN dbo."Order Details" AS OrderDetails
		ON Products.ProductID = OrderDetails.ProductID
	WHERE Products.ProductID = @ProductID
	GROUP BY Products.ProductID
)
RETURN @ProductQuantity;

EXEC sp_product_order_quantity_Ramos 10, 0;

DROP PROCEDURE sp_product_order_quantity_Ramos;

-- 6. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input 
--    and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
CREATE PROCEDURE sp_product_order_city_Ramos
	@ProductName VARCHAR(30),
	@ProductCityQuantity int OUTPUT
AS
SET @ProductCityQuantity = 
(	
	SELECT TOP 5 SUM(OrderDetails.Quantity) AS 'Top Five Most Quantity of Product by City'
	FROM dbo.Products AS Products
		INNER JOIN dbo."Order Details" AS OrderDetails
		ON Products.ProductID = OrderDetails.ProductID
	WHERE Products.ProductName = @ProductName
	GROUP BY Products.ProductID
);

EXEC sp_product_order_city_Ramos ' ', 0;

DROP PROCEDURE sp_product_order_city_Ramos;

-- 7. Lock tables Region, Territories, EmployeeTerritories and Employees. 
/*    Create a stored procedure "sp_move_employees_[your_last_name]" that automatically find all employees in territory "Troy; " 
 *    if more than 0 found, insert a new territory "Stevens Point" of region “North” to the database, 
 *    and then move those employees to "Stevens Point."
 */

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

CREATE PROCEDURE sp_move_employees_Ramos
AS
DECLARE @EmployeeCount int
SET @EmployeeCount = 
(
	SELECT COUNT(*)
	FROM dbo.Employees AS Employees
		INNER JOIN dbo.EmployeeTerritories AS EmployeeTerritories
		ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
		INNER JOIN dbo.Territories AS Territories
		ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
	WHERE Territories.TerritoryDescription = 'Troy'
)

IF @EmployeeCount > 0
		INSERT INTO dbo.Territories (TerritoryID, TerritoryDescription, RegionID)
		VALUES (99999, 'Stevens Point', 4)

		DELETE FROM dbo.EmployeeTerritories WHERE EmployeeID IN (			
			SELECT Employees.EmployeeID 
			FROM dbo.Employees AS Employees
		 		INNER JOIN dbo.EmployeeTerritories AS EmployeeTerritories
				ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
				INNER JOIN dbo.Territories AS Territories
				ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
			WHERE Territories.TerritoryDescription = 'Troy')

		INSERT INTO dbo.EmployeeTerritories (EmployeeID, TerritoryID)
			SELECT Employees.EmployeeID, 99999
			FROM dbo.Employees AS Employees
		 		INNER JOIN dbo.EmployeeTerritories AS EmployeeTerritories
				ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
				INNER JOIN dbo.Territories AS Territories
				ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
			WHERE Territories.TerritoryDescription = 'Troy'


		/*
		UPDATE dbo.EmployeeTerritories
		SET dbo.EmployeeTerritories.TerritoryID = 
		(
			SELECT Territories.TerritoryID
			FROM dbo.Territories AS Territories
			WHERE Territories.TerritoryDescription = 'Stevens Point'
		)
		WHERE dbo.EmployeeTerritories.EmployeeID IN
		(
			SELECT Employees.EmployeeID
			FROM dbo.Employees AS Employees
		 		INNER JOIN dbo.EmployeeTerritories AS EmployeeTerritories
				ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
				INNER JOIN dbo.Territories AS Territories
				ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
			WHERE Territories.TerritoryDescription = 'Troy'
		)*/;		
EXEC sp_move_employees_Ramos;

DROP PROCEDURE sp_move_employees_Ramos;
UPDATE dbo.Territories SET TerritoryID = 48084 WHERE TerritoryID = 99999;
DELETE FROM dbo.Territories WHERE TerritoryDescription = 'Stevens Point';

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 9. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. 
--    People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. 
--    Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. 
--    If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.

-- Create people_Ramos
CREATE TABLE people_Ramos
(
	Id int,
	Name VARCHAR(30),
	City VARCHAR(30)
);
INSERT INTO people_Ramos 
VALUES (1, 'Aaron Rodgers', 2), (2, 'Russell Wilson', 1), (3, 'Jody Nelson', 2);

-- Create city_Ramos
CREATE TABLE city_ramos
(
	Id int,
	City VARCHAR(30)
);
INSERT INTO city_Ramos
VALUES (1, 'Seattle'), (2, 'Green Bay');

-- Delete Seattle
DELETE FROM city_Ramos WHERE Id = 1;

-- Adding Madison
INSERT INTO city_Ramos
VALUES (3, 'Madison')

-- Updating People to new City
UPDATE people_Ramos
SET City = 3
WHERE City = 1;

--Create VIEW
CREATE VIEW packers_Ramos
AS
SELECT Name 
FROM people_Ramos
WHERE City = 2;

-- Drop tables and view
DROP TABLE people_Ramos;
DROP TABLE city_Ramos;
DROP VIEW packers_Ramos;

-- 10. Create a Stored Procedure "sp_birthday_employee_Ramos" that creates a
--     new table "birthday_employees_your_last_name" and fill it with all employees
--     have a birthday on Feb. Screenshot then drop the table. The Employee table
--     should not be affected.

CREATE PROCEDURE sp_birthday_employee_Ramos
AS
CREATE TABLE dbo.birthday_employees_Ramos
(
	LastName VARCHAR(30)
)

INSERT INTO birthday_employees_ramos (LastName)
	SELECT Employees.LastName
	FROM dbo.Employees AS Employees
	WHERE MONTH(Employees.BirthDate) = 02;

EXEC sp_birthday_employee_Ramos;
SELECT * FROM birthday_employees_Ramos;
DROP PROCEDURE sp_birthday_employee_Ramos;
DROP TABLE birthday_employees_Ramos;

-- 11. Create a stored procedure named “sp_your_last_name_1” that returns all cities that have at least 2 customers who have bought no or only one kind of product. 
--     Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different approach. (sub-query and no-sub-query).

-- With Subquery
CREATE PROCEDURE sp_Ramos_1
AS
SELECT CustomerSubquery.City
FROM 
(
	SELECT Customers.City AS City
	FROM dbo.Customers AS Customers
		LEFT OUTER JOIN dbo.Orders AS Orders
		ON Customers.CustomerID = Orders.CustomerID
		LEFT OUTER JOIN dbo."Order Details" AS OrderDetails
		ON Orders.OrderID = OrderDetails.OrderID
		LEFT OUTER JOIN dbo.Products AS Products
		ON OrderDetails.ProductID = Products.ProductID
	GROUP BY Customers.City, OrderDetails.Quantity
	HAVING COUNT(Customers.CustomerID) >= 2 AND (COUNT(DISTINCT Products.ProductID) IS NULL OR COUNT(DISTINCT Products.ProductID) = 1)
) AS CustomerSubQuery;

DROP PROCEDURE sp_Ramos_1;

-- No Subquery
CREATE PROCEDURE sp_Ramos_2
AS
SELECT Customers.City
FROM dbo.Customers AS Customers
	LEFT OUTER JOIN dbo.Orders AS Orders
	ON Customers.CustomerID = Orders.CustomerID
	LEFT OUTER JOIN dbo."Order Details" AS OrderDetails
	ON Orders.OrderID = OrderDetails.OrderID
	LEFT OUTER JOIN dbo.Products AS Products
	ON OrderDetails.ProductID = Products.ProductID
GROUP BY Customers.City, OrderDetails.Quantity
HAVING COUNT(Customers.CustomerID) >= 2 AND (COUNT(DISTINCT Products.ProductID) IS NULL OR COUNT(DISTINCT Products.ProductID) = 1);

DROP PROCEDURE sp_Ramos_2;

-- 12. How do you make sure that two tables have the same data?
/* We can use the MINUS keyword to see if it returns an empty result set. An empty result set from MINUS means
 * that both tables are exactly alike.
 */

-- 13. Transform the tables.
-- Author's Note: assumes sample table is named 'Names'
CREATE TABLE Full_Name
(
	FullName VARCHAR(40)
)

INSERT INTO Full_Name
SELECT CASE
	WHEN Middle_Name IS NULL
		THEN (First_Name + ' ' + Last_Name) AS fullName
	ELSE
		THEN (First_Name + ' ' + Last_Name + ' ' + Middle_Name + '.') AS fullName
FROM Names;

-- 14. Find top marks of female students in sample table.
SELECT TOP 1 MAX(Marks)
FROM Students
WHERE Sex = 'F';

-- 15. How do you output the sample table?
SELECT *
FROM Students
ORDER BY Sex, Marks;







