drop table if exists t2;

create table t2 (a varchar(10) default 'QA');
insert into t2 values ('QA');
insert into t2 values ('QB');
insert into t2 values ('QA');

--Q1 note: return two rows 
select * from t2 where a like '%A';

--note: this is important for this issue
select * from t2 where a like '%A' limit 0;
--test: fail to return nothing. (we expect result is same as Q1's)
select * from t2 where a like '%A' limit 2;
 
drop table if exists t2;
