drop table if exists t1;
CREATE TABLE t1 (a INT);
INSERT INTO t1 VALUES (1),(2),(3);
SELECT * FROM (WITH a AS (SELECT * FROM t1) SELECT 1) AS t1;
drop table if exists t1;
