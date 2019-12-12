drop table if exists t1;
CREATE TABLE t1 (a int , b int );
INSERT INTO t1 VALUES (20, NULL);
SELECT t2.b, (t2.b is null), ifnull(t2.b, 'OK'), ifnull(null, 'OK') FROM t1 t2 LEFT JOIN t1 t3 ON t2.b = t3.a;
drop t1;
