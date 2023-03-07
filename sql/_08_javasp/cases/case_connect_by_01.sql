-- This is a test case for 'CONNECT BY', 'LEVEL', 'CONNECT_BY_ISLEAF', 'CONNECT_BY_ISCYCLE'
-- 'CONNECT_BY_ROOT', 'PRIOR', 'SYS_CONNECT_BY_PATH'.

drop table if exists tbl1, tbl2;

CREATE OR REPLACE FUNCTION fn_string(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE TABLE tbl1(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
INSERT INTO tbl1 VALUES (1,NULL,'Kim', 1963);
INSERT INTO tbl1 VALUES (2,8,'Moy', 1958);
INSERT INTO tbl1 VALUES (3,1,'Jonas', 1976);
INSERT INTO tbl1 VALUES (4,1,'Smith', 1974);
INSERT INTO tbl1 VALUES (5,2,'Verma', 1973);
INSERT INTO tbl1 VALUES (6,2,'Foster', 1972);
INSERT INTO tbl1 VALUES (7,6,'Brown', 1981);
INSERT INTO tbl1 VALUES (8,7,'Brown', 1985);

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

-- test 'LEVEL' as parameter
SELECT id, mgrid, name, LEVEL
FROM tbl1
WHERE LEVEL=fn_string(2)
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;

-- test 'CONNECT_BY_ISLEAF' : NULL
SELECT id, mgrid, name, fn_string(CONNECT_BY_ISLEAF)
--SELECT id, mgrid, name, CONNECT_BY_ISLEAF
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;

-- test 'CONNECT_BY_ISCYCLE' : NULL
SELECT id, mgrid, name, fn_string(CONNECT_BY_ISCYCLE)
--SELECT id, mgrid, name, CONNECT_BY_ISCYCLE
FROM tbl1
START WITH name IN ('kim', 'Moy')
CONNECT BY NOCYCLE PRIOR id=mgrid
ORDER BY id;

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

-- error
SELECT id, mgrid, name, SYS_CONNECT_BY_PATH( fn_string(name , '/') )
FROM tbl1
START WITH mgrid IS NULL
CONNECT BY PRIOR id=mgrid
ORDER BY id;


drop function fn_string;
drop table tbl1;

