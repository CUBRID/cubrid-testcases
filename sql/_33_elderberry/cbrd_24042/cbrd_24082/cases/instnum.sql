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

--subquery check. has instnum (unmergable)
CREATE OR REPLACE view v
AS
  SELECT a.col_a,
         b.col_b col_b
  FROM   t_a a,
         t_b b
  WHERE  a.col_a = b.col_a
  ORDER  BY b.col_a
  LIMIT  10;
SELECT /*+ recompile */ a.col_a
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2; 
DROP VIEW v;

--Convert the view to an inline view (unmergable)
SELECT /*+ recompile */ a.col_a
FROM   (SELECT a.col_a,
               b.col_b col_b
        FROM   t_a a,
               t_b b
        WHERE  a.col_a = b.col_a
        ORDER  BY b.col_a
        LIMIT  10) a,
       t_b b
WHERE  a.col_a = b.col_a
       AND b.col_b = 2;
-- In the query plan for an inline view, 'ha_?' refers to a hidden attribute. When a column in the ORDER BY clause is not present 
-- in the select list, a hidden column is added. In this case, 'b.col_a' was added, and as a result, a value was also added 
-- to the as_attr_list. 'ha' stands for 'hidden attribute.'


DROP TABLE t_a, t_b;
