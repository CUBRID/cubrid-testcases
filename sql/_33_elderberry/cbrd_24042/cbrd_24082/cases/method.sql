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
--subquery check. has method (unmergable)
CREATE OR REPLACE FUNCTION Sp_int(i int)
RETURN int AS language java name 'SpCubrid.SpInt(int) return int';
CREATE OR REPLACE VIEW v AS
SELECT a.col_a,
       Sp_int(a.col_b) col_b
FROM   t_a a,
       t_b b
WHERE  a.col_a = b.col_a;

SELECT /*+ recompile */ a.col_a, a.col_b
FROM   v a,
       t_b b
WHERE  a.col_a = b.col_a
AND    b.col_b = 2;
DROP FUNCTION Sp_int;
DROP TABLE t_a, t_b;
