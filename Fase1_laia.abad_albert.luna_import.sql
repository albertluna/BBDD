DROP TABLE IF EXISTS CustomersOrders;
CREATE TABLE CustomersOrders (
	OrderDate			DATE,
	RequiredDate		DATE,
	ShippedDate			DATE,
	OrderFreight		REAL,
	OrderShipName		VARCHAR(255),
	OrderShipAddress	VARCHAR(255),
	OrderShipCity		VARCHAR(255),
	OrderShipRegion		VARCHAR(255),
	OrderShipPostalCode	VARCHAR(255),
	OrderShipCountry	VARCHAR(255),
	CompanyName			VARCHAR(255),
	ContactName			VARCHAR(255),
	ContactTitle		VARCHAR(255),
	Address				VARCHAR(255),
	City				VARCHAR(255),
	Region				VARCHAR(255),
	PostalCode			VARCHAR(255),
	Country				VARCHAR(255),
	Phone				VARCHAR(255),
	Phone2				VARCHAR(255)
);

COPY CustomersOrders FROM '/CustomersOrders.csv' CSV HEADER DELIMITER ',';


DROP TABLE IF EXISTS EmployeesSales;
CREATE TABLE EmployeesSales (
	OrderDate				DATE,
	RequiredDate			DATE,
	ShippedDate				DATE,
	OrderFreight			REAL,
	OrderShipName			VARCHAR(255),
	OrderShipAddress		VARCHAR(255),
	OrderShipCity			VARCHAR(255),
	OrderShipRegion			VARCHAR(255),
	OrderShipPostalCode		VARCHAR(255),
	OrderShipCountry		VARCHAR(255),
	EmployeeID				INTEGER,
	LastName				VARCHAR(255),
	FirstName				VARCHAR(255),
	Title					VARCHAR(255),
	TitleOfCourtesy			VARCHAR(255),
	BirthDate				DATE,
	HireDate				DATE,
	Address					VARCHAR(255),
	City					VARCHAR(255),
	Region					VARCHAR(255),
	PostalCode				VARCHAR(255),
	Country					VARCHAR(255),
	HomePhone				VARCHAR(255),
	Extension				INTEGER,
	Photo					VARCHAR(255),
	Notes					TEXT,
	ReportsTo				INTEGER,
	PhotoPath				VARCHAR(255),
	EmployeeID1				INTEGER,
	TerritoryID				INTEGER,
	TerritoryID1			INTEGER,
	TerritoryDescription	VARCHAR(255),
	RegionID				INTEGER,
	RegionID1				INTEGER,
	RegionDescription		VARCHAR(255)
);

COPY EmployeesSales FROM '/EmployeesSales.csv' CSV HEADER DELIMITER ',';


DROP TABLE IF EXISTS ProductsOrdered;
CREATE TABLE ProductsOrdered (
	OrderDate					DATE,
	RequiredDate				DATE,
	ShippedDate					DATE,
	OrderFreight				REAL,
	OrderShipName				VARCHAR(255),
	OrderShipAddress			VARCHAR(255),
	OrderShipCity				VARCHAR(255),
	OrderShipRegion				VARCHAR(255),
	OrderShipPostalCode			VARCHAR(255),
	OrderShipCountry			VARCHAR(255),
	OrderUnitPrice				REAL,
	OrderQuantity				INTEGER,
	OrderDiscount				REAL,
	shippercompanyname			VARCHAR(255),
	ShipperPhone				VARCHAR(255),
	ProductName					VARCHAR(255),
	QuantityPerUnitOfProduct	VARCHAR(255),
	UnitPriceOfProduct			REAL,
	UnitsInStockOfProduct		INTEGER,
	UnitsOnOrderOfProduct		INTEGER,
	ProductReorderLevel			INTEGER,
	DiscontinuedProduct			BOOLEAN,
	SupplierCompanyName			VARCHAR(255),
	SupplierContactName			VARCHAR(255),
	SupplierContactTitle		VARCHAR(255),
	SupplierAddress				VARCHAR(255),
	SupplierCity				VARCHAR(255),
	SupplierRegion				VARCHAR(255),
	supplierpostalcode			VARCHAR(255),
	SupplierCountry				VARCHAR(255),
	SupplierPhone				VARCHAR(255),
	SupplierPhone2				VARCHAR(255),
	SupplierHomePage			VARCHAR(255),
	CategoryName				VARCHAR(255),
	CategoryDescription			VARCHAR(255),
	CategoryPicture				VARCHAR(255)
);

COPY ProductsOrdered FROM '/ProductsOrdered.csv' CSV HEADER DELIMITER ',';
