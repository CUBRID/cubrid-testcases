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
insert into t(a) values(1),(2);
select * from t order by 1;
insert into t(a) values(3),(1) on duplicate key update a=4;
select * from t order by 1; 



drop table if exists t;
create table t(
a int unique,
d timestamp on update current_timestamp,
e datetime on update current_timestamp
);
insert into t(a) values(1),(2);
select * from t order by 1;
insert into t(a) values(3),(1) on duplicate key update a=4;
select a, if (current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from t where a=4;



drop if exists t;
create table t(
a int primary key,
b date on update current_timestamp,
c time on update current_timestamp,
d timestamp on update current_timestamp,
e datetime on update current_timestamp,
f timestampltz on update current_timestamp,
g timestamptz on update current_timestamp,
h datetimeltz on update current_timestamp,
i datetimetz on update current_timestamp
);
insert into t(a) values(1),(2);
select * from t order by 1;
insert into t(a) values(3),(1) on duplicate key update a=4;
select if (current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from t where a=4;
select if (to_timestamp_tz(current_timestamp)-g>=0 and to_timestamp_tz(current_timestamp)-g<10,'ok','nok') from t where a=4;


drop if exists t;
create table t(
a int primary key,
d timestamp on update current_timestamp,
e datetime on update current_timestamp
);
insert into t(a) values(1),(2);
select * from t order by 1;
insert into t(a) values(3),(1) on duplicate key update a=4;
select a, if (current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from t where a=4;

drop if exists t;
create table t(a int primary key,b timestamp default current_timestamp on update current_timestamp);
insert into t(a) values(1),(2);
set @a=current_timestamp;
--select * from t;
select sleep(5);
insert into t(a) values(3),(1) on duplicate key update a=4;
select if(b-to_timestamp(@a)>=5,'ok','nok') from t where a<>2;

drop table if exists t;
create table t(
a int primary key,
b date on update current_datetime,
c time on update current_datetime,
d timestamp on update current_datetime,
e datetime on update current_datetime,
f timestampltz on update current_datetime,
g timestamptz on update current_datetime,
h datetimeltz on update current_datetime,
i datetimetz on update current_datetime
);
drop table if exists t2;
create table t2(x int);
insert into t2 values(3),(1);
show  columns from t;
insert into t(a) values(1),(2);
select * from t order by 1;
insert into t(a) select x from t2 on duplicate key update a=a*4;
select if (current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from t where a=4;
drop table if exists t2;

drop table if exists t;
create table t(
a int primary key,
b timestamp on update current_timestamp
);
drop table if exists t2;
create table t2(x int);
insert into t2 values(3),(1);
show  columns from t;
insert into t(a) values(1),(2);
select * from t;
insert into t(a) 
select x from t2
on duplicate key update a=a*4;
select if(current_timestamp-b>=0 and current_timestamp-b<10,'ok','nok') from t where a=4;


drop table if exists t;
create table t(a int primary key,d timestamp on update current_timestamp);
show  columns from t;
insert into t(a) values(1),(2);
select * from t order by 1;
drop table if exists t2;
create table t2(b int);
insert into t2 values(3),(4);

drop table if exists t3;
create table t3(c int);
insert into t3 values(1);
insert into t(a) 
select b from t2
union
select c from t3
on duplicate key update a=a*10;
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from t where a=10;
drop table if exists t2,t3;

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
show  columns from t;
insert into t(a) values(1),(2);
insert into t(a) values(1) on duplicate key update a=3;
select * from t order by 1;

drop if exists t;
create table t(
a int primary key,
b date on update current_date,
d timestamp on update current_date,
e datetime on update current_date,
f timestampltz on update current_date,
g timestamptz on update current_date,
h datetimeltz on update current_date,
i datetimetz on update current_date
);
show  columns from t;
insert into t(a) values(1),(2);
insert into t(a) values(1),(2) on duplicate key update a=a*3;
select a,if(b is not null,'ok','nok') from t order by 1;
select a,if(d is not null,'ok','nok') from t order by 1;
select a,if(e is not null,'ok','nok') from t order by 1;
select a,if(f is not null,'ok','nok') from t order by 1;
select a,if(g is not null,'ok','nok') from t order by 1;
select a,if(h is not null,'ok','nok') from t order by 1;
select a,if(i is not null,'ok','nok') from t order by 1;
drop variable @a;
drop table if exists t;




