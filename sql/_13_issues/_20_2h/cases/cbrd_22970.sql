DROP TABLE IF EXISTS tmp; 

CREATE TABLE tmp(col1 int);
INSERT INTO tmp VALUES(1);

-- case1  : XASL CACHE with data 
SELECT 'park' NAME
FROM tmp 
WHERE col1=1
HAVING COUNT(1) > 0;

-- case2  : execute without data 
SELECT 'park' NAME
FROM tmp 
WHERE col1=2
HAVING COUNT(1) > 0;

-- case3  
SELECT 'park' NAME  
FROM tmp 
WHERE col1=1
HAVING COUNT(1) > 0;

-- case4 : HINT /*+ Recompile */
SELECT /*+ Recompile */ 'park' NAME
FROM tmp
WHERE col1=1
HAVING COUNT(1) > 0;

DROP TABLE tmp;
