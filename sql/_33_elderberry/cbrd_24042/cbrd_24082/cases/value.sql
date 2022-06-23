DROP TABLE IF EXISTS t_a, t_b;
CREATE TABLE t_a
  (
     col_a INT,
     col_b INT,
     col_c INT
  );

CREATE TABLE t_b
  (
     col_a INT,
     col_b INT,
     col_c INT
  );

--subquery check. value query (unmergable)
CREATE OR replace VIEW v AS VALUES
(
  1 AS col_a,
  2 AS col_b
),
(
  2,3
);
SELECT /*+ recompile */ a.col_a
FROM t_b b,
     v a
WHERE a.col_a = b.col_a
AND   b.col_b = 2;
DROP VIEW v;
DROP TABLE t_a, t_b;
