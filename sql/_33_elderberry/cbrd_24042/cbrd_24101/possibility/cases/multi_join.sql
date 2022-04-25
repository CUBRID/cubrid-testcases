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

--multiple join
SELECT /*+ recompile */ *
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
        WHERE  col_a > 1) b,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) c,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) d,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) e
WHERE  a.col_a = b.col_a
AND    b.col_a = c.col_a
AND    c.col_a = d.col_a
AND    d.col_a = e.col_a;
SELECT /*+ recompile */ *
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
        WHERE  col_a > 1) b,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) c,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) d,
       (SELECT col_a,
               Max(col_b) col_b
        FROM   t_b
        WHERE  col_a > 1
        GROUP  BY col_a) e
WHERE  a.col_a = b.col_a
AND    b.col_a = c.col_a
AND    c.col_a = d.col_a
AND    d.col_a = e.col_a;
DROP TABLE t_a, t_b;
