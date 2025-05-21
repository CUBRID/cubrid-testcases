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

-- Create the first view
CREATE OR REPLACE VIEW v_a AS 
SELECT ID, Name 
FROM tbl 
WHERE BirthYear > 1970;

-- Create the second view, referencing the first view
CREATE OR REPLACE VIEW v_b AS 
SELECT v_a.ID, v_a.Name, t.MgrID 
FROM v_a 
JOIN tbl t ON v_a.ID = t.ID;

-- Check result (mergable)
SELECT v_b.ID, v_b.Name, v_b.MgrID 
FROM v_b
WHERE MgrID > 1;

DROP VIEW IF EXISTS v_a;
DROP VIEW IF EXISTS v_b;
DROP TABLE IF EXISTS tbl;

