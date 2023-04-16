-- The structure of various types of database queries i.e. querying, inserting, updating, and deletion queries

-- query/ select

SELECT column1, column2, column3, ...
FROM table_name
WHERE condition
GROUP BY column1, column2, ...
HAVING condition
ORDER BY column1, column2, ... ASC|DESC
LIMIT number;

-- insert

INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);

-- update

UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;

-- delete

DELETE FROM table_name
WHERE condition;

-- Responses to SQL questions based on the w3schools database schema

-- 1) Insert a customer in the customers table,view the record and update the record

-- Insert a customer
INSERT INTO Customers (CustomerName, ContactName, Address, City, PostalCode, Country)
VALUES ('Sample Company', 'John Doe', '123 Sample St', 'Sample City', '12345', 'USA');

-- View the record
SELECT * FROM Customers WHERE CustomerName = 'Sample Company';

-- Update the record
UPDATE Customers SET ContactName = 'Jane Doe' WHERE CustomerName = 'Sample Company';

-- 2) Insert an order for the Customer inserted in number 2 above,choose employee and shipper.

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipperID)
VALUES ((SELECT CustomerID FROM Customers WHERE CustomerName = 'Sample Company'), 1, '2023-04-12', 2);

-- 3) Insert a new record in the Products table attach them to an existing supplier and category.

INSERT INTO Products (ProductName, SupplierID, CategoryID, Unit, Price)
VALUES ('Sample Product', 1, 1, '10 boxes x 20 bags', 15.5);

-- 4) Insert an orderdetail using the order in 3 above and product in 4.

INSERT INTO OrderDetails (OrderID, ProductID, Quantity)
VALUES ((SELECT OrderID FROM Orders WHERE CustomerID = (SELECT CustomerID FROM Customers WHERE CustomerName = 'Sample Company')), 
(SELECT ProductID FROM Products WHERE ProductName = 'Sample Product'), 5);

-- 5) Delete Customer whose CustomerID is 56.

DELETE FROM Customers WHERE CustomerID = 56;

-- 6) Show customers who come from brazil or italy.

SELECT * FROM Customers WHERE Country IN ('Brazil', 'Italy');

-- 7) Display Customers who have the word ‘son’ in their CustomerName.

SELECT * FROM Customers WHERE CustomerName LIKE '%son%';

-- 8) Display orders made in the month of October 1996, display in asc order.

SELECT * FROM Orders WHERE OrderDate BETWEEN '1996-10-01' AND '1996-10-31' ORDER BY OrderDate ASC;

-- 9) Find the total orders shipped by each of the 3 shippers.

SELECT ShipperID, COUNT(OrderID) as TotalOrders FROM Orders GROUP BY ShipperID;

-- 10) Display products whose price is above 25.

SELECT * FROM Products WHERE Price > 25;

-- Examples of various types of joins to illustrate their structure

-- Inner Join Example: Suppose we want to retrieve a list of all orders and their associated customer names. We can use an inner join between the Orders and Customers tables based on the CustomerID column. The SQL query would look like this:

SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID;

-- Left Join Example: Suppose we want to retrieve a list of all categories and their associated products, including categories with no products. We can use a left join between the Categories and Products tables based on the CategoryID column. The SQL query would look like this:

SELECT Categories.CategoryName, Products.ProductName
FROM Categories
LEFT JOIN Products
ON Categories.CategoryID = Products.CategoryID;

-- Right Join Example: Suppose we want to retrieve a list of all suppliers and their associated products, including suppliers with no products. We can use a right join between the Products and Suppliers tables based on the SupplierID column. The SQL query would look like this:

SELECT Products.ProductName, Suppliers.SupplierName
FROM Products
RIGHT JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID;

-- Full Outer Join Example: Suppose we want to retrieve a list of all employees and their associated orders, including employees with no orders and orders with no employee. We can use a full outer join between the Employees and Orders tables based on the EmployeeID column. The SQL query would look like this:

SELECT Employees.LastName, Orders.OrderID
FROM Employees
FULL OUTER JOIN Orders
ON Employees.EmployeeID = Orders.EmployeeID;

-- Responses to the questions on joins based on the w3schools databases schema

-- 1) Display a single relation with: OrderId, OrderDate, CustomerName, City, Address, PostalCode, ShipperName, ProductName, Quantity.

SELECT o.OrderID, o.OrderDate, c.CustomerName, c.City, c.Address, c.PostalCode, s.ShipperName, p.ProductName, od.Quantity
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Shippers s ON o.ShipperID = s.ShipperID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

-- 2) Display all products ever been ordered and display the shipper name.

SELECT DISTINCT p.ProductName, s.ShipperName
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
JOIN Shippers s ON o.ShipperID = s.ShipperID;

-- 3) Display the count of all products shipped by each of the 3 shippers.

SELECT s.ShipperID, s.ShipperName, COUNT(od.ProductID) as TotalProducts
FROM Shippers s
JOIN Orders o ON s.ShipperID = o.ShipperID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY s.ShipperID, s.ShipperName;

-- 4) How many customers DO NOT have the words 'son' in their CustomerName.

SELECT COUNT(*) as CustomersWithoutSon
FROM Customers
WHERE CustomerName NOT LIKE '%son%';

-- 5) Find the total sales made in the year 1997.

SELECT SUM(p.Price * od.Quantity) as TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31';

-- 6) Find the top supplier of the business (in terms of products ordered).

SELECT s.SupplierID, s.SupplierName, COUNT(od.ProductID) as TotalProducts
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalProducts DESC
LIMIT 1;

-- 7) Find the total sales of each product.

SELECT p.ProductID, p.ProductName, SUM(p.Price * od.Quantity) as TotalSales
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName;

-- 8) Find the best-performing month in the business in terms of sales.

SELECT EXTRACT(MONTH FROM o.OrderDate) as Month, EXTRACT(YEAR FROM o.OrderDate) as Year, SUM(p.Price * od.Quantity) as TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY Month, Year
ORDER BY TotalSales DESC
LIMIT 1;

-- 9) Find the total sales per day.

SELECT o.OrderDate, SUM(p.Price * od.Quantity) as TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderDate;

-- 10) Find the total sales for each customer (leave as 0 the ones who have never ordered)

SELECT c.CustomerID, c.CustomerName, COALESCE(SUM(p.Price * od.Quantity), 0) as TotalSales
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName;