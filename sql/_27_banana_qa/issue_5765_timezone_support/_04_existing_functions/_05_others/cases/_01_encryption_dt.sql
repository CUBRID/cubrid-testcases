--test encryption functions with datetime(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts datetime, dtltz datetime with local time zone, dttz datetime with time zone, gid int);

insert into tz_test values(1, datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', datetimetz'1971-01-01 00:00:00.999 America/Denver', 1);
insert into tz_test values(2, datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', datetimetz'1981-01-01 5:00:00.999 Europe/Vienna', 3);
insert into tz_test values(3, datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', datetimetz'1993-12-31 23:00:00.999 America/Asuncion', 1);
insert into tz_test values(4, datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', datetimetz'2004-06-20 8:00:00.999 Australia/Lord_Howe', 2);
insert into tz_test values(5, datetimetz'2015-08-13 14:00:00.999 Antarctica/Mawson', datetimetz'2015-08-13 14:00:00.999 Antarctica/Mawson', datetimetz'2015-08-13 14:00:00.999 Antarctica/Mawson', 3);
insert into tz_test values(6, datetimetz'2023-03-23 18:59:59.999 Asia/Taipei', datetimetz'2023-03-23 18:59:59.999 Asia/Taipei', datetimetz'2023-03-23 18:59:59.999 Asia/Taipei', 2);
insert into tz_test values(7, datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', datetimetz'2035-09-20 21:30:56.999 Africa/Casablanca', 1);
insert into tz_test values(8, datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', datetimetz'2038-01-01 17:29:34.999 Africa/Algiers', 3);

--test: encryption functions
select id, md5(ts), md5(dtltz), md5(dttz) from tz_test order by 1;
select id, sha1(ts), sha1(dtltz), sha1(dttz) from tz_test order by 1;
select id, sha2(ts, 256), sha2(dtltz, 256), sha2(dttz, 256) from tz_test order by 1;


drop table tz_test;


set timezone 'Asia/Seoul';
