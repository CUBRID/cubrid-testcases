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
drop if exists A;
CREATE TABLE A ( ID int, Name varchar(12), ParentID int)
Insert into A (ID,Name,ParentID) values(1,'Greg',0)
Insert into A (ID,Name,ParentID) values(2,'Bill',0)
Insert into A (ID,Name,ParentID) values(3,'Amy',1)
Insert into A (ID,Name,ParentID) values(4,'Red',1)
Insert into A (ID,Name,ParentID) values(5,'Paul',4)
Insert into A (ID,Name,ParentID) values(6,'Forest',4)
Insert into A (ID,Name,ParentID) values(7,'Jade',3)
Insert into A (ID,Name,ParentID) values(8,'Mary',6)
Insert into A (ID,Name,ParentID) values(9,'Peter',6)
Insert into A (ID,Name,ParentID) values(10,'Joseph',6)
Insert into A (ID,Name,ParentID) values(11,'Juan',6)
Insert into A (ID,Name,ParentID) values(12,'Barbara',2)
Insert into A (ID,Name,ParentID) values(13,'Sue',2)
Insert into A (ID,Name,ParentID) values(14,'Steve',13)
Insert into A (ID,Name,ParentID) values(15,'Norma',14)
Insert into A (ID,Name,ParentID) values(16,'Monty',14)
Insert into A (ID,Name,ParentID) values(17,'Quame',14)
select * From A order by 1,2,3;
WITH recursive DirectReportsOfGreg (ManagerID, EmployeeID, EmployeeName, n)
AS
( 
SELECT ParentID,ID, Name, 0  n FROM A WHERE Name = 'Greg'
UNION ALL
SELECT ParentID,ID, a.Name,  n+1 FROM A 
INNER JOIN DirectReportsOfGreg as b on A.ParentID = b.EmployeeID
)
SELECT * FROM DirectReportsOfGreg 
ORDER BY n
select * From A;

WITH recursive DirectReportsOfGreg (ManagerID, EmployeeID, EmployeeName, n)
AS
(
SELECT ParentID,ID, Name, 0  n FROM A WHERE Name = 'Greg'
UNION ALL
SELECT ParentID,ID, a.Name,  n+1 FROM A
INNER JOIN DirectReportsOfGreg as b on A.ParentID = b.EmployeeID
)
SELECT * FROM DirectReportsOfGreg
ORDER BY n;

WITH recursive DirectReportsOfGreg (ManagerID, EmployeeID, EmployeeName, n)
AS
( 
SELECT ParentID,ID, Name, 0  n FROM A WHERE Name = 'Greg'
UNION ALL
SELECT ParentID,ID, a.Name,  n+1 FROM A 
INNER JOIN DirectReportsOfGreg as b on A.ParentID = b.EmployeeID
),
DirectReportsOfGreg2 (ManagerID, EmployeeID, EmployeeName, n)
AS
( 
SELECT ParentID,ID, Name, 0  n FROM A WHERE Name = 'Greg'
UNION ALL
SELECT ParentID,ID, a.Name,  n+2 FROM A 
INNER JOIN DirectReportsOfGreg2 as b on A.ParentID = b.EmployeeID
)
SELECT * FROM DirectReportsOfGreg,DirectReportsOfGreg2 ORDER BY 1 limit 10;

drop if exists A;
