--+ holdcas on;
set timezone 'Asia/Seoul';
--Test timestamp and adddate
drop table if exists t1;
create table t1(
c_int int,
col1 timestamp,
c_varchar varchar(100)
);
insert into t1 values(1,timestamp'1995-01-01 00:10:01 AM', 'abcd');
insert into t1 values(2,timestamp'1995-01-01 00:10:02 AM','abcd');
set @a=1;
select adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;

drop table t1;

--Test datetime and adddate
drop table if exists t1;
create table t1(
c_int int,
col1 datetime,
c_varchar varchar(100)
);
insert into t1 values(1,datetime'1995-01-01 00:10:01.123 AM','abcd');
insert into t1 values(2,datetime'1995-01-01 00:10:02.123 AM','abcd');
set @a=1;
select adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;

drop table t1;

--Test timestampltz and subdate
drop table if exists t1;
create table t1(
c_int int,
col1 timestampltz,
c_varchar varchar(100)
);
insert into t1 values(1,timestampltz'1995-01-01 00:10:01 AM +9:00','abcd');
insert into t1 values(2,timestampltz'1995-01-01 00:10:02 AM +9:00','abcd');
set @a=1;
select subdate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select subdate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;

drop table t1;

--Test datetimeltz and subdate
drop table if exists t1;
create table t1(
c_int int,
col1 datetimeltz,
c_varchar varchar(100)
);
insert into t1 values(1,datetimeltz'1995-01-01 00:10:01 AM +9:00','abcd');
insert into t1 values(2,datetimeltz'1995-01-01 00:10:02 AM +9:00','abcd');
set @a=1;
select subdate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select subdate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;
drop variable @a;

drop table t1;


--+ holdcas off;
