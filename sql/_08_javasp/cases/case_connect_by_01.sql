-- This is a test case for 'CONNECT BY', 'LEVEL', 'CONNECT_BY_ISLEAF', 'CONNECT_BY_ISCYCLE'
-- 'CONNECT_BY_ROOT', 'PRIOR', 'SYS_CONNECT_BY_PATH'.

drop table if exists tbl1;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE TABLE tbl1(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
INSERT INTO tbl1 VALUES (1,NULL,'Kim', 1963);
INSERT INTO tbl1 VALUES (2,NULL,'Moy', 1958);
INSERT INTO tbl1 VALUES (3,1,'Jonas', 1976);
INSERT INTO tbl1 VALUES (4,1,'Smith', 1974);
INSERT INTO tbl1 VALUES (5,3,'Verma', 1973);
INSERT INTO tbl1 VALUES (6,3,'Foster', 1972);
INSERT INTO tbl1 VALUES (7,2,'Brown', 1981);
INSERT INTO tbl1 VALUES (8,7,'Lin', 1983);

-- CBRD-24720 : result different with using javasp
-- test connect by
SELECT id, mgrid, name
FROM tbl1
CONNECT BY PRIOR id=fn_string(mgrid)
ORDER BY id;

-- test 'start with' clause
SELECT id, mgrid, name
FROM tbl1
START WITH fn_string(mgrid) IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;

-- CBRD-24720 : result different with using javasp
-- test 'LEVEL' as parameter
SELECT id, mgrid, name, LEVEL
FROM tbl1
WHERE fn_string(LEVEL)=2
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;

-- CBRD-24720 : result different with using javasp
-- test 'CONNECT_BY_ISLEAF'
SELECT id, mgrid, name, fn_string(CONNECT_BY_ISLEAF)
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;

-- CBRD-24720 : result different with using javasp
-- test 'CONNECT_BY_ISCYCLE'
UPDATE tbl1 SET mgrid=8 WHERE id=2;
SELECT id, mgrid, name, fn_string(CONNECT_BY_ISCYCLE)
FROM tbl1
START WITH name IN ('kim', 'Moy')
CONNECT BY NOCYCLE PRIOR id=mgrid
ORDER BY id;
UPDATE tbl1 SET mgrid=NULL WHERE id=2;

-- test 'CONNECT_BY_ROOT'
SELECT id, mgrid, name, fn_string(CONNECT_BY_ROOT id)
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY prior id=mgrid
ORDER BY id;

-- test 'PRIOR'
SELECT id, mgrid, name, fn_string(PRIOR id)
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;

-- test 'SYS_CONNECT_BY_PATH'
SELECT id, mgrid, name, fn_string(SYS_CONNECT_BY_PATH(name,'/'))
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;

-- CBRD-24720 : result different with using javasp
SELECT id, mgrid, name, SYS_CONNECT_BY_PATH( fn_string(name) ,'/' )
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;


drop function fn_string;
drop table tbl1;

