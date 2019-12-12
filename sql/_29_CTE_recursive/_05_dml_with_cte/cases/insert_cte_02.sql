drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int);
insert into t2 values(3);

--Expect return error: CUBRID allow only UNION ALL in recursive CTE 
insert into t2  (
with recursive subquery_t1 as(select a from t1 where t1.a<3 UNION select a+1 from subquery_t1 where a<10)select * from subquery_t1);

--Expect return OK
insert into t2  (
with recursive subquery_t1 as(select a from t1 where t1.a<3 UNION ALL select a+1 from subquery_t1 where a<10)select * from subquery_t1);

select * from t2 order by 1;
drop if exists t1,t2;
