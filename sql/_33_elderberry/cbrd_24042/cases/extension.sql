--test case : View merging extension : remove unnecessary restriction
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

-- case 1 : view has join. main query has join. (mergable)
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

-- case 2 : subquery check. has outer join spec (unmergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a(+);
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2; 

-- case 3 : subquery check. has CONNECT BY (unmergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         a.col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_b
  CONNECT BY a.col_a = PRIOR a.col_b;
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_b
       AND b.col_b = 2; 

-- case 4 : subquery check. has DISTINCT (unmergable)
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

-- case 5 : subquery check. has aggregate (unmergable)
CREATE OR replace VIEW v
AS
  SELECT a.col_a,
         Count(a.col_b) col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a
  GROUP  BY a.col_a;
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;
DROP TABLE t_a, t_b;
 
