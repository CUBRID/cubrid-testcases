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

--subquery check. has distinct (unmergable)
CREATE OR replace VIEW v
AS
  SELECT DISTINCT a.col_a,
                  a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a;
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;
DROP VIEW v;

--Convert the view to an inline view (unmergable)
SELECT /*+ recompile */ a.col_a
FROM   (SELECT DISTINCT a.col_a,
                       a.col_b
        FROM   t_a a,
               t_b b
        WHERE  a.col_a = b.col_a) a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;


--subquery check. distinct (mergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a;
SELECT /*+ recompile */ DISTINCT a.col_a
FROM   t_b b,
       v a
WHERE  a.col_a = b.col_a
       AND b.col_b = 2; 
DROP VIEW v;

--Convert the view to an inline view (mergable)
SELECT /*+ recompile */ DISTINCT a.col_a
FROM   t_b b,
       (SELECT a.col_a,
               a.col_b
        FROM   t_a a,
               t_b b
        WHERE  a.col_a = b.col_a) a
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;

DROP TABLE t_a, t_b;
