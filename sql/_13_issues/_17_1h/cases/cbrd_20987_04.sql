drop table if exists t1,t2;
create table t1(i int primary key,j char(50));
insert into t1 values(1,'aaaaa');
insert into t1 values(3,'aaaab');
insert into t1 values(5,'aaaac');
insert into t1 values(7,'aaaad');
SELECT * FROM (SELECT * FROM t1) AS derived_t1;
create table t2(j char(50),k int);
insert into t2 values('aaaaa',3);
insert into t2 values('aaaad',5);
with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select f1 from avg_i)
 and t1.j=t2.j;

with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select max(f1) from avg_i)
 and t1.j=t2.j;

with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select max(avg_i.f1) from avg_i)
 and t1.j=t2.j;


with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select max(avg_i.*) from avg_i)
 and t1.j=t2.j;

 
drop table if exists t1,t2;
create table t1(i int primary key,j char(50));
insert into t1 values(1,'aaaaa');
insert into t1 values(3,'aaaab');
insert into t1 values(5,'aaaac');
insert into t1 values(7,'aaaad');
SELECT * FROM (SELECT * FROM t1) AS derived_t1;
create table t2(j char(50),k int);
insert into t2 values('aaaaa',3);
insert into t2 values('aaaad',5);
with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select f1 from avg_i) order by 1,2,3,4;

with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select * from avg_i) order by 1,2,3,4;

with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select avg_i.* from avg_i) order by 1,2,3,4;

with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from t1
 inner join t2
 where i >(select avg_i.f1 from avg_i) order by 1,2,3,4;

 
drop table if exists t1,t2;
create table t1(i int primary key,j char(50));
insert into t1 values(1,'aaaaa');
insert into t1 values(3,'aaaab');
insert into t1 values(5,'aaaac');
insert into t1 values(7,'aaaad');
SELECT * FROM (SELECT * FROM t1) AS derived_t1;
create table t2(j char(50),k int);
insert into t2 values('aaaaa',3);
insert into t2 values('aaaad',5);
with avg_i(f1) as (
 select avg(i) from t1
 )
 select * from avg_i 
 inner join t1
 where i > f1 order by 1,2,3;
 drop table if exists t1,t2;
 
