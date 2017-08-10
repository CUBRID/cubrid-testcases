drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int);
insert into t2 values(3); 
WITH recursive outer_subquery AS (
      select (WITH nested_subquery AS (
            SELECT a FROM t1
            ) select * from nested_subquery) from nested_subquery  
     )	  
   SELECT *
   FROM   outer_subquery;

WITH recursive outer_subquery AS (
select * from (WITH nested_subquery AS (
SELECT a FROM t1
) select * from nested_subquery) x
)
SELECT *
FROM   outer_subquery order by 1;

WITH recursive outer_subquery AS (
select (WITH nested_subquery AS (
SELECT a FROM t1
) select * from nested_subquery order by 1 desc limit 1) as x
)
SELECT *
FROM   outer_subquery order by 1;

WITH recursive outer_subquery AS (
select (WITH nested_subquery AS (
SELECT a FROM t1
) select * from nested_subquery order by 1 desc limit 1) as x
)
SELECT *
FROM   outer_subquery, (WITH nested_subquery AS (
SELECT a FROM t1
) select * from nested_subquery) x order by 1;

WITH recursive outer_subquery AS (
select (WITH nested_subquery AS (
SELECT a FROM t1
) select * from nested_subquery order by 1 desc limit 1) as x
)
SELECT *
FROM   outer_subquery y, (WITH nested_subquery AS (
SELECT a FROM t1
) select * from nested_subquery) x where y.x=x.a  order by 1;
drop if exists t1,t2;
