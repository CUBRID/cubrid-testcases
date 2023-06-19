-- Test For-Loop with Dynamic SQL

--+ server-output on
DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl (id int primary key, name char(10), dept_name VARCHAR, salary INT);
INSERT INTO tbl VALUES(1, 'Kim', 'devel', 4000000);
INSERT INTO tbl VALUES(2, 'Moy', 'sales', 3000000);
INSERT INTO tbl VALUES(3, 'Jones', 'sales', 5400000);
INSERT INTO tbl VALUES(4, 'Smith', 'devel', 5500000);
INSERT INTO tbl VALUES(5, 'Kim', 'account', 3800000);
INSERT INTO tbl VALUES(6, 'Smith', 'devel', 2400000);
INSERT INTO tbl VALUES(7, 'Brown', 'account', NULL);

CREATE OR REPLACE PROCEDURE get_salary_by_dept (dept_name VARCHAR)
AS
BEGIN
    -- For-Dynamic-SQL Loop
    FOR r IN (EXECUTE IMMEDIATE 'SELECT name, salary FROM tbl WHERE dept_name = ?' USING dept_name) LOOP
        put_line('name: ' ||  r.name || ' salary: ' || r.salary);
    END LOOP;
END;

CALL get_salary_by_dept ('devel');
CALL get_salary_by_dept ('account');

DROP TABLE tbl;
DROP PROCEDURE get_salary_by_dept;