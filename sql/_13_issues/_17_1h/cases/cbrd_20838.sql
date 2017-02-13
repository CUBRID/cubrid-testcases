drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');  
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);  
with t(f) as (select * from t1 where b >= 'c') 
  select t1.b from t2,t1 where t1.a = t2.c;
drop if exists t1,t2;

create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);
with t(f1,f2) as (select * from t2)
  select t1.b from t2,t1 where t1.a = t2.c;
drop if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);
with t(f1,f2) as (select * from t2,t1 where t2.c=t1.a)
  select t1.b from t2,t1 where t1.a = t2.c;
drop if exists t1,t2;
