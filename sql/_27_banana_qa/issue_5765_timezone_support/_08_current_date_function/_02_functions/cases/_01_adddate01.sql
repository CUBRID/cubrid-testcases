--+ holdcas on;
set @x1=(select adddate(current_date,interval 1 day));
set @x2=(select current_date);
select if(day(@x1)-day(@x2) in (1,-27,-28,-29,-30),'ok','nok');
drop variable @x1,@x2;

set timezone '+00:00';
set @x1=(select adddate(current_date,interval 1 day));
set timezone '+00:00:01';
set @x2=(select current_date);
select if(day(@x1)-day(@x2) in (1,-27,-28,-29,-30),'ok','nok');
drop variable @x1,@x2;

set timezone '+12:00';
set @x1=(select adddate(current_date,interval 1 millisecond));
set timezone '-12:00:00';
set @x2=(select current_date);
select if(day(@x1)-day(@x2) in (1,-27,-28,-29,-30),'ok','nok');
drop variable @x1,@x2;


set timezone '+9:00:01';
set @x1=(select adddate(current_date,interval 1 second));
set timezone '+09:00';
set @x2=(select current_date);
select if(day(@x1)-day(@x2)=0,'ok','nok');
drop variable @x1,@x2;


drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,now();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(now(),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');  



drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,current_datetime();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(current_datetime(),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');                     


drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,current_datetime;
set timezone 'Asia/Seoul';
insert into t select 2,new_time(current_datetime,tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');

--new_time function not support timestamp
drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,current_timestamp();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(to_datetime(current_timestamp()),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');



drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,current_timestamp;
set timezone 'Asia/Seoul';
insert into t select 2,new_time(to_datetime(current_timestamp),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');


drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,localtimestamp();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(to_datetime(localtimestamp()),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');


drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,localtimestamp;
set timezone 'Asia/Seoul';
insert into t select 2,new_time(to_datetime(localtimestamp),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');


drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,localtime();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(to_datetime(localtime()),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');



drop table if exists t;
create table t(i int,j datetime);
set timezone 'America/New_York';
insert into t select 1,localtime;
set timezone 'Asia/Seoul';
insert into t select 2,new_time(to_datetime(localtime),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');




drop table if exists t;
create table t(i int,j time);
set timezone 'America/New_York';
insert into t select 1,current_time();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(current_time(),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');



drop table if exists t;
create table t(i int,j time);
set timezone 'America/New_York';
insert into t select 1,current_time;
set timezone 'Asia/Seoul';
insert into t select 2,new_time(current_time,tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');




drop table if exists t;
create table t(i int,j time);
set timezone 'America/New_York';
insert into t select 1,curtime();
set timezone 'Asia/Seoul';
insert into t select 2,new_time(curtime(),tz_offset('Asia/Seoul'),tz_offset('America/New_York'));

select if((select a.newj-b.newj from (select i,hour(j) as newj from t where i=2) a,(select i,hour(j) as newj from t where i=1) b where a.i=2 and b.i=1)=0,'ok','nok');
set timezone 'Asia/Seoul';
--+ holdcas off;
