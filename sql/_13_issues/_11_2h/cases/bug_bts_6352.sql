DROP TABLE IF EXISTS t;
DROP TABLE IF EXISTS t1;
DROP TABLE IF EXISTS t2;
CREATE TABLE t ( i int );
INSERT INTO t VALUES (1), (2), (3);

CREATE TABLE t1 like t;
INSERT INTO t1 VALUES (0);

CREATE TABLE t2 like t;
INSERT INTO t2 VALUES (1);
SELECT --+ RECOMPILE
i FROM t
     WHERE
        NOT EXISTS (
              SELECT 1
                FROM (SELECT t1.i
                        FROM t1
                      UNION
                      SELECT t2.i
                        FROM t2
                     ) a
                 WHERE t.i = a.i
        )
ORDER BY 1;
SELECT --+ RECOMPILE
i FROM t
     WHERE
        NOT EXISTS (
              SELECT 1
                FROM (SELECT t1.i
                        FROM t1
                        WHERE t1.i = t.i
                      UNION
                      SELECT t2.i
                        FROM t2
                        WHERE t2.i = t.i
                     ) a
        )
ORDER BY 1;
drop table t;
drop table t1;
drop table t2;
