/* This .sql file holds all the statements
 * necessary to satisfy the question requirements
 * in the Database Questions Doc file.
 *
 * Author: Rhon Vincent Ramos
 */
 
-- 1. Design a Database for a company to manage all of its projects.
USE master;
GO
CREATE DATABASE Company_Data
ON
(
	NAME = Company_dat,
	FILENAME = 'C:\Users\Ronnie\Documents\Job Files\Antra Training\Training Databases\companydat.mdf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
LOG ON
(
	NAME = Company_dat_log,
	FILENAME = 'C:\Users\Ronnie\Documents\Job Files\Antra Training\Training Databases Logs\companydatlog.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)

CREATE TABLE Countries
(
	CountryID int NOT NULL,
	OfficeID  int NOT NULL,

	CountryName VARCHAR(99),
	OfficeName  VARCHAR(99),

	CONSTRAINT PK_Country PRIMARY KEY (CountryID)
)

CREATE TABLE HeadOffices
(
	OfficeID int NOT NULL,

	OfficeName  VARCHAR(99),
	CityName    VARCHAR(99),
	CountryName VARCHAR(99),
	
	OfficeAddress      VARCHAR(99),
	OfficePhoneNumber  VARCHAR(15),
	OfficeDirectorName VARCHAR(99),

	CONSTRAINT PK_HeadOffice PRIMARY KEY (OfficeID)
)

CREATE TABLE Projects
(
	ProjectID int NOT NULL,

	ProjectName      VARCHAR(99),
	ProjectCityName  VARCHAR(99),
	ProjectLeadName  VARCHAR(99),

	ProjectStartDate date,
	ProjectEndDate   date,

	CityID int NOT NULL,

	Budget MONEY,

	CONSTRAINT PK_Project PRIMARY KEY (ProjectID)
)

CREATE TABLE Cities
(
	CityID int NOT NULL,

	CityName    VARCHAR(99),
	CountryName VARCHAR(99),

	Population int NOT NULL,

	CONSTRAINT PK_City PRIMARY KEY (CityID)
)


-- 2. Design a Database for a lending company which manages lending among people (p2p lending)
USE master;
GO
CREATE DATABASE Lending_Company_Data
ON
(
	NAME = Lending_Company_dat,
	FILENAME = 'C:\Users\Ronnie\Documents\Job Files\Antra Training\Training Databases\lendingcompanydat.mdf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
LOG ON
(
	NAME = Lending_Company_dat_log,
	FILENAME = 'C:\Users\Ronnie\Documents\Job Files\Antra Training\Training Databases Logs\lendingcompanydatlog.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)

CREATE TABLE Lenders
(
	LenderID int NOT NULL,
	LenderName VARCHAR(99),
	LenderBudget MONEY,

	LoanID int NOT NULL,

	CONSTRAINT PK_Lender PRIMARY KEY (LenderID)
)

CREATE TABLE Borrowers
(
	BorrowerID int NOT NULL,
	BorrowerName VARCHAR(99),

	Risk VARCHAR(99),

	LoanID int NOT NULL,

	CONSTRAINT PK_Borrower PRIMARY KEY (BorrowerID)
)

CREATE TABLE Loans
(
	LoanID int NOT NULL,
	LoanAmount MONEY,
	LoanRefundDeadline date,
	LoanInterestRate decimal(5,2),
	LoanDescription VARCHAR(300),

	CONSTRAINT PK_Loan PRIMARY KEY (LoanID)
)


-- 3. Design a database to maintain the menu of a restaurant
USE master;
GO
CREATE DATABASE Restaurant_Data
ON
(
	NAME = Restaurant_dat,
	FILENAME = 'C:\Users\Ronnie\Documents\Job Files\Antra Training\Training Databases\restaurantdat.mdf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)
LOG ON
(
	NAME = Restaurant_dat_log,
	FILENAME = 'C:\Users\Ronnie\Documents\Job Files\Antra Training\Training Databases Logs\restaurantdatlog.ldf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)

CREATE TABLE Courses
(	
	CourseName VARCHAR(99) NOT NULL,
	CourseDescription VARCHAR(300),
	CoursePhoto image,
	CoursePrice MONEY,

	CONSTRAINT PK_Course PRIMARY KEY (CourseName)
)

CREATE TABLE CourseCategories
(
	CategoryName VARCHAR(99) NOT NULL,
	CategoryDescription VARCHAR(300),

	EmployeeName VARCHAR(99) NOT NULL,

	CONSTRAINT PK_CourseCategory PRIMARY KEY (CategoryName)
)

CREATE TABLE Recipies
(
	RecipeName VARCHAR(99) NOT NULL,

	IngredientName VARCHAR(99) NOT NULL,
	IngredientRequiredAmount int NOT NULL,

	MeasurementUnit VARCHAR(99),

	IngredientAmountInStore int,

	CONSTRAINT PK_Recipies PRIMARY KEY (RecipeName
)