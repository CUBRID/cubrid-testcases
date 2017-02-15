drop table if exists t1;
create table t1(pname string, cases int primary key);
insert into t1 values('Morgan',1);
insert into t1 values('Dan',2);
insert into t1 values('Jack',3);

update t1 set pname='aa' where cases in (with cte as (select max(cases) from t1 ) select * from cte);
select * from t1 order by cases;
update t1 set pname='aabb' where cases in (with cte as (select cases from t1 order by cases desc limit 1) select * from cte);
select * from t1 order by cases;
with cte as (select cases from t1 where cases in (with cte as (select max(cases) from t1 ) select * from cte))select * from cte;

drop table if exists t1;
