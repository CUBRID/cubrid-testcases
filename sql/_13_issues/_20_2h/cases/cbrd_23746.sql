DROP TABLE IF EXISTS tmp4;
CREATE TABLE tmp4 (col1 VARCHAR(1));
INSERT INTO tmp4 SELECT '1' FROM db_root;

DROP TABLE IF EXISTS tmp5;
CREATE TABLE tmp5 (col1 VARCHAR(1));
INSERT INTO tmp5 SELECT '1' FROM db_root;
CREATE INDEX cub11 ON tmp5(NVL(col1,''));

SELECT /*+ ordered recompile */ *
FROM tmp4 a, tmp5 b USE INDEX(cub11)
WHERE a.col1 = NVL(b.col1,'');

DROP TABLE tmp4;
DROP TABLE tmp5;

