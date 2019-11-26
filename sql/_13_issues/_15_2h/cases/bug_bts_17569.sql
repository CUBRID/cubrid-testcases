--+ holdcas on;
set timezone '+08:00';
drop table if exists t;
create table t(i int auto_increment,j varchar);
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR');

insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j varchar);
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR');

insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j String);
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR');

insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j datetime with time zone);
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR');
insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j char(100));
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR');
insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM') from t;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD ') from t where i!=2 order by 1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t order by 1;
select str_to_date('2015-3-8 01:59:59','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');
select str_to_date('2015-3-8 01:59:59 America/New_York','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');
select str_to_date('2015-11-1 01:59:59 America/New_York EST','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j varchar);
insert into t values(null,'2015-3-8 01:59:59');
insert into t values(null,'2015-3-8 01:59:59 America/New_York');
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM') from t;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD ') from t order by 1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t order by 1;


set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j varchar);
insert into t values(null,'2015-3-8 01:59:59');
insert into t values(null,'2015-3-8 01:59:59 +06:00');
insert into t values(null,'2015-3-8 01:59:59 America/New_York');
insert into t values(null,'2015-11-1 01:59:59 America/New_York EST');

select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM') from t where i<>2 order by 1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM') from t where i!=2 order by 1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2 order by 1;


select str_to_date('2015-3-8 01:59:59','%Y-%m-%d %H:%i:%s %TZH:%TZM');
select str_to_date('2015-3-8 01:59:59 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');
select str_to_date('2015-3-8 01:59:59 America/New_York','%Y-%m-%d %H:%i:%s %TZH:%TZM');
select str_to_date('2015-11-1 01:59:59 America/New_York EST','%Y-%m-%d %H:%i:%s %TZH:%TZM');


select str_to_date('2015-3-8 01:59:59','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');
select str_to_date('2015-3-8 01:59:59 +06:00','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');
select str_to_date('2015-3-8 01:59:59 America/New_York','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');
select str_to_date('2015-11-1 01:59:59 America/New_York EST','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');

set timezone 'Asia/Shanghai';
drop table if exists t;
create table t(i int auto_increment,j varchar);
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR');

insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');

set timezone 'Asia/Seoul';
drop table if exists t;
create table t(i int auto_increment,j timestamptz);
insert into t values(null,'2015-8-15 3:00:00 Asia/Seoul');
select str_to_date(j,'%Y-%m-%d %H:%i:%s') from t where i=1;
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM') from t where i=1;
select str_to_date('2015-8-15 3:00:00 Asia/Seoul','%Y-%m-%d %H:%i:%s %TZR %TZD %TZH:%TZM');

insert into t values(null,'2015-8-15 3:00:00 +06:00');
select str_to_date(j,'%Y-%m-%d %H:%i:%s %TZH:%TZM') from t where i=2;
select str_to_date('2015-8-15 3:00:00 +06:00','%Y-%m-%d %H:%i:%s %TZH:%TZM');

drop table if exists t;
create table t(j timestamptz);
insert into t values('2015-08-15 03:00:00 Asia/Seoul KST');
set @a=(select to_char(j,'YYYY-MM-DD HH24:MI:SS TZR') from t);
select str_to_date(@a,'%Y-%m-%d %H:%i:%s');
select str_to_date(@a,'%Y-%m-%d %H:%i:%s %TZR');
select str_to_date(@a,'%Y-%m-%d %H:%i:%s %TZR %TZD');
select str_to_date(to_char(j,'YYYY-MM-DD HH24:MI:SS TZR'),'%Y-%m-%d %H:%i:%s %TZR %TZD') from t;

drop table if exists t;
create table t(j datetimetz);
insert into t values('2015-08-15 03:00:00 Asia/Seoul KST');
set @a=(select to_char(j,'YYYY-MM-DD HH24:MI:SS TZR') from t);
select str_to_date(@a,'%Y-%m-%d %H:%i:%s');
select str_to_date(@a,'%Y-%m-%d %H:%i:%s %TZR');
select str_to_date(@a,'%Y-%m-%d %H:%i:%s %TZR %TZD');
select str_to_date(to_char(j,'YYYY-MM-DD HH24:MI:SS TZR'),'%Y-%m-%d %H:%i:%s %TZR %TZD') from t;
drop variable @a;
drop if exists t;
set timezone 'default';



--+ holdcas off;
