DROP TABLE IF EXISTS t;

CREATE TABLE t
  (
     col_a VARCHAR(10),
     col_b VARCHAR(10)
  );

INSERT INTO t
VALUES ('1',
        '5');

INSERT INTO t
VALUES ('2',
        '4');

INSERT INTO t
VALUES ('3',
        '3');

INSERT INTO t
VALUES ('4',
        '2');

INSERT INTO t
VALUES ('5',
        '1');

--distinct + order by
CREATE OR REPLACE view v
AS
  SELECT col_a,
         col_b
  FROM t
  ORDER BY col_b,
           col_a;

SELECT /*+ recompile */ col_a
FROM v;
SELECT /*+ recompile */ col_a
FROM v
ORDER  BY col_a;  
SELECT /*+ recompile */ col_a,
                        col_b
FROM v;
SELECT /*+ recompile */ DISTINCT col_a
FROM   v; 
SELECT /*+ recompile */ DISTINCT col_b,
                                 col_a
FROM   v;
DROP VIEW v; 
DROP TABLE t; 
