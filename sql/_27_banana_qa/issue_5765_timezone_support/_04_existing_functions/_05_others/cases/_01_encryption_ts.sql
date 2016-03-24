--test encryption functions with timestamp(l)tz types

drop table if exists tz_test;

create table tz_test(id int primary key, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone, gid int);

insert into tz_test values(1, timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', 1);
insert into tz_test values(2, timestamptz'1981-01-01 5:00:00 Europe/Vienna', timestamptz'1981-01-01 5:00:00 Europe/Vienna', timestamptz'1981-01-01 5:00:00 Europe/Vienna', 3);
insert into tz_test values(3, timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', 1);
insert into tz_test values(4, timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', 2);
insert into tz_test values(5, timestamptz'2015-08-13 14:00:00 Antarctica/Mawson', timestamptz'2015-08-13 14:00:00 Antarctica/Mawson', timestamptz'2015-08-13 14:00:00 Antarctica/Mawson', 3);
insert into tz_test values(6, timestamptz'2023-03-23 18:59:59 Asia/Taipei', timestamptz'2023-03-23 18:59:59 Asia/Taipei', timestamptz'2023-03-23 18:59:59 Asia/Taipei', 2);
insert into tz_test values(7, timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', 1);
insert into tz_test values(8, timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', timestamptz'2038-01-01 17:29:34 Africa/Algiers', 3);

--test: encryption functions
select id, md5(ts), md5(tsltz), md5(tstz) from tz_test order by 1;
select id, sha1(ts), sha1(tsltz), sha1(tstz) from tz_test order by 1;
select id, sha2(ts, 256), sha2(tsltz, 256), sha2(tstz, 256) from tz_test order by 1;


drop table tz_test;


set timezone 'Asia/Seoul';
