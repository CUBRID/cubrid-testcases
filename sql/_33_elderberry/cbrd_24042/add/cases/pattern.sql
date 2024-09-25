DROP TABLE IF EXISTS tbl;
CREATE TABLE tbl(ID INT, MgrID INT, Name VARCHAR(32), BirthYear INT);
INSERT INTO tbl VALUES (1,NULL,'Kim', 1963);
INSERT INTO tbl VALUES (2,NULL,'Moy', 1958);
INSERT INTO tbl VALUES (3,1,'Jonas', 1976);
INSERT INTO tbl VALUES (4,1,'Smith', 1974);
INSERT INTO tbl VALUES (5,3,'Verma', 1973);
INSERT INTO tbl VALUES (6,3,'Foster', 1972);
INSERT INTO tbl VALUES (7,2,'Brown', 1981);
INSERT INTO tbl VALUES (8,7,'Lin', 1983);

-- Create a view with pattern matching
CREATE VIEW v AS 
SELECT ID, Name, MgrID 
FROM tbl
WHERE Name LIKE 'B%';

-- Check result (mergable)
SELECT * 
FROM v 
WHERE MgrID IS NOT NULL;

--Convert the view to an inline view (mergable)
DROP VIEW IF EXISTS v;
SELECT *
FROM   (SELECT ID, Name, MgrID 
        FROM tbl
        WHERE Name LIKE 'B%') v
WHERE  MgrID IS NOT NULL;

DROP TABLE IF EXISTS tbl;

