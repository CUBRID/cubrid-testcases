drop if exists t;
create table t(
a int,
b short default 0 on update current_date
);

drop if exists t;
create table t(
a int,
b smallint default 0 on update current_datetime
);


drop if exists t;
create table t(
a int,
b int default 0 on update current_datetime
);


drop if exists t;
create table t(
a int,
b char(100) default 0 on update current_datetime
);


drop if exists t;
create table t(
a int,
b float default 0 on update current_timestamp
);

drop if exists t;
create table t(
a int,
b double default 0 on update current_timestamp
);


drop if exists t;
create table t(
a int,
b bigint default 0 on update current_timestamp
);



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
show  columns from t;

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
show  columns from t;

drop if exists t;
create table t(
a int,
b date on update current_date,
--c time on update current_date,
d timestamp on update current_date,
e datetime on update current_date,
f timestampltz on update current_date,
g timestamptz on update current_date,
h datetimeltz on update current_date,
i datetimetz on update current_date
);
show  columns from t;

drop if exists t;
create table t(
a int,
c time on update current_date
);

drop if exists t;
create table t(
a int,
b date on update current_time,
c time on update current_time,
d timestamp on update current_time,
e datetime on update current_time,
f timestampltz on update current_time,
g timestamptz on update current_time,
h datetimeltz on update current_time,
i datetimetz on update current_time
);
show  columns from t;

drop if exists t;
create table t(
a int,
c time on update current_time
);
show  columns from t;

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
show  columns from t;


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
show  columns from t;


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
show  columns from t;


drop if exists t;
create table t(
a int,
b date on update sysdate,
--c time on update sysdate,
d timestamp on update sysdate,
e datetime on update sysdate,
f timestampltz on update sysdate,
g timestamptz on update sysdate,
h datetimeltz on update sysdate,
i datetimetz on update sysdate
);
show  columns from t;

drop if exists t;
create table t(
a int,
c time on update sysdate
);


drop if exists t;
create table t(
a int,
--b date on update sys_time,
--d timestamp on update sys_time,
--e datetime on update sys_time,
--f timestampltz on update sys_time,
--g timestamptz on update sys_time,
--h datetimeltz on update sys_time,
--i datetimetz on update sys_time
c time on update sys_time
);
show  columns from t;

drop if exists t;
create table t(
a int,
b date on update sys_time
);

drop if exists t;
create table t(
a int,
b timestamp on update sys_time
);

drop if exists t;
create table t(
a int,
b datetime on update sys_time
);

drop if exists t;
create table t(
a int,
b timestampltz on update sys_time
);

drop if exists t;
create table t(
a int,
b timestamptz on update sys_time
);

drop if exists t;
create table t(
a int,
b datetimeltz on update sys_time
);

drop if exists t;
create table t(
a int,
b datetimetz on update sys_time
);

drop if exists t;
create table t(
a int,
--b date on update systime,
--d timestamp on update systime,
--e datetime on update systime,
--f timestampltz on update systime,
--g timestamptz on update systime,
--h datetimeltz on update systime,
--i datetimetz on update systime
c time on update systime
);
show  columns from t;

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
show  columns from t;


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
show  columns from t;


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
show  columns from t;

drop if exists t;
create table t(
a int,
c int on update int 
);
show  columns from t;

drop if exists t;
create table t(
a int,
c int on update cast(localtime as date) 
);
show  columns from t;
