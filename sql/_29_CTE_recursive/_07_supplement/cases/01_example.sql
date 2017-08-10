WITH RECURSIVE temp (n, fact) AS 
(SELECT 0, 1
  UNION ALL 
 SELECT n+1, (n+1)*fact FROM temp
        WHERE n < 9)
SELECT * FROM temp;

WITH RECURSIVE my_cte AS
(
  SELECT 1 AS n
  UNION ALL
  SELECT 1+n FROM my_cte WHERE n<10
)
SELECT * FROM my_cte;
