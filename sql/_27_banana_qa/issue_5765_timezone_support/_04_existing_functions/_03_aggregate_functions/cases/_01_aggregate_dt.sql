--test aggregate functions with datetime(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone, gid int);

insert into tz_test values(1, datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', 1);
insert into tz_test values(2, datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', 3);
insert into tz_test values(3, datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', 1);
insert into tz_test values(4, datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', 2);
insert into tz_test values(5, datetimetz'2015-08-13 14:00:00.999 Antarctica/McMurdo', datetimetz'2015-08-13 14:00:00.999 Antarctica/McMurdo', datetimetz'2015-08-13 14:00:00.999 Antarctica/McMurdo', 3);
insert into tz_test values(6, datetimetz'2023-03-23 18:59:59.999 Asia/Taipei', datetimetz'2023-03-23 23:59:59.999 Asia/Taipei', datetimetz'2023-03-23 23:59:59.999 Asia/Taipei', 2);
insert into tz_test values(7, datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', 1);
insert into tz_test values(8, datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', 3);

set time zone 'America/Los_Angeles';
--test: agrregate functions
select count(ts), count(dtltz), count(dttz) from tz_test;
select gid, count(ts), count(dtltz), count(dttz) from tz_test group by gid;

select cume_dist(datetimetz'2001-10-10 12:12:12.999') within group(order by ts) as cume from tz_test; 
--BUG: CUBRIDSUS-16422
select gid, cume_dist(datetimetz'2001-10-10 12:12:12.999') within group(order by dtltz) as cume from tz_test group by gid order by gid; 
select cume_dist(datetimetz'2001-10-10 12:12:12.999') within group(order by dttz) as cume from tz_test; 
select cume_dist(datetimetz'2001-10-10 12:12:12.999', datetimetz'1988-10-10 12:12:12.999', datetimetz'2022-10-10 12:12:12.999') within group(order by ts, dtltz, dttz) as cume from tz_test; 

select group_concat(ts order by dtltz) from tz_test;
select gid, group_concat(dtltz order by dttz desc separator ':') from tz_test group by gid order by 1;
select group_concat(dttz order by dtltz separator ', ') from tz_test;

select max(ts), max(dtltz), max(dttz) from tz_test;

select median(ts), median(dtltz), max(dttz) from tz_test;
select gid, median(ts), median(dtltz), median(dttz) from tz_test group by gid order by 1;

select min(ts), min(dtltz), min(dttz) from tz_test;

select percent_rank(datetimetz'2001-10-10 12:12:12.999') within group(order by ts) as prank from tz_test; 
select percent_rank(datetimetz'2001-10-10 12:12:12.999') within group(order by dtltz) as prank from tz_test; 
--BUG: CUBRIDSUS-16422
select gid, percent_rank(datetimetz'2001-10-10 12:12:12.999') within group(order by dttz) as prank from tz_test group by gid order by gid desc; 
select percent_rank(datetimetz'2001-10-10 12:12:12.999', datetimetz'1988-10-10 12:12:12.999', datetimetz'2022-10-10 12:12:12.999') within group(order by ts, dtltz, dttz) as prank from tz_test;


drop table tz_test;


set timezone 'Asia/Seoul';
