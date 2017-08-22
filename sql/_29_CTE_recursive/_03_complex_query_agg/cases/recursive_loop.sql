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
drop if exists Employee;
create table Employee(EmployeeID int,ManagerID int,Title char(50));
insert into Employee values(1,null,'lead');
insert into Employee values(2,1,'employee');

WITH recursive cte (EmployeeID, ManagerID, Title) as
(
    SELECT EmployeeID, ManagerID, Title
    FROM Employee
    WHERE ManagerID IS NULL
  UNION ALL
    SELECT cte.EmployeeID, cte.ManagerID, cte.Title
    FROM cte inner
    JOIN  Employee AS e 
        ON cte.ManagerID = e.EmployeeID
)
SELECT EmployeeID, ManagerID, Title
FROM cte;

WITH recursive cte (EmployeeID, ManagerID, Title,l) as
(
    SELECT EmployeeID, ManagerID, Title,1
    FROM Employee
    WHERE ManagerID IS not NULL
  UNION ALL
    SELECT cte.EmployeeID, cte.ManagerID, cte.Title,cte.l+1
    FROM cte inner
    JOIN  Employee AS e 
        ON cte.ManagerID = e.EmployeeID and cte.l<2
)
SELECT EmployeeID, ManagerID, Title
FROM cte;

WITH recursive cte (EmployeeID, ManagerID, Title) as
(
    SELECT EmployeeID, ManagerID, Title
    FROM Employee
    WHERE ManagerID IS not NULL
  UNION ALL
    SELECT e.EmployeeID, e.ManagerID, e.Title
    FROM cte inner
    JOIN  Employee AS e 
        ON cte.ManagerID = e.EmployeeID
)
SELECT EmployeeID, ManagerID, Title
FROM cte;

WITH cte (EmployeeID, ManagerID, Title,l) as
(
    SELECT EmployeeID, ManagerID, Title,1
    FROM Employee
    WHERE ManagerID IS NOT NULL
  UNION ALL
    SELECT cte.EmployeeID, cte.ManagerID, cte.Title,cte.l+1
    FROM cte inner
    JOIN  Employee AS e 
        ON cte.ManagerID = e.EmployeeID and cte.l<10
)
SELECT EmployeeID, ManagerID, Title
FROM cte;
drop if exists Employee;
