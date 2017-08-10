drop view if exists  v1;
drop table if exists t1;
create table t1 (a int);
insert into t1 values (20), (30), (10);
create view v1 as select * from t1 where a > 10;
with recursive t1 as (select * from v1) select * from t1 order by 1;
drop view v1;
drop table t1;


drop if exists t1,t2;
drop if exists v1;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');  
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);  
with recursive t as (select a from t1 where b >= 'c') 
select * from t2,t where t2.c=t.a order by 1,2; 
create view v1 as 
with recursive t as (select a from t1 where b >= 'c') 
select * from t2,t where t2.c=t.a;  
drop view v1;
drop table t1;
drop table t2;
