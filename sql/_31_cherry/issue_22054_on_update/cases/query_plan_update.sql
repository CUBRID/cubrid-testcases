drop table if exists t;
create table t(
a int,
b timestamp on update current_timestamp
);
insert into t(a) values(1);
set trace on;
update t set a=2;
show trace;
select if(b is not null,'ok','nok') from t;

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
insert into t(a) values(1);
set trace on;
update t set a=2;
show trace;
select if(b is not null && c is not null && d is not null && e is not null && f is not null && g is not null && h is not null && i is not null,'ok','nok') from t;
drop table if exists t;


