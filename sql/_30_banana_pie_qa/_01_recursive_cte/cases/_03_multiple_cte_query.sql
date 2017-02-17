WITH RECURSIVE my_cte AS
(
  SELECT 1 as f, 1 as next_f
  UNION ALL
  SELECT next_f, f+next_f FROM my_cte WHERE f < 500
)
SELECT * FROM my_cte order by f, next_f;


WITH RECURSIVE
digits AS
(
  SELECT '0' AS d UNION ALL SELECT '1'
),
strings AS
(
  SELECT '' AS s
  UNION ALL
  SELECT CONCAT(strings.s, digits.d)
  FROM strings, digits
  WHERE LENGTH(strings.s) < 4
)
SELECT s FROM strings WHERE LENGTH(s)=4 order by s;



WITH RECURSIVE
digits AS
(
  SELECT '0' AS d UNION ALL SELECT '1'
),
strings AS
(
  SELECT '' AS s
  UNION ALL
  SELECT CONCAT(strings.s, digits.d)
  FROM strings, digits
  WHERE LENGTH(strings.s) < 4
)
SELECT s FROM strings WHERE LENGTH(s)=4 order by 1;

with cte as (select from_base64('VGhhbmsgeW91IGZvciB0cnlpbmcgcmVjdXJzaXZlIENURXMh') as final_words)select * from cte;
