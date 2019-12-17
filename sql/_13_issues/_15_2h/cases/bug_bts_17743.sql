--+ holdcas on;
set @b='%Y-%m-%d %H:%i:%s'; 
select str_to_date('2015-1-1 13:00:00',@b);
select str_to_date(timestamp'2015-1-1 13:00:00',@b);
select str_to_date(datetime'2015-1-1 13:00:00',@b);
select str_to_date(timestamp'2015-1-1 13:00:00','%Y-%m-%d %H:%i:%s');

set timezone 'America/New_York';
set @b='%Y-%m-%d %H:%i:%s %TZR %TZD'; 
select str_to_date('2015-1-1 13:00:00 Asia/Seoul',@b);
select str_to_date(datetimetz'2015-1-1 13:00:00 Asia/Seoul',@b);
select str_to_date(timestamptz'2015-1-1 13:00:00 Asia/Seoul',@b);
select str_to_date(datetimeltz'2015-1-1 13:00:00 Asia/Seoul',@b);
select str_to_date(timestampltz'2015-1-1 13:00:00 Asia/Seoul',@b);

drop table if exists t;
create table t(j varchar);
insert into t values('2015-1-1 13:00:00 Asia/Seoul');
select str_to_date(j,@b) from t;

drop table if exists t;
create table t(j String);
insert into t values('2015-1-1 13:00:00 Asia/Seoul');
select str_to_date(j,@b) from t;

drop table if exists t;
create table t(j char(64));
insert into t values('2015-1-1 13:00:00 Asia/Seoul');
select str_to_date(j,@b) from t;

drop table if exists t;
create table t(j timestamptz);
insert into t values('2015-1-1 13:00:00 Asia/Seoul');
select str_to_date(j,@b) from t;


drop table if exists t;
create table t(j datetimetz);
insert into t values('2015-1-1 13:00:00 Asia/Seoul');
select str_to_date(j,@b) from t;


set timezone 'America/New_York';
set @b='%Y-%m-%d %H:%i:%s %TZH:%TZM'; 
select str_to_date('2015-1-1 13:00:00 +09:00',@b);
select str_to_date(datetimetz'2015-1-1 13:00:00 +09:00',@b);
select str_to_date(timestamptz'2015-1-1 13:00:00 +09:00',@b);
select str_to_date(datetimeltz'2015-1-1 13:00:00 +09:00',@b);
select str_to_date(timestampltz'2015-1-1 13:00:00 +09:00',@b);
drop variable @b;
drop if exists t;
set timezone 'default';


--+ holdcas off;
