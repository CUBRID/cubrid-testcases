SELECT LEVEL FROM db_root CONNECT BY NOCYCLE LEVEL <= 5; 

select rownum from "db_root" connect by nocycle level <= 10;

select level from db_root connect by nocycle level <= 10;

drop table if exists tree;
CREATE TABLE tree(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
 
INSERT INTO tree VALUES (1,NULL,'Kim', 1963);
INSERT INTO tree VALUES (2,NULL,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,6,'Brown', 1981);

SELECT id, mgrid, name
    FROM tree
    CONNECT BY PRIOR id=mgrid
    ORDER BY id;

SELECT id, mgrid, name
    FROM tree
    START WITH mgrid IS NULL
    CONNECT BY prior id=mgrid
    ORDER BY id;

SELECT id, mgrid, name,CONNECT_BY_ISCYCLE
    FROM tree
    CONNECT BY nocycle id=mgrid
    ORDER BY id;

SELECT id, mgrid, name,CONNECT_BY_ISCYCLE
    FROM tree
    START WITH mgrid IS NULL
    CONNECT BY nocycle id=mgrid
    ORDER BY id;

drop table if exists tree;
