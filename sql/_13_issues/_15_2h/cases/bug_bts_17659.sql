set timezone 'Asia/Seoul';
drop table if exists t;
create table t(dtltz datetime with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change dtltz dtltz varchar(60);
desc t;

set timezone '+09';
drop table if exists t;
create table t(dttz datetime with time zone);
insert into t values('1993-12-31 23:59:59');
alter table t change dttz dttz varchar(60);
desc t;


set timezone 'America/Lima';
drop table if exists t;
create table t(tsltz timestamp with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change tsltz tsltz varchar(40);
desc t;

drop table if exists t;
create table t(tstz timestamp with time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change tstz tstz varchar(30);
desc t;

drop table if exists t;
create table t(tsltz timestamp with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change tsltz tsltz varchar(64);
desc t;

drop table if exists t;
create table t(tstz timestamp with time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change tstz tstz varchar(64);
desc t;

drop table if exists t;
create table t(dtltz datetime with local time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change dtltz dtltz varchar(64);
desc t;

drop table if exists t;
create table t(dttz datetime with time zone);
insert into t values('1993-12-31 23:59:59 PM America/Lima -05');
alter table t change dttz dttz varchar(64);
desc t;


set timezone '+09';
drop table if exists t;
create table t(tstz timestamp with time zone);
insert into t values('1993-12-31 23:59:59');
alter table t change tstz tstz varchar(40);
desc t;
drop table if exists t;
set timezone 'default';
