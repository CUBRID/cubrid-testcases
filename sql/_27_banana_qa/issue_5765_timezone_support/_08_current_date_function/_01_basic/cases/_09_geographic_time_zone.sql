drop table if exists t;
create table t(i string unique);
set timezone 'America/New_York';
--CUBRIDSUS-17374
--insert into t select timediff(current_timestamp,utc_timestamp());
insert into t select timediff(utc_timestamp(),current_timestamp);
set timezone 'Asia/Shanghai';
insert into t select timediff(current_timestamp,utc_timestamp());

drop table if exists t;
create table t(i string unique);
set timezone 'America/New_York';
--insert into t select timediff(current_timestamp(),utc_timestamp());
insert into t select timediff(utc_timestamp(),current_timestamp());
set timezone 'Asia/Shanghai';
insert into t select timediff(current_timestamp(),utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(localtimestamp,utc_timestamp());
insert into t select timediff(utc_timestamp(),localtimestamp);
set timezone 'Asia/Shanghai';
insert into t select timediff(localtimestamp,utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(localtimestamp(),utc_timestamp());
insert into t select timediff(utc_timestamp(),localtimestamp());
set timezone 'Asia/Shanghai';
insert into t select timediff(localtimestamp(),utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(localtime,utc_timestamp());
insert into t select timediff(utc_timestamp(),localtime);
set timezone 'Asia/Shanghai';
insert into t select timediff(localtime,utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(localtime(),utc_timestamp());
insert into t select timediff(utc_timestamp(),localtime());
set timezone 'Asia/Shanghai';
insert into t select timediff(localtime(),utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(now(),utc_timestamp());
insert into t select timediff(utc_timestamp(),now());
set timezone 'Asia/Shanghai';
insert into t select timediff(now(),utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(current_datetime,utc_timestamp());
insert into t select timediff(utc_timestamp(),current_datetime);
set timezone 'Asia/Shanghai';
insert into t select timediff(current_datetime,utc_timestamp());

drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(current_datetime(),utc_timestamp());
insert into t select timediff(utc_timestamp(),current_datetime());
set timezone 'Asia/Seoul';
insert into t select timediff(current_datetime(),utc_timestamp());


drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(utc_time(),current_time);
insert into t select(if(utc_time()-current_time>0,timediff(utc_time(),current_time), timediff(current_time,utc_time())));
set timezone 'Asia/Seoul';
--insert into t select timediff(current_time,utc_time());
insert into t select(if(utc_time()-current_time>0,timediff(utc_time(),current_time), timediff(current_time,utc_time())));

drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(utc_time(),current_time());
insert into t select(if(utc_time()-current_time()>0,timediff(utc_time(),current_time()), timediff(current_time(),utc_time())));
set timezone 'Asia/Seoul';
--insert into t select timediff(current_time(),utc_time());
insert into t select(if(utc_time()-current_time()>0,timediff(utc_time(),current_time()), timediff(current_time(),utc_time())));

drop table if exists t;
create table t(i string unique);
set timezone 'America/Argentina/Cordoba';
--insert into t select timediff(utc_time(),curtime());
insert into t select(if(utc_time()-curtime()>0,timediff(utc_time(),curtime()), timediff(curtime(),utc_time())));
set timezone 'Asia/Seoul';
--insert into t select timediff(curtime(),utc_time());
insert into t select(if(utc_time()-curtime()>0,timediff(utc_time(),curtime()), timediff(curtime(),utc_time())));
drop table if exists t;
set timezone 'Asia/Seoul';

