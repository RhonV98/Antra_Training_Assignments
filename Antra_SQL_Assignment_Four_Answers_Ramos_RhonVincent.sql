/* This .sql file holds all responses for each question 
 *in the SQL Assignment Four doc file.
 *
 *Author: Rhon Vincent Ramos 
 */

-- 1. What is a View? What are its benefits?
/* A View is sort of a "virtual table:" it is a query-retrieved table, with its own rows and columns, 
 * but it does not exist within the database itself. This is beneficial because a View can be used
 * to filter data as precisely as a subquery. Also, a View allows external parties to see the data
 * stored in a database without allowing those parties access to the database itself.
 */

-- 2. Can data be modified through Views?
/* A View by itself cannot modify the database because the table does not exist in the database. Only through
 * giving the table a unique index can it be considered part of the database. However, a user can use Views
 * as a filter, much like a WHERE clause, to modify data that matches the values inside the View.
 */

-- 3. What is a Stored Procedure? What are its benefits?
/* A Stored Procudure is a "group of one or more Transact-SQL statements fit into one logical unit." These
 * Procedures provide massive benefit to a query because they allow faster query execution and further database
 * security. 
 */

-- 4. What is the difference between a View and a Stored Procedure?
/* A generic View is a table that shows values inside one or more tables. 
 * Meanwhile, a Stored Procedure is a logical unit that groups several SQL statements and runs them all at once
 * when executed.
 */
 
-- 5. What is the difference between a Stored Procedure and a Function?
/* A Stored Procedure does not need a return type while a Function does.
 */

-- 6. Can a Stored Procedure return multiple result sets?
/* So long as the Transact-SQL statements within a Store Procedure are valid, SPs can return
 * as many result sets as the user requires.
 */

-- 7. Can a Stored Procedure be executed as part of a SELECT statment? Why?
/* Stored Procedures can only be executed if, one, they are in the first line in an SQL batch or,
 * two, if preceded by an EXEC or EXECUTE keyword. Therefore, they cannot be executed as part of a 
 * SELECT statement.
 */

-- 8. What is a Trigger? What types of Triggers are there?
/* Triggers are a unique type of Stored Procedures that executed only after a specific event. They are automatically
 * executed and cannot be explicitly executed. There are three types: INSERT, DELETE, and UPDATE.
 */

-- 9. What are the scenarios to use Triggers?
/* Triggers are used to further enforce database integrity, implement business rules, and accomplish a large series
 * UPDATEs and DELETEs.
 */

-- 10. What is the difference between Trigger and Stored Procedure?
/* They are functionally identical. However, Triggers are automatic, are event-driven, and are used only to make
 * database changes. Stored Procedures, on the other hand, must be explicitly called but can also return and change
 * data.
 */

-- Part Two: using Northwind Database.
-- 1. Lock tables Region, Territories, EmployeeTerritories, and Employees. 
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT * FROM dbo.Employees AS Employees;
SELECT * FROM dbo.EmployeeTerritories AS EmployeeTerritories;
SELECT * FROM dbo.Region AS Region;
SELECT * FROM dbo.Territories AS Territories ORDER BY Territories.RegionID;

-- 1a. Insert a new Region called "Middle Earth."
INSERT INTO Region (Region.RegionID, Region.RegionDescription) 
VALUES (5, 'Middle Earth');

-- 1b. Insert a new Territory called "Gondor," which belongs to Region "Middle Earth."
INSERT INTO Territories (Territories.TerritoryID, Territories.TerritoryDescription, Region.RegionID)
VALUES (24689, 'Gondor', 5);

-- 1c. Insert a new Employee "Aragorn King," who's Territory is "Gondor."
-- Author's Note: implicitly sets unlisted values
SET IDENTITY_INSERT dbo.Employees ON;

INSERT INTO Employees (Employee.EmployeeID, LastName, FirstName)
VALUES (10, 'King', 'Aragorn');

INSERT INTO EmployeeTerritories (EmployeeTerritories.EmployeeID, Territories.TerritoryID)
VALUES (10, 24689);

-- 2. Change Territory "Gondor" to "Arnor."
UPDATE Territories
SET TerritoryDescription = 'Arnor'
WHERE TerritoryDescription = 'Gondor';

-- 3. Delete Region "Middle Earth," then unlock the tables.
DELETE FROM dbo.EmployeeTerritories 
WHERE EmployeeID = 10;

DELETE FROM dbo.Employees
WHERE EmployeeID = 10;

DELETE FROM dbo.Territories
WHERE RegionID = 5;

DELETE FROM dbo.Region
WHERE RegionID = 5;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


 
