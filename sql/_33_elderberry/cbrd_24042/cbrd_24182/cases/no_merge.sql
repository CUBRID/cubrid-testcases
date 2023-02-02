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

-- CBRD-24252 : function of stop reducing the number of join only works with no_eliminate_join.
-- Therefor to compare the result of both hints, few more cases are added.
-- no_merge
SELECT /*+ recompile no_merge */ count(*)
FROM   t a
       LEFT OUTER JOIN t b
                    ON a.c_a = b.c_a
                       AND a.c_b = b.c_b
WHERE  a.c_c = 1; 
-- no_merge no_eliminate_join
SELECT /*+ recompile no_merge no_eliminate_join */ count(*)
FROM   t a
       LEFT OUTER JOIN t b
                    ON a.c_a = b.c_a
                       AND a.c_b = b.c_b
WHERE  a.c_c = 1; 
-- no_eliminate_join
SELECT /*+ recompile no_eliminate_join */ count(*)
FROM   t a
       LEFT OUTER JOIN t b
                    ON a.c_a = b.c_a
                       AND a.c_b = b.c_b
WHERE  a.c_c = 1; 
DROP TABLE t;
