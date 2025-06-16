--Case where view merge is impossible.
DROP TABLE IF EXISTS t_a, t_b;
CREATE TABLE t_a
  (
     col_a INT,
     col_b INT
  );

CREATE TABLE t_b
  (
     col_a INT,
     col_b INT
  );
INSERT INTO t_a
VALUES (1,1),(2,2),(3,3);
INSERT INTO t_b
VALUES (1,1),(2,2),(3,3);

--subquery has CTE spec.
SELECT /*+ recompile */ a.col_a
FROM   t_a a,
       (WITH t AS SELECT col_a,
        col_b col_b
        FROM  t_b
        WHERE col_a > 1
        SELECT *
        FROM t) b
WHERE  a.col_a = b.col_a limit 1;
DROP TABLE t_a, t_b;
