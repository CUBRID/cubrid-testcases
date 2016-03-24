--test aggregate functions with timestamp(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone, gid int);

insert into tz_test values(1, timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', 1);
insert into tz_test values(2, timestamptz'1981-01-01 5:00:00 Europe/Vienna', timestamptz'1981-01-01 5:00:00 Europe/Vienna', timestamptz'1981-01-01 5:00:00 Europe/Vienna', 3);
insert into tz_test values(3, timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', 1);
insert into tz_test values(4, timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', 2);
insert into tz_test values(5, timestamptz'2015-08-13 14:00:00 Antarctica/McMurdo', timestamptz'2015-08-13 14:00:00 Antarctica/McMurdo', timestamptz'2015-08-13 14:00:00 Antarctica/McMurdo', 3);
insert into tz_test values(6, timestamptz'2023-03-23 18:59:59 Asia/Taipei', timestamptz'2023-03-23 23:59:59 Asia/Taipei', timestamptz'2023-03-23 23:59:59 Asia/Taipei', 2);
insert into tz_test values(7, timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', 1);
insert into tz_test values(8, timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', 3);

set time zone 'America/Los_Angeles';
--test: agrregate functions
select count(ts), count(tsltz), count(tstz) from tz_test;
select gid, count(ts), count(tsltz), count(tstz) from tz_test group by gid;

select cume_dist(timestamptz'2001-10-10 12:12:12') within group(order by ts) as cume from tz_test; 
--BUG: CUBRIDSUS-16422
select gid, cume_dist(timestamptz'2001-10-10 12:12:12') within group(order by tsltz) as cume from tz_test group by gid order by gid; 
select cume_dist(timestamptz'2001-10-10 12:12:12') within group(order by tstz) as cume from tz_test; 
select cume_dist(timestamptz'2001-10-10 12:12:12', timestamptz'1988-10-10 12:12:12', timestamptz'2022-10-10 12:12:12') within group(order by ts, tsltz, tstz) as cume from tz_test; 

select group_concat(ts order by tsltz) from tz_test;
select group_concat(ts order by ts) from tz_test;
select gid, group_concat(tsltz order by tsltz desc separator ':') from tz_test group by gid order by 1;
select group_concat(tstz order by tstz separator ', ') from tz_test;

select max(ts), max(tsltz), max(tstz) from tz_test;

--BUG: CUBRIDSUS-16428
select median(ts), median(tsltz), median(tstz) from tz_test;
select gid, median(ts), median(tsltz), median(tstz) from tz_test group by gid order by 1;

select min(ts), min(tsltz), min(tstz) from tz_test;

select percent_rank(timestamptz'2001-10-10 12:12:12') within group(order by ts) as prank from tz_test; 
select percent_rank(timestamptz'2001-10-10 12:12:12') within group(order by tsltz) as prank from tz_test; 
--BUG: CUBRIDSUS-16422
select gid, percent_rank(timestamptz'2001-10-10 12:12:12') within group(order by tstz) as prank from tz_test group by gid order by gid desc; 
select percent_rank(timestamptz'2001-10-10 12:12:12', timestamptz'1988-10-10 12:12:12', timestamptz'2022-10-10 12:12:12') within group(order by ts, tsltz, tstz) as prank from tz_test;


drop table tz_test;


set timezone 'Asia/Seoul';
