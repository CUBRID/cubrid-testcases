-- This testcase use modified SQL Server samples. See below for the license:
-- Copyright (c) Microsoft Corporation
-- Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in
--  all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
--  THE SOFTWARE.
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

SELECT c.CategoryName, c.NumberOfProducts,
      p.ProductName, p.UnitPrice
FROM ProductsOverTenDollars p
   INNER JOIN CategoryAndNumberOfProducts c ON
      p.CategoryID = c.CategoryID
ORDER BY ProductName;
drop if exists products,Categories;
