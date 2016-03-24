drop table if exists t1;
create table t1(a1 timestamp not null default CURRENT_TIMESTAMP, b int);
--test: below statement will fail in CUBRID, succeed in Mysql
insert into t1(b) values (1);
desc t1;

drop table if exists t2;
create table t2(a1 datetime unique default sys_datetime, b int);
--test: below statement will fail in CUBRID, succeed in Mysql
insert into t2(b) values (1);
select b  from t2;
--add reduntant code to delay time
drop if exists wo11;
create table wo11(i int);
insert into wo11 select rownum from db_root connect by level<=10000;
drop table wo11;
insert into t2 (b)select b from t2;
desc t2;
drop table if exists x2;
create table x2(a1 int unique default 1, b int);
--test: below statement will fail in CUBRID, succeed in Mysql
insert into x2(b) values (1);
--test:below should fail
insert into x2 (b)select b from x2;
drop x2;

drop table if exists t3;
create table t3(a1 timestamp not null default CURRENT_TIMESTAMP,a2 timestamp not null default CURRENT_TIMESTAMP,a3 timestamp not null default CURRENT_TIMESTAMP,a4 timestamp not null default CURRENT_TIMESTAMP,a5 timestamp not null default CURRENT_TIMESTAMP,a6 timestamp not null default CURRENT_TIMESTAMP,a7 timestamp not null default CURRENT_TIMESTAMP,a8 time not null default CURRENT_TIMESTAMP,a9 timestamp unique default CURRENT_TIMESTAMP,a10  timestamp unique not null default CURRENT_TIMESTAMP, b int);
--test: below statement will fail in CUBRID, succeed in Mysql
insert into t3(b) values (1);
desc t3;

drop table if exists t4;
create table t3(a1 timestamp not null default CURRENT_TIMESTAMP,a2 timestamp not null default CURRENT_TIMESTAMP,a3 timestamp not null default CURRENT_TIMESTAMP,a4 timestamp not null default CURRENT_TIMESTAMP,a5 timestamp not null default CURRENT_TIMESTAMP,a6 timestamp not null default CURRENT_TIMESTAMP,a7 timestamp not null default CURRENT_TIMESTAMP,a8 time not null default CURRENT_TIMESTAMP,a9 timestamp unique default CURRENT_TIMESTAMP,a10  timestamp unique not null default CURRENT_TIMESTAMP, b int);
--test: below statement will fail in CUBRID, succeed in Mysql
insert into t4(b) values (1);
desc t4;


drop table if exists t5;
create table t5(a1 timestamp not null default CURRENT_TIMESTAMP,a2 timestamp not null default CURRENT_TIMESTAMP,a3 timestamp not null default CURRENT_TIMESTAMP,a4 timestamp not null default CURRENT_TIMESTAMP,a5 timestamp not null default CURRENT_TIMESTAMP,a6 timestamp not null default CURRENT_TIMESTAMP,a7 timestamp not null default CURRENT_TIMESTAMP,a8 time not null default CURRENT_TIMESTAMP,a9 timestamp unique default CURRENT_TIMESTAMP,a10  timestamp unique not null default CURRENT_TIMESTAMP, b int);
--test: below statement will fail in CUBRID, succeed in Mysql
insert into t5(b) values (1);
desc t5;

ALTER TABLE t5 ADD COLUMN a11 timestamp unique default sys_datetime,a12  timestamp unique not null default sys_timestamp;
desc t5;

drop table if exists t1,t2,t3,t4,t5;

drop table if exists t1;
create table t1(a1 timestamp not null default CURRENT_TIMESTAMP, b int);
insert into t1(b) values (1);
insert into t1 default;
insert into t1 values (default, 2);
select b, if (year(CURRENT_TIMESTAMP) = year(a1), 'ok', 'nok') from t1 order by 1;
drop t1;

