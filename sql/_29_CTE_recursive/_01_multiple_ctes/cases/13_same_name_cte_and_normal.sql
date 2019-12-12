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
WITH Employee (ID, Name, MgrID) AS 
(
    SELECT 1,      'Keith',      NULL   UNION ALL
    SELECT 2,      'Josh',       1      UNION ALL
    SELECT 3,      'Robin',      1      UNION ALL
    SELECT 4,      'Raja',       2      UNION ALL
    SELECT 5,      'Tridip',     NULL   UNION ALL
    SELECT 6,      'Arijit',     5      UNION ALL
    SELECT 7,      'Amit',       5      UNION ALL
    SELECT 8,      'Dev',        6   
)
,Hierarchy AS
(
    SELECT   ID
            ,Name
            ,MgrID
            ,1 as nLevel 
            ,ROW_NUMBER() OVER (ORDER BY Name) as Family 
    FROM Employee
    WHERE MgrID IS NULL

    UNION ALL
    SELECT   E.ID
            ,E.Name
            ,E.MgrID
            ,H.nLevel+1
            ,Family
    FROM Employee   E
    JOIN Hierarchy  H ON E.MgrID = H.ID
)
SELECT *
FROM Hierarchy
ORDER BY Family, nLevel;

drop table if exists Employee;
create table Employee(ID int,Name varchar(50),MgrID int);
insert into Employee values(1,'Keithyy',null);
insert into Employee values(2,'Joshyy',1);
with Hierarchy AS
(
    SELECT   ID
            ,Name
            ,MgrID
            ,1 as nLevel 
            ,ROW_NUMBER() OVER (ORDER BY Name) as Family 
    FROM Employee
    WHERE MgrID IS NULL

    UNION ALL
    SELECT   E.ID
            ,E.Name
            ,E.MgrID
            ,H.nLevel+1
            ,Family
    FROM Employee   E
    JOIN Hierarchy  H ON E.MgrID = H.ID
)
SELECT *
FROM Hierarchy
ORDER BY Family, nLevel;

drop table if exists Employee;
create table Employee(ID int,Name varchar(50),MgrID int);
insert into Employee values(1,'Keithyy',null);
insert into Employee values(2,'Joshyy',1);
WITH Employee (ID, Name, MgrID) AS 
(
    SELECT 1,      'Keith',      NULL   UNION ALL
    SELECT 2,      'Josh',       1      UNION ALL
    SELECT 3,      'Robin',      1      UNION ALL
    SELECT 4,      'Raja',       2      UNION ALL
    SELECT 5,      'Tridip',     NULL   UNION ALL
    SELECT 6,      'Arijit',     5      UNION ALL
    SELECT 7,      'Amit',       5      UNION ALL
    SELECT 8,      'Dev',        6   
)
,Hierarchy AS
(
    SELECT   ID
            ,Name
            ,MgrID
            ,1 as nLevel 
            ,ROW_NUMBER() OVER (ORDER BY Name) as Family 
    FROM Employee
    WHERE MgrID IS NULL

    UNION ALL
    SELECT   E.ID
            ,E.Name
            ,E.MgrID
            ,H.nLevel+1
            ,Family
    FROM Employee   E
    JOIN Hierarchy  H ON E.MgrID = H.ID
)
SELECT *
FROM Hierarchy
ORDER BY Family, nLevel;
drop table if exists Employee;


WITH recursive Employee (ID, Name, MgrID) AS 
(
    SELECT 1,      'Keith',      NULL   UNION ALL
    SELECT 2,      'Josh',       1      UNION ALL
    SELECT 3,      'Robin',      1      UNION ALL
    SELECT 4,      'Raja',       2      UNION ALL
    SELECT 5,      'Tridip',     NULL   UNION ALL
    SELECT 6,      'Arijit',     5      UNION ALL
    SELECT 7,      'Amit',       5      UNION ALL
    SELECT 8,      'Dev',        6   
)
,Hierarchy AS
(
    SELECT   ID
            ,Name
            ,MgrID
            ,1 as nLevel 
            ,ROW_NUMBER() OVER (ORDER BY Name) as Family 
    FROM Employee
    WHERE MgrID IS NULL

    UNION ALL
    SELECT   E.ID
            ,E.Name
            ,E.MgrID
            ,H.nLevel+1
            ,Family
    FROM Employee   E
    JOIN Hierarchy  H ON E.MgrID = H.ID
)
SELECT *
FROM Hierarchy
ORDER BY Family, nLevel;
