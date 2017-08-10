--TEST: USER/CURRENT_USER should not be used as the default value of a date/time type column


--error should be returned in the following cases

--TEST: date column
create table t(a date default USER);
drop table if exists t;
create table t(a date default USER());
drop table if exists t;
create table t(a date default CURRENT_USER);
drop table if exists t;

--TEST: time column
create table t(a time default USER);
drop table if exists t;
create table t(a time default USER());
drop table if exists t;
create table t(a time default CURRENT_USER);
drop table if exists t;

--TEST: timestamp column
create table t(a timestamp default USER);
drop table if exists t;
create table t(a timestamp default USER());
drop table if exists t;
create table t(a timestamp default CURRENT_USER);
drop table if exists t;

--TEST: datetime column
create table t(a datetime default USER);
drop table if exists t;
create table t(a datetime default USER());
drop table if exists t;
create table t(a datetime default CURRENT_USER);
drop table if exists t;
