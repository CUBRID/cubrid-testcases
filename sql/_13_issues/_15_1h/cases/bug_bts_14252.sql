drop table if exists t;
create table t(i char(4));
insert into t values ('AB');
insert into t values ('10');
insert into t values ('FFFF');
select i ,conv(i,16,10) from t;
drop t;

drop table if exists t;
create table t(i char(4));
insert into t values ('7777');
insert into t values ('1000');
insert into t values ('0007');
select i ,conv(i,8,10) from t;
drop t;

drop table if exists t;
create table t(i char(4));
insert into t values ('1111');
insert into t values ('1000');
insert into t values ('0001');
select i ,conv(i,2,10) from t;
drop t;

drop table if exists t;
create table t(i char(8));
insert into t values ('AB');
insert into t values ('10');
insert into t values ('FFFF');
select i ,conv(i,16,10) from t;
drop t;

drop table if exists t;
create table t(i varchar(4));
insert into t values ('AB');
insert into t values ('10');
insert into t values ('FFFF');
select i ,conv(i,16,10) from t;
drop t;
drop table if exists t;
create table t(i int);
insert into t values (n'0xAB');
insert into t values (n'0x10');
insert into t values (n'0xFFFF');
select i ,conv(i,10,16) from t;
drop t;

drop table if exists t;
create table t(i int);
insert into t values (n'0xAB');
insert into t values (n'0x10');
insert into t values (n'0xFFFF');
select i ,conv(i,10,2) from t;
drop t;


drop table if exists t;
create table t(i double);
insert into t values (n'0xAB');
insert into t values (n'0x10');
insert into t values (n'0xFFFF');
select i ,conv(i,10,8) from t;
drop t;

drop table if exists t;
create table t(i double);
insert into t values (n'0xAB');
insert into t values (n'0x10');
insert into t values (n'0xFFFF');
select i ,conv(i,10,16) from t;
drop t;
