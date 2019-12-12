--test #1
autocommit off;
drop table if exists t,u,w;
create table t;
alter table t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create table t (i float);
show tables;
desc t;
drop t;

create table t;
alter table t rename to u, add column valid int, add column invalid int not null default 23, rename to w;
create table t (i float);
create table u (i double);
create table w (i varchar);
show tables;
desc t;
desc u;
desc w;
drop t;
drop u;
drop w;

--test #2
create view t;
alter view t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create view t;
show tables;
drop t;

create view t;
alter view t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create view t;
alter view t rename to u, add column valid int, rename to w;
create view t;
show tables;
drop t;
drop w;

create view t;
alter view t rename to u, add column valid int, add column invalid int, rename to w;
create view t;
alter view t add column i varchar;
insert into t select 'rownum' from db_root connect by level<=1000;
desc t;
desc w;
show tables;
drop t;
drop w;

create view t;
alter view t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create table t (i varchar);
insert into t select rownum from db_root connect by level<=2;
create view t as select * from t;
show tables;
desc t;
drop t;

create view t;
alter view t rename to u, add column valid int, add column invalid int, rename to w;
create table t (i varchar);
insert into t select rownum from db_root connect by level<=2;
create view t as select * from t;
create view t;
show tables;
desc t;
desc w;
drop t;
drop w;

create view t;
alter view t rename to u, add column valid int, add column invalid int, rename to w;
create table t (i varchar);
insert into t select rownum from db_root connect by level<=2;
create view u  as select * from t;
create view w;
show tables;
desc t;
desc u;
desc w;
drop t;
drop w;
drop u;


--test #3
create class t;
alter class t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create class t;
show tables;
desc t;
drop t;

create class t;
alter class t rename to u, add column valid int, add column invalid int , rename to w;
create class t;
show tables;
desc t;
desc w;
drop t;
drop w;

create class t;
alter class t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create class t;
create view w1 as select (select 2 from t ) as col from db_root limit 1;
select * from w1;
show tables;
desc  t;
desc w1;
drop w1;
drop t;

create table t(i char(10));
insert into t values(1);
alter table t rename to u, add column valid int, add column invalid int not null default null, rename to w;
create table t;
create view w1 as select * from t;
select * from w1;
show tables;
desc t;
desc w1;
drop t;
drop w1;
commit;
autocommit on;
