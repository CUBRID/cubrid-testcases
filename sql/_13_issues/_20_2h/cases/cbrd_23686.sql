DROP TABLE IF EXISTS tmp5;

CREATE TABLE tmp5 (col1 VARCHAR(10), col2 VARCHAR(10), col3 VARCHAR(10), col4 VARCHAR(10), col5 VARCHAR(10), col6 VARCHAR(10));
INSERT INTO tmp5 SELECT MOD(ROWNUM,11), MOD(ROWNUM,8), MOD(ROWNUM,8), MOD(ROWNUM,8), MOD(ROWNUM,8), MOD(ROWNUM,8) FROM  table({1,2,3,4,5,6,7,8,9,0}) a,  table({1,2,3,4,5,6,7,8,9,0}) b,  table({1,2,3,4,5,6,7,8,9,0}) c, table({1,2,3,4,5,6,7,8,9,0}) d, table({1,2,3,4,5,6,7,8,9,0}) e LIMIT 100000;
CREATE INDEX cub22 ON tmp5(col1,col2,col3,col4,col5,col6);
CREATE INDEX cub33 ON tmp5(col2);
UPDATE STATISTICS ON tmp5 WITH fullscan;

set optimization level 513;

SELECT /*+ recompile */ COUNT(1) FROM (select * from tmp5 limit 1000) a, tmp5 b
WHERE a.col1 = b.col1 
AND a.col2 = b.col2;

SELECT /*+ recompile */ COUNT(1) FROM (select * from tmp5 limit 1000) a, tmp5 b use index(cub22)WHERE a.col1 = b.col1
AND a.col2 = b.col2;

DROP TABLE tmp5;
