DROP TABLE IF EXISTS t;
CREATE TABLE t
  (
     c_a INT,
     c_b INT,
     c_c INT
  );
INSERT INTO t
VALUES  (1,1,1),
        (2,2,2),
        (3,3,3);
CREATE UNIQUE INDEX idx
  ON t(c_a, c_b);
CREATE INDEX idx_a
  ON t(c_a, c_c);
--not outer join
SELECT /*+ recompile */count(*)
FROM   t a
       LEFT OUTER JOIN t b
                    ON a.c_a = b.c_a
                   AND a.c_b = b.c_b
WHERE  a.c_c = 1
AND    b.c_c = 3; 
SELECT /*+ recompile */ count(*)
FROM   t a,
       t b
WHERE  a.c_a = b.c_a
AND    a.c_b = b.c_b
AND    a.c_c = 1; 
DROP TABLE t;
