drop table if exists t1;

CREATE TABLE t1 (a INT , b INT , c INT);
SELECT t1.a FROM t1 GROUP BY t1.a HAVING t1.a IN (SELECT s.a FROM t1 s ORDER BY SUM(t1.b));
drop table if exists t1;
