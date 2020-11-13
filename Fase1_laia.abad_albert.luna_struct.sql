DROP TABLE IF EXISTS Company CASCADE;
CREATE TABLE Company (
	CompanyName		VARCHAR(255),
	Address			VARCHAR(255),
	City			VARCHAR(255),
	Region			VARCHAR(255),
	PostalCode		VARCHAR(255),
	Country			VARCHAR(255),
	PRIMARY KEY (CompanyName)
				 
);

DROP TABLE IF EXISTS Supplier CASCADE;
CREATE TABLE Supplier (
	CompanyName 	VARCHAR(255),
	HomePage		VARCHAR(255),
	PRIMARY KEY (CompanyName),
	FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName)
);

DROP TABLE IF EXISTS Customer CASCADE;
CREATE TABLE Customer (
	CompanyName 	VARCHAR(255),
	PRIMARY KEY (CompanyName),
	FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName)
);

DROP TABLE IF EXISTS Shipper CASCADE;
CREATE TABLE Shipper (
	CompanyName	VARCHAR(255),
	Phone		VARCHAR(255),
	PRIMARY KEY (CompanyName),
	FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName)
);

DROP TABLE IF EXISTS Phone CASCADE;
CREATE TABLE Phone (
	Phone		VARCHAR(255),
	CompanyName VARCHAR(255),
	PRIMARY KEY (Phone),
	FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName)
);

DROP TABLE IF EXISTS Category CASCADE;
CREATE TABLE Category (
	Name			VARCHAR(255),
	Description		VARCHAR(255),
	PRIMARY KEY (Name)
);

DROP TABLE IF EXISTS Product CASCADE;
CREATE TABLE Product (	
	ProductID		SERIAL,
	ProductName		VARCHAR(255),
	QuantityPerUnit	VARCHAR(255),
	UnitPrice		REAL,
	UnitsInStock	INTEGER,
	Discontinued	BOOLEAN,
	Category		VARCHAR(255),
	Supplier 		VARCHAR(255),
	ReorderLevel	INTEGER,
	PRIMARY KEY (ProductID),
	FOREIGN KEY (Supplier) REFERENCES Company(CompanyName),
	FOREIGN KEY (Category) REFERENCES Category(Name)
);

DROP TABLE IF EXISTS Contact CASCADE;
CREATE TABLE Contact (
	ContactID	SERIAL,
	Name		VARCHAR(255),
	Title		VARCHAR(255),
	CompanyName	VARCHAR(255),
	PRIMARY KEY (ContactID),
	FOREIGN KEY (CompanyName) REFERENCES Company(CompanyName)
);

DROP TABLE IF EXISTS Employee CASCADE;
CREATE TABLE Employee (
	EmployeeID 		INTEGER,
	FirstName		VARCHAR(255),
	LastName		VARCHAR(255),
	Address			VARCHAR(255),
	Title			VARCHAR(255),
	TitleOfCourtesy	VARCHAR(255),
	BirthDate		DATE,
	HireDate		DATE,
	Notes			TEXT,
	PhotoPath 		VARCHAR(255),
	ReportsTo		INTEGER,
	PRIMARY KEY (EmployeeID),
	FOREIGN KEY (ReportsTo) REFERENCES Employee(EmployeeID),
	FOREIGN KEY (Address) REFERENCES House(Address)
);

DROP TABLE IF EXISTS House CASCADE;
CREATE TABLE House (
	Address		VARCHAR(255),
	Extension	INT,
	Phone		VARCHAR(255),
	Country		VARCHAR(255),
	City		VARCHAR(255),
	PostalCode	VARCHAR(255),
	PRIMARY KEY (Address)
);

DROP TABLE IF EXISTS Region CASCADE;
CREATE TABLE Region (
	RegionID 	INTEGER,
	Description	VARCHAR(255),
	PRIMARY KEY (RegionID)
);

DROP TABLE IF EXISTS Territory CASCADE;
CREATE TABLE Territory (
	TerritoryID	INTEGER,
	Region		INTEGER,
	Description	VARCHAR(255),
	PRIMARY KEY (TerritoryID),
	FOREIGN KEY (Region) REFERENCES Region(RegionID)
);

DROP TABLE IF EXISTS Works CASCADE;
CREATE TABLE Works (
	Employee	INTEGER,
	Territory	INTEGER,
	PRIMARY KEY (Employee, Territory),
	FOREIGN KEY (Employee) REFERENCES Employee(EmployeeID),
	FOREIGN KEY (Territory) REFERENCES Territory(TerritoryID)
);

DROP TABLE IF EXISTS Orders CASCADE;
CREATE TABLE Orders (
	OrderID			SERIAL,
	Customer 		VARCHAR(255),
	Shipper 		VARCHAR(255),
	OrderDate		DATE,
	RequiredDate	DATE,
	ShippedDate		DATE,
	Employee		INT,
	Freight			REAL,
	PRIMARY KEY (OrderID),
	FOREIGN KEY (Customer) REFERENCES Company(CompanyName),	
	FOREIGN KEY (Shipper) REFERENCES Shipper(CompanyName),
	FOREIGN KEY (Employee) REFERENCES Employee(EmployeeID)
);

DROP TABLE IF EXISTS Product_order CASCADE;
CREATE TABLE Product_order (
	OrderID			INT,
	ProductID		INT,
	Discount		REAL,
	OrderQuantity	INT,
	PRIMARY KEY (OrderID, ProductID),
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

INSERT INTO Company (CompanyName, Address, City, Region, PostalCode, Country)
SELECT DISTINCT CompanyName, Address, City, Region, PostalCode, Country 
FROM CustomersOrders;

INSERT INTO Company (CompanyName, Address, City, Region, PostalCode, Country)
SELECT DISTINCT SupplierCompanyName, SupplierAddress, SupplierCity, SupplierRegion, supplierpostalcode, SupplierCountry 
FROM ProductsOrdered;

INSERT INTO Company (CompanyName)
SELECT DISTINCT shippercompanyname
FROM ProductsOrdered;

INSERT INTO Supplier (CompanyName, HomePage)
SELECT DISTINCT SupplierCompanyName, SupplierHomePage
FROM ProductsOrdered;

INSERT INTO Customer (CompanyName)
SELECT DISTINCT CompanyName
FROM CustomersOrders;

INSERT INTO Shipper (CompanyName, Phone)
SELECT DISTINCT shippercompanyname, ShipperPhone
FROM ProductsOrdered;

INSERT INTO Phone (CompanyName, Phone)
SELECT DISTINCT SupplierCompanyName, SupplierPhone
FROM ProductsOrdered;

INSERT INTO Phone (CompanyName, Phone)
SELECT DISTINCT SupplierCompanyName, SupplierPhone2
FROM ProductsOrdered
WHERE SupplierPhone2 IS NOT NULL;

INSERT INTO Phone (CompanyName, Phone)
SELECT DISTINCT CompanyName, Phone
FROM CustomersOrders;

INSERT INTO Phone (CompanyName, Phone)
SELECT DISTINCT CompanyName, Phone2
FROM CustomersOrders
WHERE Phone2 IS NOT NULL AND Phone2 <> Phone;

INSERT INTO Category (Name, Description)
SELECT DISTINCT CategoryName, CategoryDescription
FROM ProductsOrdered;
																	   
INSERT INTO Product (ProductName, Discontinued, QuantityPerUnit, UnitPrice, UnitsInStock, Category, Supplier, ReorderLevel)
SELECT DISTINCT ProductName, DiscontinuedProduct, QuantityPerUnitOfProduct,
UnitPriceOfProduct, UnitsInStockOfProduct, CategoryName, SupplierCompanyName, ProductReorderLevel
FROM ProductsOrdered;

INSERT INTO Contact (Name, Title, CompanyName)
SELECT DISTINCT ContactName, ContactTitle, CompanyName 
FROM CustomersOrders;

INSERT INTO Employee (EmployeeID, FirstName, LastName, Address, Title, TitleOfCourtesy, BirthDate, HireDate, Notes, PhotoPath, ReportsTo)
SELECT DISTINCT EmployeeID, FirstName, LastName, Address ,Title, TitleOfCourtesy, BirthDate, HireDate, Notes, PhotoPath, ReportsTo
FROM EmployeesSales;

INSERT INTO House (Address, Extension, Phone, Country, City, PostalCode)
SELECT DISTINCT Address, Extension, HomePhone, Country, City, PostalCode
FROM EmployeesSales;

INSERT INTO Region (RegionID, Description)
SELECT DISTINCT RegionID, RegionDescription
FROM EmployeesSales;

INSERT INTO Territory (TerritoryID, Region, Description)
SELECT DISTINCT TerritoryID, RegionID, TerritoryDescription
FROM EmployeesSales;

INSERT INTO Works (Territory, Employee)
SELECT DISTINCT TerritoryID, EmployeeID
FROM EmployeesSales;

INSERT INTO orders (Customer, OrderDate, RequiredDate, shippeddate, Freight, shipper, employee)
SELECT DISTINCT co.companyname, co.orderdate, co.requireddate, co.shippeddate, co.orderfreight, po.shippercompanyname, employeeID
FROM CustomersOrders AS co, productsordered AS po, employeessales AS ee
WHERE co.orderfreight = po.orderfreight AND co.orderdate = po.orderdate AND po.requireddate = co.requireddate
AND co.shippeddate = po.shippeddate
AND co.orderdate = ee.orderdate AND co.requireddate = ee.requireddate AND co.shippeddate = ee.shippeddate
AND co.orderfreight = ee.orderfreight;

INSERT INTO product_order
SELECT DISTINCT OrderID, ProductID, OrderDiscount, OrderQuantity
FROM Product AS pr, orders AS o, productsordered AS po
WHERE o.orderdate = po.orderdate AND o.shippeddate = po.shippeddate AND o.requireddate = po.requireddate
AND po.orderfreight = o.freight
AND po.productname = pr.productname AND po.quantityperunitofproduct = pr.quantityperunit
AND po.UnitPriceOfProduct = pr.unitprice AND po.unitsinstockofproduct = pr.unitsinstock
AND po.ProductReorderLevel = pr.reorderlevel;