DROP TABLE IF EXISTS tab_a, tab_b;

CREATE TABLE tab_a
  (
     col_a VARCHAR(100),
     col_b VARCHAR(100)
  ); 
CREATE TABLE tab_b
  (
     col_a VARCHAR(100),
     col_b VARCHAR(100)
  ); 
INSERT INTO tab_a
SELECT to_char(rownum mod 100) col_a,
       to_char(rownum)         col_b
FROM   TABLE({0,1,2,3,4,5,6,7,8,9}) a,
       TABLE({0,1,2,3,4,5,6,7,8,9}) b,
       TABLE({0,1,2,3,4,5,6,7,8,9}) c,
       TABLE({0,1,2,3,4,5,6,7,8,9}) d,
       TABLE({0,1,2,3,4,5,6,7,8,9}) e,
       TABLE({0,1,2,3,4,5,6,7,8,9}) f limit 10;
INSERT INTO tab_b
SELECT to_char(ROWNUM mod 100) col_a,
       to_char(ROWNUM)         col_b
FROM   TABLE({0,1,2,3,4,5,6,7,8,9}) a,
       TABLE({0,1,2,3,4,5,6,7,8,9}) b,
       TABLE({0,1,2,3,4,5,6,7,8,9}) c,
       TABLE({0,1,2,3,4,5,6,7,8,9}) d,
       TABLE({0,1,2,3,4,5,6,7,8,9}) e,
       TABLE({0,1,2,3,4,5,6,7,8,9}) f limit 10;
CREATE INDEX idx
  ON tab_a(col_a, col_b);

CREATE INDEX idx
  ON tab_b(col_a, col_b);

CREATE OR replace VIEW v1
AS
  SELECT col_a,
         Rank()
           over(
             PARTITION BY col_a
             ORDER BY col_b) col_b
  FROM   tab_b; 
SELECT /*+ recompile */ Count(*)
FROM   tab_a a,
       v1 b
WHERE  a.col_a = b.col_a
       AND b.col_b = 1; 
DROP TABLE tab_a, tab_b;
