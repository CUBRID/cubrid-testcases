-- refer to sql/_13_issues/_11_2h/cases/bug_bts_5861_2.sql

DROP TABLE IF EXISTS tbl;
DROP TABLE IF EXISTS tbl_emp;
CREATE TABLE tbl(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
INSERT INTO tbl VALUES (1,NULL,'Kim', 1963);
INSERT INTO tbl VALUES (2,NULL,'Moy', 1958);
INSERT INTO tbl VALUES (3,1,'Jonas', 1976);
INSERT INTO tbl VALUES (4,1,'Smith', 1974);
INSERT INTO tbl VALUES (5,3,'Verma', 1973);
INSERT INTO tbl VALUES (6,3,'Foster', 1972);
INSERT INTO tbl VALUES (7,2,'Brown', 1981);
INSERT INTO tbl VALUES (8,7,'Lin', 1983);

CREATE TABLE tbl_emp (EmpID INT, Salary INT, JobTitle STRING);
INSERT INTO tbl_emp VALUES (1, 1000, 'Manager1');
INSERT INTO tbl_emp VALUES (2, 2000, 'Developer1');
INSERT INTO tbl_emp VALUES (3, 3000, 'HR1');
INSERT INTO tbl_emp VALUES (4, 3001, 'Developer2');

-- Create indexes
CREATE INDEX idx_tbl_id ON tbl(ID);
CREATE INDEX idx_tbl_birthyear ON tbl(BirthYear);
CREATE INDEX idx_empinfo_empid ON tbl_emp(EmpID);
CREATE INDEX idx_empinfo_salary ON tbl_emp(Salary);
CREATE INDEX idx_empinfo_jobtitle ON tbl_emp(RIGHT(JobTitle, 2));

-- Check view merging when using index in the main query (mergable)
SELECT /*+ recompile */ * 
FROM 
    tbl t INNER JOIN 
    (SELECT * FROM tbl_emp WHERE RIGHT(JobTitle, 2) < 'zz' USING INDEX idx_empinfo_empid(+)) x 
    ON t.ID = x.EmpID 
WHERE 
    t.BirthYear < 1980 
USING INDEX 
    idx_tbl_birthyear(+);

-- Check view merging when using force index(The selection of the specified index is prioritized) in the subquery (mergable)
SELECT /*+ recompile */ * 
FROM 
    tbl FORCE INDEX (idx_tbl_birthyear) INNER JOIN 
    (SELECT * FROM tbl_emp FORCE INDEX (idx_empinfo_empid) WHERE RIGHT(JobTitle, 2) < 'zz') x 
    ON tbl.ID = x.EmpID 
WHERE 
    tbl.BirthYear < 1980;

DROP TABLE IF EXISTS tbl;
DROP TABLE IF EXISTS tbl_emp;
