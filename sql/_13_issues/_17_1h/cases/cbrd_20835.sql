drop table if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');  
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);  
with t as (select a from t1 where b >= 'c') 
  select t2.*,t.* from t2,t where t2.c=t.a;

drop table if exists t1,t2;
create table t1 (a int, b  varchar(32));
insert into t1 values
  (4,'aaaa' ), (7,'bb'), (1,'ccc'), (4,'dd');
insert into t1 values
  (3,'eee'), (7,'bb'), (1,'fff'), (4,'ggg');
create table t2 (c int);
insert into t2 values
  (2), (4), (5), (3);
with t as (select a from t1 where b >= 'c')
select t2.*,t.*,t1.a,t1.b from t2,t,t1 where t2.c=t.a and t1.a=t.a order by 1,2,3,4;
drop table if exists t1,t2;

