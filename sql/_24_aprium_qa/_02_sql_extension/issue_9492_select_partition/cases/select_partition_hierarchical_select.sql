--test with hierarchical select


CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT)
partition by hash(id) partitions 3;

INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);


--TEST: hierarchical select from partition
SELECT id, mgrid, name  FROM tree partition (p0) CONNECT BY PRIOR id=mgrid  ORDER BY 1, 2, 3;
SELECT id, mgrid, name  FROM tree partition (p1) CONNECT BY PRIOR id=mgrid  ORDER BY 1, 2, 3;
SELECT id, mgrid, name  FROM tree partition (p2) CONNECT BY PRIOR id=mgrid  ORDER BY 1, 2, 3;

--TEST: hierarchical select with 'start with' from partition
SELECT id, mgrid, name  FROM tree partition (p0) START WITH mgrid IS NULL CONNECT BY prior id=mgrid  ORDER BY 1, 2, 3;
SELECT id, mgrid, name  FROM tree partition (p1) START WITH mgrid IS NULL CONNECT BY prior id=mgrid  ORDER BY 1, 2, 3;
SELECT id, mgrid, name  FROM tree partition (p2) START WITH mgrid IS NULL CONNECT BY prior id=mgrid  ORDER BY 1, 2, 3;


drop table tree;
