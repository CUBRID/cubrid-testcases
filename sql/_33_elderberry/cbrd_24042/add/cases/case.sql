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

-- Create a view using the CASE statement
CREATE VIEW v AS 
SELECT ID, 
       CASE 
         WHEN BirthYear < 1980 THEN 'Old'
         ELSE 'Young'
       END AS AgeGroup 
FROM tbl;

-- Check result (mergable)
SELECT * 
FROM v 
WHERE AgeGroup = 'Young';

--Convert the view to an inline view (mergable)
DROP VIEW IF EXISTS v;
SELECT *
FROM   (SELECT ID, 
               CASE 
                 WHEN BirthYear < 1980 THEN 'Old'
                 ELSE 'Young'
               END AS AgeGroup 
        FROM tbl) v
WHERE  AgeGroup = 'Young';

DROP TABLE IF EXISTS tbl;

