autocommit off;
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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger before rollback execute update t set a=3;
commit;
update t set d=default;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(f is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
rollback;
commit;
select * from t;
drop trigger insert_trigger;
commit;

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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger after rollback execute update t set a=3;
commit;
rollback;
commit;
select if(current_timestamp-d>=0 and current_timestamp-d<1000,'ok','nok') from t;
select if(to_timestamp_tz(current_timestamp)-f>=0 and to_timestamp_tz(current_timestamp)-f<1000,'ok','nok') from t;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t;
drop trigger insert_trigger;
commit;

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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger before update on t execute insert into t(a) values(2);
update t set total=total+1;
select if(b is not null,'ok','nok') from t where a=1;
select if(c is not null,'ok','nok') from t where a=1;
select if(d is not null,'ok','nok') from t where a=1;
select if(e is not null,'ok','nok') from t where a=1;
select if(g is not null,'ok','nok') from t where a=1;
select if(h is not null,'ok','nok') from t where a=1;
select if(i is not null,'ok','nok') from t where a=1;
drop trigger insert_trigger;
commit;




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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger after update on t  execute insert into t(a) values(2);
update t set total=total+1;
select if(b is not null,'ok','nok') from t where a=1;
select if(c is not null,'ok','nok') from t where a=1;
select if(d is not null,'ok','nok') from t where a=1;
select if(e is not null,'ok','nok') from t where a=1;
select if(f is not null,'ok','nok') from t where a=1;
select if(g is not null,'ok','nok') from t where a=1;
select if(h is not null,'ok','nok') from t where a=1;
select if(i is not null,'ok','nok') from t where a=1;
drop trigger insert_trigger;
commit;


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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger status active after insert on t execute update t set a=a+1;
insert into t(a) values(2);
select if(current_timestamp-d>=0 and current_timestamp-d<10,'ok','nok') from t;
select if(b is not null,'ok','nok') from t;
select if(c is not null,'ok','nok') from t;
select if(e is not null,'ok','nok') from t;
select if(f is not null,'ok','nok') from t;
select if(g is not null,'ok','nok') from t ;
select if(h is not null,'ok','nok') from t;
select if(i is not null,'ok','nok') from t ;
drop trigger insert_trigger;
commit;



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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger status inactive after insert on t execute update t set a=a+1;
insert into t(a) values(2);
select * from t order by 1;
drop trigger insert_trigger;
commit;


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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1),(2),(3),(4);
create trigger update_trigger before update on t if new.a<10 execute reject;
update t set a=5 where a=1;
select * from t order by 1;
update t set a=15 where a=1;
select if(b is not null,'ok','nok') from t where a=15;
select if(c is not null,'ok','nok') from t where a=15;
select if(d is not null,'ok','nok') from t where a=15;
select if(e is not null,'ok','nok') from t where a=15;
select if(f is not null,'ok','nok') from t where a=15;
select if(g is not null,'ok','nok') from t where a=15;
select if(h is not null,'ok','nok') from t where a=15;
select if(i is not null,'ok','nok') from t  where a=15;
drop trigger update_trigger;

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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger before insert on t if new.a=(select a from t) execute update t set a=a+1;
insert into t(a) values(2);
select * from t order by 1;
drop trigger insert_trigger;


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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger before insert on t if new.a in (select a from t) execute update t set a=a+1;
insert into t(a) values(2);
select * from t order by 1;
insert into t(a) values(1);
select * from t order by 1;
drop trigger insert_trigger;
truncate  t;
alter table t change a a int;
insert into t(a) values(1);
create trigger insert_trigger before insert on t if new.a in (select a from t) execute update t set a=a+1;
insert into t(a) values(6);
select * from t order by 1;
insert into t(a) values(1);
select if(b is not null,'ok','nok') from t where a!=1;
select if(c is not null,'ok','nok') from t where a!=1;
select if(d is not null,'ok','nok') from t where a!=1;
select if(e is not null,'ok','nok') from t where a!=1;
select if(f is not null,'ok','nok') from t where a!=1;
select if(g is not null,'ok','nok') from t where a!=1;
select if(h is not null,'ok','nok') from t where a!=1;
select if(i is not null,'ok','nok') from t where a!=1;
drop trigger insert_trigger;


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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1);
create trigger insert_trigger before insert on t if new.a in (select a from t) execute update t set a=a+1;
insert into t(a) values(7);
select * from t order by 1;
insert into t(a) values(1);
select if(b is not null,'ok','nok') from t where a!=1;
select if(c is not null,'ok','nok') from t where a!=1;
select if(d is not null,'ok','nok') from t where a!=1;
select if(e is not null,'ok','nok') from t where a!=1;
select if(f is not null,'ok','nok') from t where a!=1;
select if(g is not null,'ok','nok') from t where a!=1;
select if(h is not null,'ok','nok') from t where a!=1;
select if(i is not null,'ok','nok') from t where a!=1;
drop trigger insert_trigger;


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
i datetimetz on update current_timestamp,
total int default 0
);
insert into t(a) values(1),(2),(3);
create trigger test after delete on t execute update t set a=a+1 where a=3 ;
delete from t where a=1;
select if(b is not null,'ok','nok') from t where a=4;
select if(c is not null,'ok','nok') from t where a=4;
select if(d is not null,'ok','nok') from t where a=4;
select if(e is not null,'ok','nok') from t where a=4;
select if(f is not null,'ok','nok') from t where a=4;
select if(g is not null,'ok','nok') from t where a=4;
select if(h is not null,'ok','nok') from t where a=4;
select if(i is not null,'ok','nok') from t where a=4;

drop trigger test;
truncate t;
insert into t(a) values(1),(2),(3);
create trigger test after delete on t execute update t set a=a+1;
delete from t where a=3;
select * from t order by 1;
drop trigger test;
drop if exists t,a_tbl;
