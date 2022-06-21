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

--subquery check. has connect by (unmergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a
  CONNECT BY a.col_a = PRIOR a.col_b;
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;

--subquery check. connect by (unmergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a;

SELECT /*+ recompile */ a.col_a
FROM   t_b b,
       v a
WHERE  a.col_a = b.col_a
       AND b.col_b = 2
CONNECT BY a.col_a = PRIOR a.col_b;  
DROP TABLE t_a, t_b;
