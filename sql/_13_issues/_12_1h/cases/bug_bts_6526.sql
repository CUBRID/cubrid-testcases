drop table if exists t1,t2;
CREATE TABLE t1 (a INT , b INT );
CREATE TABLE t2 (c INT , d INT );
INSERT INTO t1 VALUES (1, NULL);
INSERT INTO t2 VALUES (NULL, 3);

--CUBRID returned nothing. But MySQL and Oracle have one record in their result.
SELECT * FROM t1 WHERE NULL NOT IN (SELECT c FROM t2 WHERE c = 1 AND c <> 1);
drop table if exists t1,t2;
