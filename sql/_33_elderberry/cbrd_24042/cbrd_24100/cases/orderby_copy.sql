DROP TABLE IF EXISTS t_a, t_b;
CREATE TABLE t_a
  (
     col_a VARCHAR(100),
     col_b VARCHAR(100)
  );
CREATE TABLE t_b
  (
     col_a VARCHAR(100),
     col_b VARCHAR(100)
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
CREATE INDEX idx
  ON t_a(col_a, col_b); 
CREATE INDEX idx
  ON t_b(col_a, col_b);
CREATE OR replace VIEW v_a
AS
  SELECT col_a,
         col_b
  FROM   t_b
  ORDER  BY col_b,
            col_a;
SELECT /*+ recompile */ Count(*)
FROM   t_a a,
       v_a b
WHERE  a.col_a = b.col_a
       AND b.col_b = 1; 
DROP VIEW v_a; 
DROP TABLE t_a, t_b;
