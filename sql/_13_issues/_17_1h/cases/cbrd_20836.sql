drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');  
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);  
with t as (select * from t2 where c>3),
     t as (select a from t1 where a>2)
 select * from t,t1 where t1.a=t.c;
drop if exists t1,t2;
