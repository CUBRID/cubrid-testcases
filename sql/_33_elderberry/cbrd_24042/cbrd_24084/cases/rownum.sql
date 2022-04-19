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
SELECT to_char(rownum mod 100) col_a,
       to_char(rownum)         col_b
FROM   TABLE({0,1,2,3,4,5,6,7,8,9}) a,
       TABLE({0,1,2,3,4,5,6,7,8,9}) b,
       TABLE({0,1,2,3,4,5,6,7,8,9}) c,
       TABLE({0,1,2,3,4,5,6,7,8,9}) d,
       TABLE({0,1,2,3,4,5,6,7,8,9}) e,
       TABLE({0,1,2,3,4,5,6,7,8,9}) f limit 10;
INSERT INTO t_b
SELECT to_char(rownum mod 100) col_a,
       to_char(rownum)         col_b
FROM   TABLE({0,1,2,3,4,5,6,7,8,9}) a,
       TABLE({0,1,2,3,4,5,6,7,8,9}) b,
       TABLE({0,1,2,3,4,5,6,7,8,9}) c,
       TABLE({0,1,2,3,4,5,6,7,8,9}) d,
       TABLE({0,1,2,3,4,5,6,7,8,9}) e,
       TABLE({0,1,2,3,4,5,6,7,8,9}) f limit 10;

--rownum of the view's subquery
CREATE OR REPLACE view v
AS
  SELECT col_a,
         (SELECT col_b
          FROM   t_b
          LIMIT  1) col_b
  FROM   t_a
  WHERE  col_a = 1; 
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND a.col_b = 1; 

--the view with rownum merged
CREATE OR REPLACE view v
AS
  SELECT col_a,
         col_b
  FROM   t_a
  ORDER  BY col_a,
            col_b
  LIMIT  3; 
SELECT /*+ recompile */ a.col_a
FROM   v a
WHERE  a.col_b = 5;  

DROP TABLE t_a, t_b;
