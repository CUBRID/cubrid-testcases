drop table if exists t1,t2;
create table t2(j int primary key,k time);
create table t1(
    i int primary key,
    j int,
    k time,
    constraint fk_j foreign key (j) references t2(j)
    ON delete CASCADE ON update RESTRICT
);
insert into t2 values(1,'13:00:00');
insert into t2 values(2,'13:00:00');
insert into t1 values(1,1,'10:00:00');
insert into t1 values(2,1,'10:00:00');
insert into t1 values(3,2,'10:00:00');

with mycte as
(
  select j from t2 where j>1
) update t2,mycte set t2.j=t2.j+10 where t2.j=mycte.j;


with mycte as
(
  select j from t2 where j>1
) update t1,mycte set t1.j=t1.j+10 where t1.j=mycte.j;


drop table if exists t1,t2;
create table t2(j int primary key,k time);
create table t1(
    i int primary key,
    j int,
    k time,
    constraint fk_j foreign key (j) references t2(j)
);
insert into t2 values(1,'13:00:00');
insert into t2 values(2,'13:00:00');
insert into t1 values(1,1,'10:00:00');
insert into t1 values(2,1,'10:00:00');
insert into t1 values(3,2,'10:00:00');

with mycte as
(
  select j from t2 where j>1
) update t2,mycte set t2.j=t2.j+10 where t2.j=mycte.j;


with mycte as
(
  select j from t2 where j>1
) update t1,mycte set t1.j=t1.j+10 where t1.j=mycte.j;


select * from t2 order by 1,2;
select * from t1 order by 1,2,3;

drop table if exists t1,t2;
