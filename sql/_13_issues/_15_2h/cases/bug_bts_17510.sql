set timezone 'Asia/Seoul';

--datetimeltz type
drop table if exists t1;
create table t1(id int , dtltz1 datetimeltz, dtltz2 datetimeltz);
insert into t1 values(1,'12:02:01 AM 01/01/1990 Asia/Seoul','12:02:01 AM 01/01/1990 Asia/Seoul');
select ELT(1,dtltz1, dtltz2) from t1;              
select ELT(1,dtltz1, cast(dtltz2 as string)) from t1;    
drop table t1;

--timestampltz type
drop table if exists t1;
create table t1(id int , tsltz1 timestampltz, tsltz2 timestampltz);
insert into t1 values(1,'12:02:01 AM 01/01/1990 Asia/Seoul','12:02:01 AM 01/01/1990 Asia/Seoul');
select ELT(1,tsltz1, tsltz2) from t1;              
select ELT(1,tsltz1, cast(tsltz2 as string)) from t1;              
drop table t1;

--datetimetz type
drop table if exists t1;
create table t1(id int , dttz1 datetimetz, dttz2 datetimetz);
insert into t1 values(1,'12:02:01 AM 01/01/1990 Asia/Seoul','12:02:01 AM 01/01/1990 Asia/Seoul');
select ELT(1,dttz1, dttz2) from t1;              
select ELT(1,dttz1, cast(dttz2 as string)) from t1;              
drop table t1;

--timestamptz type
drop table if exists t1;
create table t1(id int , tstz1 timestamptz, tstz2 timestamptz);
insert into t1 values(1,'12:02:01 AM 01/01/1990 Asia/Seoul','12:02:01 AM 01/01/1990 Asia/Seoul');
select ELT(1,tstz1, tstz2) from t1;              
select ELT(1,tstz1, cast(tstz2 as string)) from t1;              
drop table t1;

