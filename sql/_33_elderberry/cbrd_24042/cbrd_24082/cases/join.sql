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

--view has join. main query has join. (mergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_b = b.col_b
         AND a.col_a = 1;
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND a.col_b = 2; 
DROP TABLE t_a, t_b;
