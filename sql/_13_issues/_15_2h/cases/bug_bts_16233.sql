drop table if exists t;
create table t(t time default current_time, ts timestamp default current_timestamp);
desc t;

drop table if exists t;
create table t(t time default current_time(), ts timestamp default current_timestamp());
desc t;

drop table if exists t;
create table t(t time default curtime(), ts timestamp default localtime);
desc t;

drop table if exists t;
create table t(t time default sys_time, ts timestamp default localtimestamp);
desc t;


drop table if exists t;
create table t(t time default systime, ts timestamp default localtime());
desc t;
drop t;


