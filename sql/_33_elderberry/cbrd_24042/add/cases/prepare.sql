DROP TABLE IF EXISTS tbl;
DROP TABLE IF EXISTS tbl_emp;

CREATE TABLE tbl(
    ID INT,
    MgrID INT,
    Name VARCHAR(32),
    BirthYear INT
);

CREATE TABLE tbl_emp(
    EmpID INT,
    Salary INT,
    JobTitle STRING
);

INSERT INTO tbl VALUES (1, NULL, 'Kim', 1963);
INSERT INTO tbl VALUES (2, NULL, 'Moy', 1958);
INSERT INTO tbl VALUES (3, 1, 'Jonas', 1976);
INSERT INTO tbl VALUES (4, 1, 'Smith', 1974);
INSERT INTO tbl VALUES (5, 3, 'Verma', 1973);
INSERT INTO tbl VALUES (6, 3, 'Foster', 1972);
INSERT INTO tbl VALUES (7, 2, 'Brown', 1981);
INSERT INTO tbl VALUES (8, 7, 'Lin', 1983);

INSERT INTO tbl_emp VALUES (1, 1000, 'Manager');
INSERT INTO tbl_emp VALUES (2, 2000, 'Developer');
INSERT INTO tbl_emp VALUES (3, 3000, 'HR');
INSERT INTO tbl_emp VALUES (4, 4000, 'Analyst');

-- Inline view with a bind variable in the WHERE clause
PREPARE q FROM '
    SELECT /*+ recompile */ *
    FROM (
        SELECT t.Name, e.Salary, e.JobTitle
        FROM tbl t
        JOIN tbl_emp e ON t.ID = e.EmpID
        WHERE e.Salary > ? AND e.Salary < ?
    ) v
    WHERE v.JobTitle = ''Developer''
';

-- Check result (mergable)
--@queryplan
EXECUTE q USING 1500, 3000;
DEALLOCATE PREPARE q;

DROP TABLE IF EXISTS tbl;
DROP TABLE IF EXISTS tbl_emp;
