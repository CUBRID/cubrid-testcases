drop table if exists t1,t2;
create table t2(j int primary key,k time);
create table t1(
    i int primary key,
    j int,
    k time
);
insert into t2 values(1,'13:00:00');
insert into t2 values(2,'13:00:00');
insert into t1 values(1,1,'10:00:00');
insert into t1 values(2,1,'10:00:00');
insert into t1 values(3,2,'13:00:00');

with mycte(k) as
(
  select time_format(k,'%H %i %s') from t2 where j>1 
) update t2,mycte set t2.j=t2.j+100 where time_format(t2.k,'%H %i %s')=mycte.k;

select * from t2 order by 1;


drop table if exists t1,t2;
create table t2(j int primary key,k time);
create table t1(
    i int primary key,
    j int,
    k time
);
insert into t2 values(1,'13:00:00');
insert into t2 values(2,'13:00:00');
insert into t1 values(1,1,'10:00:00');
insert into t1 values(2,1,'10:00:00');
insert into t1 values(3,2,'13:00:00');

with mycte(k) as
(
  select time_format(k,'%H %i %s') from t2 where j>1
) update t1,mycte set t1.j=t1.j+100 where time_format(t1.k,'%H %i %s')=mycte.k;

select * from t1 order by 1;

drop table if exists t1,t2;
create table t2(j int primary key,k time);
create table t1(
    i int primary key,
    j int,
    k time
);
insert into t2 values(1,'10:00:00');
insert into t2 values(2,'13:00:00');
insert into t1 values(1,1,'10:00:00');
insert into t1 values(2,1,'13:00:00');
insert into t1 values(3,2,'13:00:00');


with mycte(k) as
(
  select time_format(k,'%H %i %s') from t2 where j>1
) update t2,t1,mycte set t2.j=t2.j+10,t1.j=t1.j+20 where time_format(t2.k,'%H %i %s')=mycte.k and t1.k=t2.k;

select * from t1 order by 1,2;
select * from t2 order by 1,2;

drop table if exists t1,t2;
create table t2(j int primary key,k time);
create table t1(
    i int primary key,
    j int,
    k time
);
insert into t2 values(1,'10:00:00');
insert into t2 values(2,'13:00:00');
insert into t1 values(1,1,'10:00:00');
insert into t1 values(2,1,'13:00:00');
insert into t1 values(3,2,'13:00:00');

with mycte(k) as
(
  select time_format(k,'%H %i %s') from t2 where j<=1
) update t1,t2 set t1.j=t1.j+10,t2.j=t2.j+10 where time_format(t1.k,'%H %i %s')=(select k from mycte);


select * from t2 order by 1,2;
select * from t1 order by 1,2,3;

drop table if exists t1,t2;
