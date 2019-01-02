
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;


drop if exists t;
create table t(
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;



drop if exists t;
create table t(
a int,
b date on update current_date,
d timestamp on update current_date,
e datetime on update current_date,
f timestampltz on update current_date,
g timestamptz on update current_date,
h datetimeltz on update current_date,
i datetimetz on update current_date
);
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(b is not null,'ok','nok') from t;
select if(d is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(f is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;


drop if exists t;
create table t(
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;

drop if exists t;
create table t(
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;


drop if exists t;
create table t(
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;

drop if exists t;
create table t(
a int,
b date on update sysdate,
d timestamp on update sysdate,
e datetime on update sysdate,
f timestampltz on update sysdate,
g timestamptz on update sysdate,
h datetimeltz on update sysdate,
i datetimetz on update sysdate
);
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(d is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(f is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;


drop if exists t;
create table t(
a int,
c time on update sys_time
);
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(c is not null,'ok','nok') from t;
drop view v;


drop if exists t;
create table t(
a int,
c time on update systime
);
create or replace view v as select * from t;
show  columns from v;

drop if exists t;
create table t(
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;

drop if exists t;
create table t(
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
create or replace view v as select * from t;
show  columns from v;
desc v;
insert into v(a) values(1);
update v set a=2;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from v;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<10,'ok','nok') from v;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop view v;
drop table t;


