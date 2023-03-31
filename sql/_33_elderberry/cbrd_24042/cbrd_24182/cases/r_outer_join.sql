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

update statistics on t;

--right outer join?? ==> to_do
SELECT /*+ recompile */ count(1)
FROM   t a
       right outer join t b
                     ON a.c_a = b.c_a
                    AND a.c_b = b.c_b
WHERE  b.c_c = 1;
SELECT /*+ recompile */ count(*)
FROM   t a
       join t b
         ON a.c_a = b.c_a
        AND a.c_a = b.c_b
       left outer join t c
                    ON a.c_a = c.c_a
                   AND b.c_b = c.c_b
WHERE  a.c_c = 1;
SELECT /*+ recompile */ count(*)
FROM   t a,
       t b,
       t c
WHERE  a.c_a = b.c_a
       AND a.c_a = b.c_b
       AND a.c_a = c.c_a(+)
       AND a.c_b = c.c_b(+)
       AND a.c_c = 1;
SELECT /*+ recompile */ count(*)
FROM   t a,
       t b,
       t c,
       t d
WHERE  a.c_a = b.c_a
       AND a.c_a = b.c_b
       AND a.c_a = c.c_a(+)
       AND a.c_b = c.c_b(+)
       AND nvl(c.c_c, 1) = d.c_c;
DROP TABLE t;
