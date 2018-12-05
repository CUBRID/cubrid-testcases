drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int,name varchar(10));
insert into t2 values(3,'english'); 
insert into t2 values(4,'english');

WITH recursive o_s AS (
select * from (WITH n_s AS (SELECT a FROM t1) select * from n_s order by 1 desc limit 1) as x
)
SELECT *
FROM   o_s order by 1;

drop if exists t1,t2;
