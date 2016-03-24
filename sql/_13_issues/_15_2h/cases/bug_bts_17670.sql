set timezone 'Asia/Seoul';

drop table if exists tz_test;
create table tz_test(id int primary key, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone, gid int);
 
insert into tz_test values(1, datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', 1);
insert into tz_test values(3, datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', 1);
insert into tz_test values(4, datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', 2);
insert into tz_test values(7, datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', 1);
 
select gid, percent_rank(datetimetz'2001-10-10 12:12:12.999') within group(order by dttz) as prank from tz_test group by gid order by gid desc;


drop table if exists tz_test;
create table tz_test(id int primary key, ts int, gid int);
 
insert into tz_test values(1, 10,  1);
insert into tz_test values(3, 70,  1);
insert into tz_test values(4, 100, 2);
insert into tz_test values(7, 50,  1);
insert into tz_test values(6, 50, 2);
 
select gid, percent_rank(50) within group(order by ts) as prank from tz_test group by gid order by gid desc;

drop table tz_test;
set timezone 'Asia/Seoul';
