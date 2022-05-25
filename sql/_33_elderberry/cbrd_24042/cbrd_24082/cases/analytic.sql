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

-- subquery check. has analytic (unmergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         Rank()
           over(
             PARTITION BY a.col_a
             ORDER BY a.col_b) col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a;

SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;
DROP VIEW v; 
DROP TABLE t_a, t_b;
