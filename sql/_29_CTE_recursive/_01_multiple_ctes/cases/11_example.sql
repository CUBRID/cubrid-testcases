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
drop table if exists MyEmployees,EmployeeDepartmentHistory,Department;
CREATE TABLE MyEmployees
(
	EmployeeID int NOT NULL,
	FirstName varchar(30)  NOT NULL,
	LastName  varchar(40) NOT NULL,
	Title varchar(50) NOT NULL,
	DeptID int NOT NULL,
	ManagerID int NULL
);
INSERT INTO MyEmployees VALUES (1, 'Ken', 'Sánchez', 'Chief Executive Officer',16,NULL);
INSERT INTO MyEmployees VALUES (273, 'Brian', 'Welcker', 'Vice President of Sales',3,1);
INSERT INTO MyEmployees VALUES (274, 'Stephen', 'Jiang', 'North American Sales Manager',3,273);
INSERT INTO MyEmployees VALUES (275, 'Michael', 'Blythe', 'Sales Representative',3,274);
INSERT INTO MyEmployees VALUES (276, 'Linda', 'Mitchell', 'Sales Representative',3,274);
INSERT INTO MyEmployees VALUES (285, 'Syed', 'Abbas', 'Pacific Sales Manager',3,273);
INSERT INTO MyEmployees VALUES (286, 'Lynn', 'Tsoflias', 'Sales Representative',3,285);
INSERT INTO MyEmployees VALUES (16,  'David','Bradley', 'Marketing Manager', 4, 273);
INSERT INTO MyEmployees VALUES (23,  'Mary', 'Gibson', 'Marketing Specialist', 4, 16);

create table EmployeeDepartmentHistory(DepartmentID int ,BusinessEntityID int,EndDate date);
insert into EmployeeDepartmentHistory values(16,1,null);
insert into EmployeeDepartmentHistory values(3,273,null);
create table Department(DepartmentID int,GroupName varchar(50));
insert into Department values(16,'Sales and Marketing');
insert into Department values(3,'Sales and Marketing');
insert into Department values(4,'Sales and Marketing');
WITH recursive DirectReports (ManagerID, EmployeeID, Title, DeptID)
AS
(
    SELECT  e.ManagerID, e.EmployeeID, e.Title,edh.DepartmentID
    FROM MyEmployees e INNER JOIN EmployeeDepartmentHistory  edh 
	ON e.EmployeeID = edh.BusinessEntityID 
	AND  edh.EndDate IS NULL
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, edh.DepartmentID
    FROM MyEmployees e
    INNER JOIN EmployeeDepartmentHistory edh
        ON e.EmployeeID = edh.BusinessEntityID AND edh.EndDate IS NULL
    INNER JOIN DirectReports  d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID, EmployeeID, Title, DeptID
FROM DirectReports
INNER JOIN Department dp
    ON DirectReports.DeptID = dp.DepartmentID
WHERE dp.GroupName = 'Sales and Marketing';

WITH recursive DirectReports (ManagerID, EmployeeID, Title, DeptID,lv)
AS
(
    SELECT  e.ManagerID, e.EmployeeID, e.Title,edh.DepartmentID,0 as lv
    FROM MyEmployees e INNER JOIN EmployeeDepartmentHistory  edh 
	ON e.EmployeeID = edh.BusinessEntityID 
	AND  edh.EndDate IS NULL
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, edh.DepartmentID,lv+1
    FROM MyEmployees e
    INNER JOIN EmployeeDepartmentHistory edh
        ON e.EmployeeID = edh.BusinessEntityID AND edh.EndDate IS NULL
    INNER JOIN DirectReports  d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID, EmployeeID, Title, DeptID
FROM DirectReports
INNER JOIN Department dp
    ON DirectReports.DeptID = dp.DepartmentID
WHERE dp.GroupName = 'Sales and Marketing' or lv=0;

WITH recursive DirectReports (ManagerID, EmployeeID, Title, DeptID,lv)
AS
(
    SELECT  e.ManagerID, e.EmployeeID, e.Title,edh.DepartmentID,0 as lv
    FROM MyEmployees e INNER JOIN EmployeeDepartmentHistory  edh 
	ON e.EmployeeID = edh.BusinessEntityID 
	AND  edh.EndDate IS NULL
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, edh.DepartmentID,lv+1
    FROM MyEmployees e
    INNER JOIN EmployeeDepartmentHistory edh
        ON e.EmployeeID = edh.BusinessEntityID AND edh.EndDate IS NULL
    INNER JOIN DirectReports  d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID, EmployeeID, Title, DeptID
FROM DirectReports
INNER JOIN Department dp
    ON DirectReports.DeptID = dp.DepartmentID
WHERE dp.GroupName = 'Sales and Marketing' or lv=1;

WITH recursive DirectReports (ManagerID, EmployeeID, Title, DeptID,lv)
AS
(
    SELECT  e.ManagerID, e.EmployeeID, e.Title,edh.DepartmentID,0 as lv
    FROM MyEmployees e INNER JOIN EmployeeDepartmentHistory  edh 
	ON e.EmployeeID = edh.BusinessEntityID 
	AND  edh.EndDate IS NULL
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT e.ManagerID, e.EmployeeID, e.Title, edh.DepartmentID,lv+1
    FROM MyEmployees e
    INNER JOIN EmployeeDepartmentHistory edh
        ON e.EmployeeID = edh.BusinessEntityID AND edh.EndDate IS NULL
    INNER JOIN DirectReports  d
        ON e.ManagerID = d.EmployeeID
)
SELECT ManagerID, EmployeeID, Title, DeptID
FROM DirectReports
INNER JOIN Department dp
    ON DirectReports.DeptID = dp.DepartmentID
WHERE dp.GroupName = 'Sales and Marketing' and lv=1;


drop table if exists MyEmployees,EmployeeDepartmentHistory,Department;
