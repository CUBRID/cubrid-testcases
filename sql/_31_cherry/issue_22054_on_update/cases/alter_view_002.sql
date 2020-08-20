set system parameters 'create_table_reuseoid=no';
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
insert into t(a) values(1);
create or replace view v as select * from t;
show  columns from v;
update v set a=2;
select if(b is not null && c is not null && d is not null && e is not null,'ok','nok') from t;
select if(f is not null && g is not null && h is not null && i is not null,'ok','nok') from t;

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
insert into t1(a) values(1);
select sleep(2);
update t1 set a=2;
alter view v add query select * from t1;
select count(*) from v;
select count(distinct(d)) from v;
update v set a=3;
select count(distinct(d)) from v;
show  columns from v;



drop if exists t1,t2,t3;
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
insert into t1(a) values(1);
update t1 set a=2;
create table t2 under t1;
create table t3 as subclass of t1;
show columns in t2;
show columns in t3;



drop if exists t1,t2,t3;
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
insert into t1(a) values(1);
update t1 set a=2;
show columns from t1;
create table t2 under t1(
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
show columns from t1;
show columns from t2;
create table t3 as subclass of t1(
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
show columns from t1;
show columns from t2;
show columns from t3;

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
alter view v as select * from t1;
show  columns from v;


drop if exists t2;
create table t2(
a int,
b date on update sys_timestamp,
e datetime on update sys_timestamp,
g timestamptz on update sys_timestamp,
i datetimetz on update sys_timestamp
) replace as select * from t1;
show  columns from t2;
drop if exists t2;


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
show  columns from t1;
alter table t1 add column j timestamp default current_timestamp on update current_timestamp after i;
show  columns from t1;
alter table t1 add column k int default current_timestamp on update current_timestamp;
alter table t1 add column k int on update current_timestamp;
alter table t1 add column k varchar(100) default current_timestamp on update current_timestamp;
alter table t1 add column k varchar(100) on update current_timestamp;
alter table t1 add column k double default current_timestamp on update current_timestamp;
alter table t1 add column k double on update current_timestamp;
show  columns from t1;
alter table t1 alter column b set default current_date;
show  columns from t1;
alter table t1 change c c1 time default current_time on update current_timestamp; 
show  columns from t1;
alter table t1 modify c1 time default sys_time on update sys_timestamp;
show  columns from t1;
alter table t1 change b b1 date default current_datetime on update current_datetime;
alter table t1 change f f1 timestamp default current_datetime on update current_datetime;
show  columns from t1;

alter table t1 modify d timestamp;
alter table t1 modify e datetime;
alter table t1 modify f1 timestampltz;
alter table t1 modify g timestamptz;
alter table t1 modify h datetimeltz;
alter table t1 modify i datetimetz;
alter table t1 modify j int;
alter table t1 modify j timestamp;
show  columns from t1;

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
create or replace view v as select * from t1;
show  columns from v;
alter view v alter column b set default current_date;
show  columns from v;
alter view v change c c1 time default current_time on update current_timestamp;
alter view v modify c1 time default sys_time on update sys_timestamp;
alter view v change b b1 date default current_datetime on update current_datetime;
alter view v change f f1 timestamp default current_datetime on update current_datetime;
show  columns from v;

alter view v modify d timestamp;
alter view v modify e datetime;
alter view v f1 timestampltz;
alter view v modify g timestamptz;
alter view v modify h datetimeltz;
alter view v modify i datetimetz;
alter view v modify j int;
alter view v modify j timestamp;
show  columns from t1;


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
alter view v as select * from t1;
show  columns from v;

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
create or replace vclass v as select * from t1;
show  columns from v;
insert into t1(a) values(1);
update v set a=2;
select if(b is not null && c is not null && d is not null && e is not null,'ok','nok') from t1;
select if(f is not null && g is not null && h is not null && i is not null,'ok','nok') from t1;
select if(b is not null && c is not null && d is not null && e is not null,'ok','nok') from v;
select if(f is not null && g is not null && h is not null && i is not null,'ok','nok') from v;


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
insert into t1(a) values(1);
update v set a=2;

select if(b is not null && c is not null && d is not null && e is not null,'ok','nok') from t1;
select if(f is not null && g is not null && h is not null && i is not null,'ok','nok') from t1;
select if(b is not null && c is not null && d is not null && e is not null,'ok','nok') from v;
select if(f is not null && g is not null && h is not null && i is not null,'ok','nok') from v;
drop if exists v,t1,t,t2,t3;
set system parameters 'create_table_reuseoid=yes';
