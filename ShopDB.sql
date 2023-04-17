DROP database if exists ShopDB;

CREATE DATABASE ShopDB;

USE ShopDB;

CREATE TABLE Employees
(
    EmployeeID int NOT NULL,
    FName      nvarchar(15) NOT NULL,
    LName      nvarchar(15) NOT NULL,
    MName      nvarchar(15) NOT NULL,
    Salary     double(10, 2
                   ) NOT NULL,
    PriorSalary     double(10, 2) NOT NULL,
    HireDate        date          NOT NULL,
    TerminationDate date          NULL,
    ManagerEmpID    int           NULL
);


ALTER TABLE Employees
    ADD
        CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID);


ALTER TABLE Employees
    ADD CONSTRAINT
        FK_Employees_Employees FOREIGN KEY (ManagerEmpID)
            REFERENCES Employees (EmployeeID);


CREATE TABLE Customers
(
    CustomerNo   int       NOT NULL auto_increment,
    FName        nvarchar(15) NOT NULL,
    LName        nvarchar(15) NOT NULL,
    MName        nvarchar(15) NULL,
    Address1     nvarchar(50) NOT NULL,
    Address2     nvarchar(50) NULL,
    City         nchar(10) NOT NULL,
    Phone        char(12)  NOT NULL,
    DateInSystem date NULL,
    primary key (CustomerNo)
);

CREATE TABLE Orders
(
    OrderID    int  NOT NULL auto_increment,
    CustomerNo int NULL,
    OrderDate  date NOT NULL,
    EmployeeID int NULL,
    primary key (OrderID)
);



-- ALTER TABLE Orders
--  ADD CONSTRAINT
--     FK_Orders_Customers FOREIGN KEY (CustomerNo)
--       REFERENCES Customers (CustomerNo)
--     ON UPDATE CASCADE
--   ON DELETE SET NULL;

ALTER TABLE Orders
    ADD CONSTRAINT
        FK_Orders_Employees FOREIGN KEY (EmployeeID)
            REFERENCES Employees (EmployeeID)
            ON UPDATE CASCADE
            ON DELETE SET NULL;

CREATE TABLE Products
(
    ProdID      int       NOT NULL auto_increment,
    Description nchar(50) NOT NULL,
    UnitPrice   double(10, 2
                    ) NULL,
    Weight      numeric(18, 0) NULL,
    primary key (ProdID)
);

CREATE TABLE OrderDetails
(
    OrderID   int NOT NULL,
    LineItem  int NOT NULL,
    ProdID    int NULL,
    Qty       int NOT NULL,
    UnitPrice double(10, 2
                  ) NOT NULL,
    TotalPrice int
);

ALTER TABLE OrderDetails
    ADD CONSTRAINT
        PK_OrderDetails PRIMARY KEY
            (OrderID, LineItem);


ALTER TABLE OrderDetails
    ADD CONSTRAINT
        FK_OrderDetails_Products FOREIGN KEY (ProdID)
            REFERENCES Products (ProdID)
            ON UPDATE NO ACTION
            ON DELETE SET NULL;

ALTER TABLE OrderDetails
    ADD CONSTRAINT
        FK_OrderDetails_Orders FOREIGN KEY (OrderID)
            REFERENCES Orders (OrderID)
            ON UPDATE CASCADE
            ON DELETE CASCADE;

INSERT
    Employees
(EmployeeID, FName, MName, LName, Salary, PriorSalary, HireDate, TerminationDate, ManagerEmpID)
VALUES (1, 'Хтось', 'Хтось', 'Хтосьович', 2000, 0, '2009-11-20', NULL,
        NULL), -- додала одну людину, бо база не працювала.
       (2, 'Иван', 'Иванович', 'Белецкий', 2000, 0, '2009-11-20', NULL, 1),
       (3, 'Петр', 'Григорьевич', 'Дяченко', 1000, 0, '2009-11-20', NULL, 2),
       (4, 'Светлана', 'Олеговна', 'Лялечкина', 800, 0, '2009-11-20', NULL, 2);


INSERT
    Customers
(LName, FName, MName, Address1, Address2, City, Phone, DateInSystem)
VALUES ('Круковский', 'Анатолий', 'Петрович', 'Лужная 15', NULL, 'Харьков', '(092)3212211', '2009-11-20'),
       ('Дурнев', 'Виктор', 'Викторович', 'Зелинская 10', NULL, 'Киев', '(067)4242132', '2009-11-20'),
       ('Унакий', 'Зигмунд', 'федорович', 'Дихтяревская 5', NULL, 'Киев', '(092)7612343', '2009-11-20'),
       ('Левченко', 'Виталий', 'Викторович', 'Глущенка 5', 'Драйзера 12', 'Киев', '(053)3456788', '2009-11-20'),
       ('Выжлецов', 'Олег', 'Евстафьевич', 'Киевская 3', 'Одесская 8', 'Чернигов', '(044)2134212', '2009-11-20');


INSERT
    Products
(Description, UnitPrice, Weight)
VALUES ('LV231 Джинсы', 45, 0.9),
       ('GC111 Футболка', 20, 0.3),
       ('GC203 Джинсы', 48, 0.7),
       ('DG30 Ремень', 30, 0.5),
       ('LV12 Обувь', 26, 1),
       ('GC11 Шапка', 32, 0.35);


INSERT
    Orders
( OrderDate, EmployeeID) -- CustomerNo
VALUES ('2009-11-20', 2), -- 1
       ( '2009-11-20', 4), -- 2
       ( '2009-11-20', 4) ; -- 3

INSERT
    OrderDetails
(OrderID, LineItem, ProdID, Qty, UnitPrice, TotalPrice)
VALUES (1, 1, 1, 5, 45, 45 * 5),
       (1, 2, 4, 5, 29, 29 * 5),
       (1, 3, 5, 5, 25, 25 * 5),
       (2, 1, 6, 10, 32, 32 * 10),
       (2, 2, 2, 15, 20, 20 * 5),
       (3, 1, 5, 20, 26, 26 * 20),
       (3, 2, 6, 18, 32, 32 * 18);

SELECT * FROM Employees;
SELECT * FROM OrderDetails;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Customers;
-- Используя базу данных ShopDB и страницу Customers (удалите таблицу,
-- если есть и создайте заново первый раз без первичного ключа затем – с первичным) и затем добавьте индексы и проанализируйте выборку данных

-- удаляем таблицу  Customers если есть;
DROP TABLE  IF EXISTS Customers;
-- создаем заново таблицу Customers без первичного ключа
CREATE TABLE IF NOT EXISTS Customers
(
    CustomerNo int NOT NULL,
    FName nvarchar(15) NOT NULL,
    LName nvarchar(15) NOT NULL,
    MName nvarchar(15) NULL,
    Address1 nvarchar(50) NOT NULL,
    Address2 nvarchar(50) NULL,
    City nchar(10) NOT NULL,
    Phone char(12) NOT NULL,
    DateInSystem date NULL
);

INSERT Customers
(CustomerNo, LName, FName, MName, Address1, Address2, City, Phone,DateInSystem)
VALUES
    (1,'Круковский','Анатолий','Петрович','Лужная 15',NULL,'Харьков','(092)3212211','2009-11-20'),
    (2,'Дурнев','Виктор','Викторович','Зелинская 10',NULL,'Киев','(067)4242132','2009-11-20'),
    (3,'Унакий','Зигмунд','федорович','Дихтяревская 5',NULL,'Киев','(092)7612343','2009-11-20'),
    (4,'Левченко','Виталий','Викторович','Глущенка 5','Драйзера 12','Киев','(053)3456788','2009-11-20'),
    (5,'Выжлецов','Олег','Евстафьевич','Киевская 3','Одесская 8','Чернигов','(044)2134212','2009-11-20');

SELECT * FROM Customers;

--  аналіз запиту данних
-- виконання запиту низьке за певними параметрами ( 20%  по таблиці CustomersБ то немає PRIMARY )
EXPLAIN SELECT Customers.LName AS Customer_LName,
               Customers.FName AS Customer_FName,
               Employees.LName AS Employee_LName,
               Employees.FName AS Employee_FName,
               SUM(TotalPrice) AS Order_Sum
        FROM Orders
                 INNER JOIN Customers
                            ON Orders.CustomerNo = Customers.CustomerNo
                 INNER JOIN Employees
                            ON Orders.EmployeeID = Employees.EmployeeID
                 INNER JOIN OrderDetails
                            ON Orders.OrderID = OrderDetails.OrderID
        GROUP BY Customer_LName, Customer_FName, Employee_LName, Employee_FName
        HAVING SUM(TotalPrice) > 1000; -- виконання запиту 100,100,100,20 %
-- додаєм індекс в колонку CustomerNo
CREATE INDEX  indexCustomerNo ON Customers(CustomerNo);

-- після додавання індексу вибірка данних покращилась (100 % - за всіма параметрами)
EXPLAIN SELECT Customers.LName AS Customer_LName,
               Customers.FName AS Customer_FName,
               Employees.LName AS Employee_LName,
               Employees.FName AS Employee_FName,
               SUM(TotalPrice) AS Order_Sum
        FROM Orders
                 INNER JOIN Customers
                            ON Orders.CustomerNo = Customers.CustomerNo
                 INNER JOIN Employees
                            ON Orders.EmployeeID = Employees.EmployeeID
                 INNER JOIN OrderDetails
                            ON Orders.OrderID = OrderDetails.OrderID
        GROUP BY Customer_LName, Customer_FName, Employee_LName, Employee_FName
        HAVING SUM(TotalPrice) > 1000;

DROP INDEX indexCustomerNo  ON Customers;


