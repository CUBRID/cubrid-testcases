--enum column in hierachical queries


CREATE TABLE tree(ID enum('1', '2', '3', '4', '5', '6', '7'), MgrID enum('1', '2', '6'), Name VARCHAR(32), BirthYear INT);
 
INSERT INTO tree VALUES (1,default,'Kim', 1963);
INSERT INTO tree VALUES (2,default,'Moy', 1958);
INSERT INTO tree VALUES (3,1,'Jonas', 1976);
INSERT INTO tree VALUES (4,1,'Smith', 1974);
INSERT INTO tree VALUES (5,2,'Verma', 1973);
INSERT INTO tree VALUES (6,2,'Foster', 1972);
INSERT INTO tree VALUES (7,3,'Brown', 1981);

--TEST: execute with connect by clause
SELECT id, mgrid, name
    FROM tree
    CONNECT BY PRIOR id=mgrid
    ORDER BY id;

--TEST: execute with start with clause
SELECT id, mgrid, name
    FROM tree
    START WITH mgrid IS NULL
    CONNECT BY prior id=mgrid
    ORDER BY id;


drop table tree;
