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
update total,p set p.UnitPrice=35 where p.CategoryID=total.CategoryID and p.ProductID in (select ProductID from overten)

select * from p order by 1;

drop if exists p,c;
