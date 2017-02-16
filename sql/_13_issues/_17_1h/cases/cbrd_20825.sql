WITH cte_DFfnZsBNP AS
(
select dayofyear(timestamp'04:14:07 1/19/2038')
)
select * from cte_DFfnZsBNP;

with cte as 
(
 select DAYOFMONTH(timestamp'04:14:07 1/19/2038')
)select * from cte;

with cte as
(
 select DAY(timestamp'04:14:07 1/19/2038')
)select * from cte;

with cte as
(
 select DAYOFWEEK(timestamp'04:14:07 1/19/2038')
)select * from cte;

with cte as
(
 select QUARTER(timestamp'04:14:07 1/19/2038')
)select * from cte;

with cte as
(
 select TIME(timestamp'04:14:07 1/19/2038')
)select * from cte;

with cte as
(
 select HOUR(timestamp'04:14:07 1/19/2038')
)select * from cte;

drop table if exists t1;

create table t1 (a int);

insert into t1 values (1), (2), (3), (4), (5);

WITH cte_WE3q01hoP AS
(
select /*+ recompile */ * from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1) ORDER BY a desc limit 1)
)
select * from cte_WE3q01hoP;

WITH cte_WE3q01hoP AS
(
select /*+ recompile */ * from ((SELECT a from t1 where 1=0) UNION (SELECT * FROM t1) ORDER BY a limit 1)
)
select * from cte_WE3q01hoP;

WITH RECURSIVE temp (n, fact) AS   (SELECT 0, 1  UNION ALL SELECT n+1, (n+1)*fact FROM temp) SELECT * FROM temp;
WITH RECURSIVE temp (n, fact) AS   (SELECT 0, 1  UNION ALL SELECT n+1, (n+1)*fact FROM temp where n<9) SELECT * FROM temp order by 1;
WITH RECURSIVE temp (n, fact) AS   (SELECT 0, 1  UNION ALL SELECT n+1, (n+1)*fact FROM temp where n<100) SELECT * FROM temp;


drop table if exists t1;

create table t1(a int);

insert into t1 values (1);

insert into t1 values (2);

insert into t1 values (3);

select * from t1 order by 1+2 desc;

WITH cte_R1no0RdlI AS
(
select a from t1 order by 1+2 desc
)
select * from cte_R1no0RdlI order by 1;

WITH cte_R1no0RdlI AS
(
select a from t1 order by 'a'||'b' desc
)
select * from cte_R1no0RdlI order by 1;

drop table if exists t1;
