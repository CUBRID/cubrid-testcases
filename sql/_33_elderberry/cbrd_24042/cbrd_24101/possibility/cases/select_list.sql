--Case where view merge is possible.
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

--select-list subquery
SELECT /*+ recompile */ (SELECT /*+ recompile */ a.col_a
                         FROM   (SELECT *
                                 FROM   (SELECT *
                                         FROM   (SELECT *
                                                 FROM   t_a
                                                 WHERE  col_a IS NOT NULL)
                                         WHERE  col_a < 100)
                                 WHERE  col_a > 1) a,
                                (SELECT col_a,
                                        col_b
                                 FROM   t_b
                                 WHERE  col_a > 1) b
                         WHERE  a.col_a = b.col_a
                         AND    a.col_a = aa.col_a) col_a
FROM  t_a aa;
DROP TABLE t_a, t_b;
