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

--dnf test
--removal
SELECT /*+ recompile */ a.*
FROM   t a
       LEFT OUTER JOIN t b
                    ON a.c_a = b.c_a
                       AND a.c_b = b.c_b
                       AND ( ( a.c_a = 5
                               AND b.c_a = 5 )
                              OR ( a.c_a = 2
                                   AND b.c_a = 2 )
                              OR ( a.c_a = 3
                                   AND b.c_a = 3 )
                              OR ( a.c_a = 4
                                   AND b.c_a = 4 )
                              OR ( a.c_a = 5
                                   AND b.c_a = 5 ) )
WHERE  a.c_c = 1;
--unremoval
SELECT /*+ recompile */ count(*)
FROM   t a
       LEFT OUTER JOIN t b
                    ON a.c_a = b.c_a
                       AND a.c_b = b.c_b
WHERE  a.c_c = 1
       AND ( ( a.c_a = 5
               AND b.c_a = 5 )
              OR ( a.c_a = 2
                   AND b.c_a = 2 )
              OR ( a.c_a = 3
                   AND b.c_a = 3 )
              OR ( a.c_a = 4
                   AND b.c_a = 4 )
              OR ( a.c_a = 5
                   AND b.c_a = 5 ) ); 
DROP TABLE t;
