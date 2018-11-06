drop if exists p,c;
create table p(ProductID int primary key,CategoryID int,ProductName varchar,UnitPrice double);
insert into p values(1,1,'pencil',5);
insert into p values(2,1,'brush',25);
create table c(CategoryID int primary key,CategoryName varchar);
insert into c values (1,'pen');
insert into c values (2,'paper');
insert into c values (3,'food');

WITH RECURSIVE total (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM c
),
overten( ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM p
   WHERE UnitPrice > 10.0
)
select * from total,p where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten)



WITH RECURSIVE total (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM c
),
overten( ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM p
   WHERE UnitPrice > 10.0
)
delete p from total,p where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten)

select * from p order by 1;

drop table if exists xoo;
create table xoo as
WITH RECURSIVE total (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM c
),
overten( ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM p
   WHERE UnitPrice <= 10.0
)
select total.CategoryID as CategoryID,total.CategoryName as CategoryName,total.NumberOfProducts as NumberOfProducts,p.productid,p.productname ,p.unitprice from total,p 
where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten);


insert into xoo 
WITH RECURSIVE total (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM c
),
overten( ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM p
   WHERE UnitPrice <= 10.0
)
select total.CategoryID as a,total.CategoryName as b,total.NumberOfProducts as c,p.productid,p.productname ,p.unitprice from total,p
where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten);

describe xoo;

delete from xoo limit 1;
alter table xoo change column  CategoryID  CategoryID int unique;
insert into xoo
WITH RECURSIVE total (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM c
),
overten( ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM p
   WHERE UnitPrice <= 10.0
)
select total.CategoryID as a,total.CategoryName as b,total.NumberOfProducts as c,p.productid,p.productname ,p.unitprice from total,p
where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten);

select * from xoo order by 1;


replace into xoo
WITH RECURSIVE total (CategoryID, CategoryName, NumberOfProducts) AS
(
   SELECT
      CategoryID,
      CategoryName,
      (SELECT COUNT(1) FROM p
       WHERE p.CategoryID = c.CategoryID) as NumberOfProducts
   FROM c
),
overten( ProductID, CategoryID, ProductName, UnitPrice) AS
(
   SELECT
      ProductID,
      CategoryID,
      ProductName,
      UnitPrice
   FROM p
   WHERE UnitPrice <= 10.0
)
select total.CategoryID as a,total.CategoryName as b,total.NumberOfProducts as c,p.productid,p.productname ,p.unitprice from total,p
where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten);
select * from xoo order by 1;

drop if exists p,c,xoo;
