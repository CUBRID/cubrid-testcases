
drop if exists t;
create table t(
a int,
b date on update current_timestamp,
c time on update current_timestamp,
d timestamp on update current_timestamp,
e datetime on update current_timestamp,
f timestampltz on update current_timestamp,
g timestamptz on update current_timestamp,
h datetimeltz on update current_timestamp,
i datetimetz on update current_timestamp
);
insert into t values
(
1,
'2008-08-01',
'08:00:00',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);
set @x=(select b from t);
create or replace view v as select * from t;
show  columns from v;
update v set a=2;
set @y=(select b from t); 
select if (cast(@y as date)- cast(@x as date)>0,'ok','nok');
drop variable @x,@y;

drop if exists t1;
create table t1(
a int,
b date on update current_datetime,
c time on update current_datetime,
d timestamp on update current_datetime,
e datetime on update current_datetime,
f timestampltz on update current_datetime,
g timestamptz on update current_datetime,
h datetimeltz on update current_datetime,
i datetimetz on update current_datetime
);

insert into t1 values
(
1,
'2008-08-01',
'08:00:00',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);
set @x=(select c from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select c from t1);
select if (cast(@y as time)- cast(@x as time)!=0,'ok','nok');
drop variable @x,@y;


drop if exists t1;
create table t1(
a int,
b date on update current_date,
d timestamp on update current_date,
e datetime on update current_date,
f timestampltz on update current_date,
g timestamptz on update current_date,
h datetimeltz on update current_date,
i datetimetz on update current_date
);

insert into t1 values
(
1,
'2008-08-01',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);

set @x=(select d from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select d from t1);
select if (cast(@y as timestamp)- cast(@x as timestamp)!=0,'ok','nok');
drop variable @x,@y;



drop if exists t1;
create table t1(
a int,
b date on update sys_timestamp,
c time on update sys_timestamp,
d timestamp on update sys_timestamp,
e datetime on update sys_timestamp,
f timestampltz on update sys_timestamp,
g timestamptz on update sys_timestamp,
h datetimeltz on update sys_timestamp,
i datetimetz on update sys_timestamp
);

insert into t1 values
(
1,
'2008-08-01',
'08:00:00',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);

set @x=(select e from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select e from t1);
select if (cast(@y as datetime)- cast(@x as datetime)!=0,'ok','nok');
drop variable @x,@y;




drop if exists t1;
create table t1(
a int,
b date on update sys_datetime,
c time on update sys_datetime,
d timestamp on update sys_datetime,
e datetime on update sys_datetime,
f timestampltz on update sys_datetime,
g timestamptz on update sys_datetime,
h datetimeltz on update sys_datetime,
i datetimetz on update sys_datetime
);

insert into t1 values
(
1,
'2008-08-01',
'08:00:00',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);

set @x=(select f from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select f from t1);
select if (cast(@y as timestampltz )- cast(@x as timestampltz )!=0,'ok','nok');
drop variable @x,@y;


drop if exists t1;
create table t1(
a int,
b date on update sysdatetime,
c time on update sysdatetime,
d timestamp on update sysdatetime,
e datetime on update sysdatetime,
f timestampltz on update sysdatetime,
g timestamptz on update sysdatetime,
h datetimeltz on update sysdatetime,
i datetimetz on update sysdatetime
);

insert into t1 values
(
1,
'2008-08-01',
'08:00:00',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);

set @x=(select g from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select g from t1);
select if (cast(@y as timestamptz )- cast(@x as timestamptz )!=0,'ok','nok');
drop variable @x,@y;




drop if exists t1;
create table t1(
a int,
b date on update sysdate,
d timestamp on update sysdate,
e datetime on update sysdate,
f timestampltz on update sysdate,
g timestamptz on update sysdate,
h datetimeltz on update sysdate,
i datetimetz on update sysdate
);


insert into t1 values
(
1,
'2008-08-01',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);

set @x=(select h from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select h from t1);
select if (cast(@y as datetimeltz )- cast(@x as datetimeltz )!=0,'ok','nok');
drop variable @x,@y;


drop if exists t1;
create table t1(
a int,
c time on update sys_time
);
alter view v as select * from t1;
show  columns from v;


drop if exists t1;
create table t1(
a int,
c time on update systime
);
alter view v as select * from t1;
show  columns from v;

drop if exists t1;
create table t1(
a int,
b date on update localtimestamp,
c time on update localtimestamp,
d timestamp on update localtimestamp,
e datetime on update localtimestamp,
f timestampltz on update localtimestamp,
g timestamptz on update localtimestamp,
h datetimeltz on update localtimestamp,
i datetimetz on update localtimestamp
);
insert into t1 values
(
1,
'2008-08-01',
'08:00:00',
'2009-08-01 08:00:00',
'2009-08-01 08:00:00.120',
'2009-08-01 08:00:00 Asia/Seoul',
'2009-08-01 08:00:00 Asia/Shanghai',
'2009-08-01 08:00:00.120 Asia/Seoul',
'2009-08-01 08:00:00.120 Asia/Shanghai'
);

set @x=(select i from t1);
alter view v as select * from t1;
show  columns from v;
update v set a=2;
set @y=(select i from t1);
select if (cast(@y as datetimetz )- cast(@x as datetimetz )!=0,'ok','nok');
drop variable @x,@y;



drop if exists t1;
create table t1(
a int,
b date on update localtime,
d timestamp on update localtime,
c time on update localtime,
e datetime on update localtime,
f timestampltz on update localtime,
g timestamptz on update localtime,
h datetimeltz on update localtime,
i datetimetz on update localtime
);
alter view v as select * from t1;
show  columns from v;

drop view if exists v;
drop if exists t1,t;
