drop table if exists t;
create table t(dtz datetime with time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000000;
select dtz, dtz + bi from t  order by 1;
select dtz, adddate(dtz,interval 1 year) from t;
select dtz, adddate(dtz,interval 1 hour) from t;
select datetimetz'11:59:59.000 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;



drop table if exists t;
create table t(dtz datetime with time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000000;
select dtz, dtz - bi from t  order by 1;
select dtz, subdate(dtz,interval 1 year) from t;
select dtz, subdate(dtz,interval -1 hour) from t;
select datetimetz'11:59:59.000 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;



set timezone 'America/Lima';
drop table if exists t;
create table t(dtz datetime with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000000;
select dtz, dtz + bi from t  order by 1;
select dtz, adddate(dtz,interval 1 year) from t;
select dtz, adddate(dtz,interval 1 hour) from t;
select datetimetz'11:59:59.000 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;

set timezone 'America/Lima';
drop table if exists t;
create table t(dtz datetime with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000000;
select dtz, dtz - bi from t  order by 1;
select dtz, subdate(dtz,interval 1 year) from t;
select dtz, subdate(dtz,interval -1 hour) from t;
select datetimetz'11:59:59.000 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;



set timezone 'America/Lima';
drop table if exists t;
create table t(dtz timestamp  with  time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000;
select dtz, dtz + bi from t  order by 1;
select dtz, adddate(dtz,interval 1 year) from t;
select dtz, adddate(dtz,interval 1 hour) from t;
select datetimetz'11:59:59 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;

set timezone 'America/Lima';
drop table if exists t;
create table t(dtz timestamp  with local  time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000;
select dtz, dtz + bi from t  order by 1;
select dtz, adddate(dtz,interval 1 year) from t;
select dtz, adddate(dtz,interval 1 hour) from t;
select datetimetz'11:59:59 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;




set timezone 'Asia/Seoul';
drop table if exists t;
create table t(dtz datetime with time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000000;
select dtz, dtz + bi from t  order by 1;
select dtz, adddate(dtz,interval 1 year) from t;
select dtz, adddate(dtz,interval 1 hour) from t;
select datetimetz'11:59:59 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;


set timezone 'Asia/Seoul';
drop table if exists t;
create table t(dtz datetime with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t add bi bigint;
update t set bi=31536000000;
select dtz, dtz + bi from t  order by 1;
select dtz, adddate(dtz,interval 1 year) from t;
select dtz, adddate(dtz,interval 1 hour) from t;
select datetimetz'11:59:59 PM 12/31/1994 America/Lima';
insert into t(dtz) values('1994-12-31 23:59:59 PM America/Lima');
select dtz from t order by 1;

drop table if exists t;
set timezone 'default';


