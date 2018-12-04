drop if exists products,Categories;
create table products(ProductID int primary key,CategoryID int,ProductName varchar,UnitPrice double);
insert into products values(1,1,'pencil',5);
insert into products values(2,1,'brush',25);
create table Categories(CategoryID int primary key,CategoryName varchar);
insert into Categories values (1,'pen');
insert into Categories values (2,'paper');
insert into Categories values (3,'food');

WITH recursive CategoryAndNumberOfProducts (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM Products p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM Categories c
),

ProductsOverTenDollars (ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM Products p
   WHERE UnitPrice > 10.0
)
delete Categories 
FROM ProductsOverTenDollars p
   INNER JOIN CategoryAndNumberOfProducts c  inner join Categories ON
      p.CategoryID = c.CategoryID and Categories.CategoryID=c.CategoryID;
select * from Categories order by 1;
drop if exists products,Categories;
