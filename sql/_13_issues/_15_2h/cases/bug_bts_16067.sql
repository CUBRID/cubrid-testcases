set system parameters 'insert_execution_mode=3';

--partition by range
drop table if exists t;
create table t(col1 int primary key) partition by range(col1) (
partition p1 values less than(10),
partition p2 values less than(20)
);
insert into t(col1) values(19);
insert into t(col1) values(9);

select * from t;
insert into t(col1) values(19), (9) on duplicate key update col1 = 5;
select * from t;

--normal table
drop table if exists q;
create table q(col1 int primary key);
insert into q(col1) values(19), (9) on duplicate key update col1 = 5;

select * from q;
insert into q(col1) values(19), (9) on duplicate key update col1 = 5;
select * from q;

--partition by list
drop table if exists s;
create table s(col1 int primary key)partition by list(col1) (
PARTITION s1 VALUES IN (7,9,10),
PARTITION s2 VALUES IN (17,5,19)
);
insert into s(col1) values(19), (9) on duplicate key update col1 = 5;

select * from s;
insert into s(col1) values(19), (9) on duplicate key update col1 = 5;
select * from s;

--partition by hash
drop table if exists h;
create table h(col1 int primary key)partition by hash(col1) PARTITIONS 3;
insert into h(col1) values(19), (9) on duplicate key update col1 = 5;

select * from h;
insert into h(col1) values(19), (9) on duplicate key update col1 = 5;
select * from h;



set system parameters 'insert_execution_mode=25';

--partition by range
drop table if exists t;
create table t(col1 int primary key) partition by range(col1) (
partition p1 values less than(10),
partition p2 values less than(20)
);
insert into t(col1) values(19);
insert into t(col1) values(9);

select * from t;
insert into t(col1) values(19), (9) on duplicate key update col1 = 5;
select * from t;

--normal table
drop table if exists q;
create table q(col1 int primary key);
insert into q(col1) values(19), (9) on duplicate key update col1 = 5;

select * from q;
insert into q(col1) values(19), (9) on duplicate key update col1 = 5;
select * from q;

--partition by list
drop table if exists s;
create table s(col1 int primary key)partition by list(col1) (
PARTITION s1 VALUES IN (7,9,10),
PARTITION s2 VALUES IN (17,5,19)
);
insert into s(col1) values(19), (9) on duplicate key update col1 = 5;

select * from s;
insert into s(col1) values(19), (9) on duplicate key update col1 = 5;
select * from s;

--partition by hash
drop table if exists h;
create table h(col1 int primary key)partition by hash(col1) PARTITIONS 3;
insert into h(col1) values(19), (9) on duplicate key update col1 = 5;

select * from h;
insert into h(col1) values(19), (9) on duplicate key update col1 = 5;
select * from h;


drop table if exists t, q, s, h;
set system parameters 'insert_execution_mode=3';
