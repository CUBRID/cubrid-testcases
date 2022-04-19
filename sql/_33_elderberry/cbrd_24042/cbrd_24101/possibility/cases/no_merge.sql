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

--no_merge hint
SELECT /*+ recompile */ *
FROM   (SELECT *
        FROM   (SELECT *
                FROM   t_a
                WHERE  col_a < 100)
        WHERE  col_a > 1) a,
       (SELECT /*+ no_merge */ col_a,
                               col_b
        FROM   t_b
        WHERE  col_a > 1) b
WHERE  a.col_a = b.col_a;
SELECT /*+ recompile */ *
FROM   (SELECT /*+ no_merge */ *
        FROM   (SELECT *
                FROM   t_a
                WHERE  col_a < 100)
        WHERE  col_a > 1) a,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) b
WHERE  a.col_a = b.col_a; 
SELECT /*+ recompile */ *
FROM   (SELECT *
        FROM   (SELECT /*+ no_merge */ *
                FROM   t_a
                WHERE  col_a < 100)
        WHERE  col_a > 1) a,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1) b
WHERE  a.col_a = b.col_a; 
DROP TABLE t_a, t_b;
