
create table t1 (id1 int primary key);
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int default 15 primary key );
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int not null);
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int default 15 not null );
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int unique);
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int default 15 unique);
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int);
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;


create table t1 (id1 int default 15);
insert into t1 values(1);
insert into t1 values(2);
select default(id1) from t1;
drop table t1;