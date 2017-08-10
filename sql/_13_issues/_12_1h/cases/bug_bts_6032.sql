autocommit on;
CREATE TABLE tab0(col0 INTEGER);
INSERT INTO tab0 VALUES(3545);
INSERT INTO tab0 VALUES(1657);
SELECT col0, +col0,-60 * + - col0 FROM tab0 AS cor0 WHERE col0 IN ( +col0, -60 * + - col0) order by 1; 
drop table tab0;

