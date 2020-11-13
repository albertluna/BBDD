--1
SELECT e.FirstName AS "FirstName", e.LastName AS "LastName", 
COUNT(po.Discount) AS "Times has Discounted", CONCAT(ROUND(SUM(po.Discount)*100), '%') AS "Sum of Discounts"
FROM employee AS e, Product_order AS po, Orders AS o
WHERE e.EmployeeID = o.Employee AND o.OrderID = po.OrderID AND po.Discount > 0
AND e.Address IN (SELECT h.Address FROM House AS h, Company AS co, Customer AS cu
WHERE h.City = co.City AND co.CompanyName = cu.CompanyName
AND o.Customer = cu.CompanyName) 
GROUP BY e.EmployeeID
ORDER BY "Times has Discounted" DESC LIMIT 1;

--2 
SELECT e.FirstName AS "FirstName", e.LastName AS "LastName", (SUM(po.Discount)/COUNT(*)) AS proportion
FROM Employee AS e, Orders AS o, Product_Order AS po, Product AS pr
WHERE e.EmployeeID = o.Employee AND o.OrderID = po.OrderID AND po.ProductID = pr.ProductID
GROUP BY e.EmployeeID
ORDER BY proportion DESC LIMIT 1;

--3 
SELECT 	o.OrderID, o.Customer, o.OrderDate, SUM(pr.UnitPrice*po.OrderQuantity*(1-po.discount)) AS Subtotal 
FROM Orders AS o, Product_order AS po, Product AS pr
WHERE o.OrderID = po.OrderID AND po.ProductID = pr.ProductID
GROUP BY o.OrderID
ORDER BY Subtotal DESC;

--4																						 
SELECT ca.Name AS CategoryName, ROUND(SUM(pr.UnitPrice*po.OrderQuantity*(1-po.Discount))) AS "Gross Profit"
FROM Category AS ca, Product AS pr, Product_order AS po, Orders AS o
WHERE ca.Name = pr.Category AND pr.ProductID = po.ProductID AND o.OrderID = po.OrderID
AND EXTRACT(YEAR FROM o.ShippedDate) = 1998
GROUP BY CategoryName
ORDER BY "Gross Profit" DESC;
															  																				  
--5 
SELECT OrderDate AS "OrderDate", COUNT(DISTINCT o.orderID) AS ordersdelivered
FROM Orders AS o, Product_order AS po, Product AS pr
WHERE o.OrderID = po.OrderID AND po.ProductID = pr.ProductID
GROUP BY OrderDate
HAVING SUM(po.OrderQuantity) > 320
ORDER BY ordersdelivered DESC, OrderDate ASC LIMIT 3;
													  
--6 																	 
SELECT CompanyName AS "CompanyName", (SELECT (SUM(po.OrderQuantity+0.0)*100/SUM(po2.OrderQuantity+0.0)) FROM Product_Order AS po2) AS p
FROM Shipper AS s, Orders AS o, Product_Order AS po
WHERE s.CompanyName = o.Shipper AND o.OrderID = po.OrderID
GROUP BY CompanyName
ORDER BY p DESC;
	
--7
DROP TABLE IF EXISTS Languages CASCADE;
CREATE TABLE Languages (
	Language	VARCHAR(255),
	n			INTEGER
);
	
INSERT INTO Languages (Language, n)
VALUES ('French', SELECT SUM(CASE WHEN Notes LIKE '%French%' then 1 else 0 end) FROM Employee)),
('Spanish', 		(SELECT SUM(CASE WHEN Notes LIKE '%Spanish%' then 1 else 0 end) FROM Employee)),
('Japanese', 		(SELECT SUM(CASE WHEN Notes LIKE '%Japanese%' then 1 else 0 end) FROM Employee)),
('Portuguese', 		(SELECT SUM(CASE WHEN Notes LIKE '%Portuguese%' then 1 else 0 end) FROM Employee)),
('German', 			(SELECT SUM(CASE WHEN Notes LIKE '%German%' then 1 else 0 end) FROM Employee)), 
('Italian', 		(SELECT SUM(CASE WHEN Notes LIKE '%Italian%' then 1 else 0 end) FROM Employee));
			 
SELECT Language, n 
FROM Languages
ORDER BY n DESC;
			 
DROP TABLE Languages;
	
--8					 
SELECT COUNT(po.ProductID) AS n, po.ProductID, ProductName
FROM Product_order AS po, Product AS p
WHERE p.ProductID = po.ProductID
GROUP BY po.ProductID, ProductName
ORDER BY n DESC 
LIMIT 1;
	
--9 
SELECT OrderID, ProductID
FROM Product_order AS po
WHERE OrderID = ANY(SELECT OrderID 
FROM Product_order 
WHERE ProductID = ANY (SELECT po.ProductID
FROM Product_order AS po, Product AS p
WHERE p.ProductID = po.ProductID
GROUP BY po.ProductID
ORDER BY COUNT(po.ProductID) DESC 
LIMIT 1));

--10. Troba el producte que mes s'ha comprat a cada pais i quants se n'ha comprat, ordenat de mes productes comprats a menys				   
SELECT pr.ProductName, co.Country, SUM(po.OrderQuantity) AS suma
FROM Product AS pr, Product_order AS po, Company AS co, Orders AS o
WHERE pr.ProductID = po.ProductID AND po.OrderID = o.OrderID AND o.Customer = co.CompanyName 
GROUP BY co.Country, po.ProductID, pr.ProductName
HAVING SUM(po.OrderQuantity) >= ALL (SELECT SUM(po2.OrderQuantity) FROM Product_order AS po2, Orders AS o2, 
Company AS co2 WHERE po2.OrderID = o2.OrderID AND o2.Customer = co2.CompanyName AND 
po.ProductID <> po2.ProductID AND co2.Country = co.Country
GROUP BY co2.Country, po2.ProductID)
ORDER BY suma DESC;