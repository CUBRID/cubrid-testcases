drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int);
insert into t2 values(3);
insert into t2 values
((with recursive subquery_t1 as(select a from t1 where t1.a<3 union all select a*2 from subquery_t1 where a<16)select * from subquery_t1));
insert into t2 values
((with recursive subquery_t1 as(select a from t1 where t1.a<3 union all select a*2 from subquery_t1 where a<16)select * from subquery_t1 
order by 1 desc limit 1));
insert into t2 values
((with recursive subquery_t1 as(select a from t1 where t1.a<3 union all select a*2 from subquery_t1 where a<16 order by 1 desc limit 1)select * from subquery_t1));
select * from t2 order by 1;
drop if exists t1,t2;
drop if exists t,t2;
create table t(i int primary key);
insert into t values(1);
insert into t(with cte as (select i+1 from t)select * from cte);
select * from t order by 1;
create table t2(i int primary key,j int);
insert into t2(i) (with cte(i) as (select i+1 from t)select distinct cte.i from cte,t );  
select * from t2 order by 1;
drop if exists t,t2;
drop if exists t1,t2;
create table t1 (a int primary key, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int primary key);
insert into t2 values(3);
insert into t2 values(  (with subquery_t1 as(select a from t1 where t1.a<3)select * from subquery_t1));
select * from t2 order by 1;
drop if exists t1,t2;
create table t1 (a int primary key, b  varchar(32));
insert into t1 values(1,'ccc');  
insert into t1 values(3,'eee');
create table t2 (c int primary key);
insert into t2 values(3);
insert into t2  (with subquery_t1 as(select a from t1 where t1.a<3)select * from subquery_t1);
select * from t2 order by 1;
drop if exists t1,t2;
