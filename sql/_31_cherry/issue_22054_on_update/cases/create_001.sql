drop if exists t1;
CREATE TABLE t1 ( 
ts TIMESTAMP DEFAULT '2018-7-25' ON UPDATE CURRENT_TIMESTAMP,
dt DATETIME DEFAULT '2018-7-25' ON UPDATE CURRENT_TIMESTAMP
);
desc t1;
show create table t1;
insert into t1 values(default,default);
select * from t1 order by 1,2;


drop if exists t1;
CREATE TABLE t1 (
  ts1 TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,     
  ts2 TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);
desc t1;
show create table t1;


drop if exists t1;
CREATE TABLE t1 (
  dt1 DATETIME ON UPDATE CURRENT_TIMESTAMP,         
  dt2 DATETIME NOT NULL ON UPDATE CURRENT_TIMESTAMP 
);
desc t1;
show create table t1;



drop if exists t1;
CREATE TABLE t1 (
  dt1 DATETIME ON UPDATE CURRENT_TIMESTAMP,         
  dt2 DATETIME NOT NULL ON UPDATE systimestamp
);
desc t1;
show create table t1;


drop if exists t1;
CREATE TABLE t1 (
a int default 0,
ts TIMESTAMP DEFAULT '2018-7-25' ON UPDATE CURRENT_TIMESTAMP,
dt DATETIME DEFAULT '2018-7-25' ON UPDATE sys_TIMESTAMP
);
desc t1;
show create table t1;
insert into t1(ts,dt) values(default,default);
select * from t1;
update t1 set a=1;
set @x=current_timestamp;
select if(@x-ts>=0 and @x-ts<=10,'ok','nok') from t1;
select if(@x-dt>=0 and @x-dt<=10,'ok','nok') from t1;
--select * from t1;

drop if exists t;
create table t(
username varchar(10) unique,
text varchar(100),
edit_time datetime on update current_datetime default current_datetime
)
desc t;
show create table t;


drop if exists t;
  create table t(
username varchar(10) unique,
text varchar(100),
edit_time timestamp on update current_datetime default current_timestamp
)
desc t;
show create table t;


drop if exists t;
  create table t(
username varchar(10) unique,
text varchar(100),
edit_time timestamp on update current_timestamp default current_datetime
);
desc t;
show create table t;


drop if exists t;
  create table t(
username varchar(10) unique,
text varchar(100),
edit_time timestamp on update now() default current_datetime
);
desc t;
show create table t;
