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

--check for NOT FROM
SELECT /*+ recompile */ a.col_a
FROM   t_a a,
       (SELECT 1 col_a) b
WHERE  a.col_a = b.col_a
LIMIT  1;
DROP TABLE t_a, t_b;
