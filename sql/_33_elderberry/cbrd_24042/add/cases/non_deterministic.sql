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

-- Create a view using RANDOM() function
CREATE OR REPLACE VIEW v_random AS
SELECT ID, Name, RANDOM() AS RandomValue
FROM tbl
WHERE BirthYear > 1970;

-- Check result (unmergable)
SELECT /*+ recompile */ *
FROM v_random
WHERE RandomValue < 0.5;

--Convert the view to an inline view (unmergable)
DROP VIEW IF EXISTS v_random;
SELECT /*+ recompile */ *
FROM (
    SELECT ID, Name, RANDOM() AS RandomValue
    FROM tbl
    WHERE BirthYear > 1970
) v
WHERE RandomValue < 0.5;

-- Create a view using DRANDOM() function
CREATE OR REPLACE VIEW v_drandom AS
SELECT ID, Name, DRANDOM() AS RandomRange
FROM tbl
WHERE BirthYear > 1970;

-- Check result (unmergable)
SELECT /*+ recompile */ *
FROM v_drandom
WHERE RandomRange > 50;

--Convert the view to an inline view (unmergable)
DROP VIEW IF EXISTS v_drandom;
SELECT /*+ recompile */ *
FROM (
    SELECT ID, Name, DRANDOM() AS RandomRange
    FROM tbl
    WHERE BirthYear > 1970
) v
WHERE RandomRange > 50;

-- Create a view using SYS_GUID() function
CREATE OR REPLACE VIEW v_sys_guid AS
SELECT ID, Name, SYS_GUID() AS UniqueID
FROM tbl
WHERE BirthYear < 1980;

-- Check result (unmergable)
SELECT /*+ recompile */ *
FROM v_sys_guid
WHERE UniqueID IS NULL;

--Convert the view to an inline view (unmergable)
DROP VIEW IF EXISTS v_sys_guid;
SELECT /*+ recompile */ *
FROM (
    SELECT ID, Name, SYS_GUID() AS UniqueID
    FROM tbl
    WHERE BirthYear < 1980
) v
WHERE UniqueID IS NULL;


DROP TABLE IF EXISTS tbl;

