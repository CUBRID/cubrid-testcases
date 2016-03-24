create table t(i int) partition by hash(i) partitions 3;

insert into t select rownum from db_class limit 10;
create unique index u_t_i on t(i);
select * from t;
alter table t remove partitioning;

drop table t;



create table u(id int auto_increment)
partition by range(id) (partition l5 values less than (5),
partition l10 values less than (10),
partition l20 values less than (20),
partition l100 values less than (100));

insert into u values(0),(5),(10),(20);
create unique index i_u_id on u(id);
select * from u;
alter table u remove partitioning;

drop table u;

create table t(i int) partition by hash(i) partitions 3;
create unique index u_t_i on t(i);
insert into t select rownum from db_class limit 45;

alter unique index u_t_i on t(i) rebuild;

alter table t remove partitioning;

drop table t;


create table t(i int);
create table u under t(j int);

insert into t values(1);
insert into u values(1, 1);

alter class t add unique(i);

drop table t;

drop table u;

create table t(i int);
create table u under t(j int);

insert into t select rownum from db_class limit 0, 10;
insert into u select 10+rownum, 10+rownum from db_class limit 0, 10;

alter class t add unique(i);

select i from all t where i = 15;

insert into t(i) values(15);
drop table t;

drop table u;

create table t1(i1 int);
create table t2 under t1(i2 int);
create table t3 under t2(i3 int);
create table t4 under t3(i4 int);
create table t5 under t4(i5 int);

insert into t1 select rownum from db_class limit 0, 10;
insert into t2 select 10+rownum, 10+rownum from db_class limit 0, 10;
insert into t3 select 20+rownum, 20+rownum, 20+rownum from db_class limit 0, 10;
insert into t4 select 30+rownum, 30+rownum, 30+rownum, 30+rownum from db_class limit 0, 10;
insert into t5 select 40+rownum, 40+rownum, 40+rownum, 40+rownum, 40+rownum from db_class limit 0, 10;

alter class t1 add unique(i1);

select i1 from all t1 where i1 = 25;

insert into t1(i1) values(15);
insert into t1(i1) values(25);

drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;
