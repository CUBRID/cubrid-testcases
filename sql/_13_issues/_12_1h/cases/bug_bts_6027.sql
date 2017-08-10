drop table if exists tab0;
CREATE TABLE tab0(pk INTEGER PRIMARY KEY, col0 INTEGER, col1 FLOAT);
INSERT INTO tab0 VALUES(0,13,22.43);
INSERT INTO tab0 VALUES(1,21,62.55);
CREATE INDEX idx_tab0_0 ON tab0 (col0 DESC,col1);
SELECT pk FROM tab0 WHERE (col0>28 OR col0<28);
drop table tab0;
