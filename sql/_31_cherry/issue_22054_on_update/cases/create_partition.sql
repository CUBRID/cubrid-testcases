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
) partition by range(a)
(
partition p1 values less than (10),
partition p2 values less than (20),
partition p3 values less than MAXVALUE
);
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50);
update t set a=a+1;
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;

update t set a=a+1 where a=2;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1 where a=3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1 where a=3;


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
) partition by hash(a) partitions 4;
show columns from t__p__p0;
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50),(2),(10),(15),(17),(9),(7);
update t set a=a+1;
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p0;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p0;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2;


select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;

update t set a=a+1 where a=22;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p0 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p0 where a=23;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1 where a=23;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2 where a=23;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3 where a=23;
show  columns from t;

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
) partition by list(a)
(
partition p1 values in (1,10),
partition p2 values in (2,11)
);
show columns from t__p__p1;
show columns from t__p__p2;
insert into t(a) values(1),(10);
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
update t set a=a+1;
select if(d is not null,'ok','nok') from t__p__p2;
select if(e is not null,'ok','nok') from t__p__p2;
select if(f is not null,'ok','nok') from t__p__p2;
select if(g is not null,'ok','nok') from t__p__p2;
select if(h is not null,'ok','nok') from t__p__p2;
select if(i is not null,'ok','nok') from t__p__p2;


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
alter table t partition by list(a)
(
partition p1 values in (1,10),
partition p2 values in (2,11)
);
show columns from t__p__p1;
show columns from t__p__p2;
insert into t(a) values(1),(10);
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
update t set a=a+1;
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2;

show columns from t;
alter table t drop partition p2;
select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t;





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
alter table t partition by range(a)
(
partition p1 values less than (10),
partition p2 values less than (20),
partition p3 values less than MAXVALUE
);
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50);
update t set a=a+1;
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);
select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;
update t set a=a+1 where a=22;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);
select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;

show  columns from t;
alter table t drop partition p2;



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
alter table t  partition by hash(a) partitions 4;
show columns from t__p__p0;
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50),(2),(10),(15),(17),(9),(7);
update t set a=a+1;
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p0;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p0;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2;


select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;

update t set a=a+1 where a=22;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p0 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p0 where a=23;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1 where a=23;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2 where a=23;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3 where a=23;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3 where a=23;

show  columns from t;


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
alter table t partition by range(a)
(
partition p1 values less than (10),
partition p2 values less than (20),
partition p3 values less than MAXVALUE
);
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50);
update t set a=a+1;
select if(b is not null,'ok','nok') from t__p__p1;
select if(d is not null,'ok','nok') from t__p__p1;
select if(e is not null,'ok','nok') from t__p__p1;
select if(f is not null,'ok','nok') from t__p__p1;
select if(g is not null,'ok','nok') from t__p__p1;
select if(h is not null,'ok','nok') from t__p__p1;
select if(i is not null,'ok','nok') from t__p__p1;


select if(b is not null,'ok','nok') from t__p__p3;
select if(d is not null,'ok','nok') from t__p__p3;
select if(e is not null,'ok','nok') from t__p__p3;
select if(f is not null,'ok','nok') from t__p__p3;
select if(g is not null,'ok','nok') from t__p__p3;
select if(h is not null,'ok','nok') from t__p__p3;
select if(i is not null,'ok','nok') from t__p__p3;


show  columns from t;

drop if exists t;
create table t(
a int,
c time on update sys_time
) partition by hash(a) partitions 4;
show columns from t__p__p0;
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
show  columns from t;


drop if exists t;
create table t(
a int,
c time on update systime
) partition by hash(a) partitions 4;
show columns from t__p__p0;
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50),(2),(10),(15),(17),(9),(7);
update t set a=a+1;
select if(c is not null,'ok','nok') from t__p__p0;
select if(c is not null,'ok','nok') from t__p__p1;
select if(c is not null,'ok','nok') from t__p__p2;
select if(c is not null,'ok','nok') from t__p__p3;
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
) partition by hash(a) partitions 4;
show columns from t__p__p0;
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50),(2),(10),(15),(17),(9),(7);
update t set a=a+1;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p0;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p0;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2;


select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;
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
)  partition by hash(a) partitions 4;
show columns from t__p__p0;
show columns from t__p__p1;
show columns from t__p__p2;
show columns from t__p__p3;
insert into t(a) values(1),(22),(50),(2),(10),(15),(17),(9),(7);
update t set a=a+1;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p0;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p0;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2;


select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p3;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p3;
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
)
alter table t partition by list(a)
(
partition p1 values in (1,10),
partition p2 values in (2,11)
);
show columns from t__p__p1;
show columns from t__p__p2;
insert into t(a) values(1),(10);
select * from t__p__p1 order by 1;
select * from t__p__p2 order by 1;
show  columns from t;
update t set a=a+1;
select sleep(2);
set @d=current_timestamp,@f=to_timestamp_tz(current_timestamp);
select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p1;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p1;

select if(to_timestamp(@d)-d>=0 and to_timestamp(@d)-d<10,'ok','nok') from t__p__p2;
select if(to_timestamp_tz(@f)-f>=0 and to_timestamp_tz(@f)-f<10,'ok','nok') from t__p__p2;
drop table t;

drop variable @d,@f;



