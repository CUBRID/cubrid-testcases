set timezone 'Asia/Seoul';
--Test case 1 - datetime 
drop table if exists t1;
create table t1(
c_int int,
col1 datetime,
c_varchar varchar(100)
);
insert into t1 values(1,datetime'1995-01-01 1:10:01 AM', 'abcd');
insert into t1 values(2,datetime'1995-01-01 1:10:02 AM','abcd');
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;
--Test case 2 - datetimetz
drop table if exists t1;
create table t1(
c_int int,
col1 datetimetz,
c_varchar varchar(100)
);
insert into t1 values(1,datetimetz'1995-01-01 1:10:01 AM +9:00', 'abcd');
insert into t1 values(2,datetimetz'1995-01-01 1:10:02 AM +9:00','abcd');
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;
--Test case 3 - datetimeltz
drop table if exists t1;
create table t1(
c_int int,
col1 datetimeltz,
c_varchar varchar(100)
);
insert into t1 values(1,datetimeltz'1995-01-01 1:10:01 AM +9:00', 'abcd');
insert into t1 values(2,datetimeltz'1995-01-01 1:10:02 AM +9:00','abcd');
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;


--Test case 4 - timestamp
drop table if exists t1;
create table t1(
c_int int,
col1 timestamp,
c_varchar varchar(100)
);
insert into t1 values(1,timestamp'1995-01-01 1:10:01 AM', 'abcd');
insert into t1 values(2,timestamp'1995-01-01 1:10:02 AM','abcd');
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;

--Test case 5 - timestamptz
drop table if exists t1;
create table t1(
c_int int,
col1 timestamptz,
c_varchar varchar(100)
);
insert into t1 values(1,timestamptz'1995-01-01 1:10:01 AM +9:00', 'abcd');
insert into t1 values(2,timestamptz'1995-01-01 1:10:02 AM +9:00','abcd');
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;

--Test case 6 - timestampltz
drop table if exists t1;
create table t1(
c_int int,
col1 timestampltz,
c_varchar varchar(100)
);
insert into t1 values(1,timestampltz'1995-01-01 1:10:01 AM +9:00', 'abcd');
insert into t1 values(2,timestampltz'1995-01-01 1:10:02 AM +9:00','abcd');
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1 order by c_int;
set @a=1;
select col1,adddate(col1,INTERVAL @a:=@a+1 MINUTE) from t1;

--clear table
drop variable @a;
drop table t1;
