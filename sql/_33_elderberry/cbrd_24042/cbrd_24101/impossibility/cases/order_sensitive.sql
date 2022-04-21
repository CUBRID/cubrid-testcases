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

--order-sensitive (GROUP_CONCAT, CUME_DIST, PERCENT_RANK, PERCENTILE_CONT, PERCENTILE_DISC, JSON)
SELECT group_concat(a.col_a) col_a
FROM   t_a a,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1
        ORDER  BY 2 DESC) b
WHERE  a.col_a = b.col_a;
SELECT cume_dist(1,1) 
	within GROUP (ORDER BY col_a,col_b) AS cume           
FROM   t_a;
SELECT percent_rank(100)
         within GROUP (ORDER BY col_a) AS pct_rnk
FROM   t_a; 
SELECT Percentile_cont(0.5)
         within GROUP(ORDER BY col_b) AS pcont
FROM   t_b; 
SELECT Percentile_disc(0.5)
         within GROUP(ORDER BY col_a) AS pdisc
FROM   t_b; 
SELECT Json_object()
FROM   t_a a,
       (SELECT col_a,
               col_b
        FROM   t_b
        WHERE  col_a > 1
        ORDER  BY 2 DESC) b
WHERE  a.col_a = b.col_a; 

DROP TABLE t_a, t_b;
