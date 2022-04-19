--Case where view merge is possible.
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
VALUES (1,1),(2,2),(3,3);
INSERT INTO t_b
VALUES (1,1),(2,2),(3,3);

--order-sensitive (GROUP_CONCAT, CUME_DIST, PERCENT_RANK, PERCENTILE_CONT, PERCENTILE_DISC, SEQUENCE, JSON)
SELECT group_concat(a.col_a) col_a
FROM   t_a a,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1
        ORDER  BY 2 DESC) b
WHERE  a.col_a = b.col_a;
DROP TABLE t_a, t_b;
