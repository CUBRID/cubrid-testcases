drop table if exists numbers;

CREATE TABLE numbers AS
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
SELECT * FROM my_cte order by 1);

SELECT * FROM numbers order by 1;

-- CBRD-22288
WITH RECURSIVE my_cte(n) AS
(
SELECT 1
UNION ALL
SELECT 1+n FROM my_cte WHERE n<6
)
UPDATE numbers, my_cte
SET numbers.n=0
WHERE numbers.n=my_cte.n*my_cte.n;

SELECT * FROM numbers order by 1;

-- CBRD-22288
WITH RECURSIVE my_cte(n) AS
(
SELECT 1
UNION ALL
SELECT 1+n FROM my_cte WHERE n<6
)
DELETE FROM numbers WHERE numbers.n > (SELECT AVG(n) FROM my_cte);

--err
DELETE FROM numbers   WHERE numbers.i >  (
WITH RECURSIVE my_cte(i) AS   ( SELECT 1 UNION ALL  SELECT 1+i FROM my_cte WHERE i<6
)  SELECT AVG(i)/2 FROM my_cte   );

DELETE FROM numbers WHERE numbers.n > (
WITH RECURSIVE my_cte(n) AS ( SELECT 1 UNION ALL SELECT 1+n FROM my_cte WHERE n<6
) SELECT AVG(n)/2 FROM my_cte );

SELECT * FROM numbers order by 1;

drop table if exists numbers;

