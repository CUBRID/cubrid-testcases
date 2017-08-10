drop table if exists t1;

CREATE  TABLE  t1 (a INT , b INT , c INT);

SELECT 
(
    SELECT count(outr.a) FROM t1
)  
FROM t1 AS outr 
ORDER BY a 
LIMIT 1;

drop table t1;
