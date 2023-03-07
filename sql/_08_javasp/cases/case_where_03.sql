-- This is a test case for 'ANY', 'SOME', 'ALL'.

drop table if exists tbl;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE TABLE tbl (id int primary key, name char(10), dept_name VARCHAR, salary INT);
INSERT INTO tbl VALUES(1, 'Kim', 'devel', 4000000);
INSERT INTO tbl VALUES(2, 'Moy', 'sales', 3000000);
INSERT INTO tbl VALUES(3, 'Jones', 'sales', 5400000);
INSERT INTO tbl VALUES(4, 'Smith', 'devel', 5500000);
INSERT INTO tbl VALUES(5, 'Kim', 'account', 3800000);
INSERT INTO tbl VALUES(6, 'Smith', 'devel', 2400000);
INSERT INTO tbl VALUES(7, 'Brown', 'account', NULL);

--test ANY/SOME/ALL
SELECT * FROM tbl 
WHERE dept_name = ANY{fn_string('devel'),fn_string('sales')};

SELECT * FROM tbl 
WHERE dept_name = SOME( select fn_string(dept_name) from tbl where id in (1,2) );

SELECT * FROM tbl WHERE (
  (0.9 * salary) < ALL (SELECT fn_string( salary ) FROM tbl
  WHERE dept_name = 'devel')
);


drop function fn_string;
drop table tbl;
