WITH cte1(txt) AS (SELECT 'This '),
     cte2(txt) AS (SELECT CONCAT(cte1.txt,'is a ') FROM cte1),
     cte3(txt) AS (SELECT 'nice query' UNION
                   SELECT 'query that rocks' UNION
                   SELECT 'query'),
     cte4(txt) AS (SELECT concat(cte2.txt, cte3.txt) FROM cte2, cte3)
SELECT MAX(txt), MIN(txt) FROM cte4;


SELECT MAX(txt), MIN(txt)
FROM
(
  SELECT concat(cte2.txt, cte3.txt) as txt
  FROM
  (
    SELECT CONCAT(cte1.txt,'is a ') as txt
    FROM
    (
      SELECT 'This ' as txt
    ) as cte1
  ) as cte2,
  (
    SELECT 'nice query' as txt
    UNION
    SELECT 'query that rocks'
    UNION
    SELECT 'query'
  ) as cte3
) as cte4;



WITH RECURSIVE my_cte AS
(
  SELECT 1 AS n
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<10
)
SELECT * FROM my_cte order by n;

drop table if exists numbers;
CREATE TABLE numbers
  WITH RECURSIVE my_cte(n) AS
  (
    SELECT 1
    UNION ALL
    SELECT 1+n FROM my_cte WHERE n<6
  )
  SELECT * FROM my_cte order by 1;


INSERT INTO numbers (
WITH RECURSIVE my_cte(n) AS
(
  SELECT 1
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<6
)
SELECT * FROM my_cte);


WITH RECURSIVE my_cte(n) AS
(
  SELECT 1
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<6
)
UPDATE numbers, my_cte
SET numbers.n=0
WHERE numbers.n=my_cte.n*my_cte.n;


WITH RECURSIVE my_cte(n) AS
(
  SELECT 1
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<6
)
DELETE FROM numbers WHERE numbers.n > (SELECT AVG(n) FROM my_cte);


DELETE FROM numbers   WHERE numbers.i >  ( 
WITH RECURSIVE my_cte(i) AS   ( SELECT 1 UNION ALL  SELECT 1+i FROM my_cte WHERE i<6 
)  SELECT AVG(i)/2 FROM my_cte   );

drop table if exists numbers;
