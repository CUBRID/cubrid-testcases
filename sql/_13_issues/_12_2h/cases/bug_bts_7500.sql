---This case will be using in HA testing Env. ha_repl_fm can work
--test
drop table  if exists t1;
create table t1 (a int primary key,b short auto_increment(1,1));
ALTER TABLE t1 CHANGE b b INTEGER auto_increment;
insert into t1 select rownum,null from db_class limit 1;

--check:
select * from t1;
desc t1

--test
drop table t1;
create table t1 (a int primary key,b int auto_increment(1,1));
ALTER TABLE t1 CHANGE b b BIGINT auto_increment;
insert into t1 select rownum,null from db_class limit 1;


--check:
select * from t1;
desc t1

--test
drop table t1;
create table t1 (a int primary key,b int auto_increment(1,99));
ALTER TABLE t1 CHANGE b b BIGINT auto_increment;
insert into t1 select rownum,null from db_class limit 1;

--check:
select * from t1;
desc t1

--test
drop table t1;

