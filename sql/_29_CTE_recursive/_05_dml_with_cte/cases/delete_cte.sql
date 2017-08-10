drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int);
insert into t2 values(3);
delete from  t2 where c in (with recursive subquery_t1(a) as(select 1  union all select a+1 from t1 where a<10)select * from subquery_t1);
delete from  t2 where c not in (with recursive subquery_t1(a) as(select 1  union all select a+1 from t1 where a<10)select * from subquery_t1);
drop if exists t1,t2;
