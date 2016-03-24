set timezone 'Asia/Seoul';

drop table if exists tz_test;

create table tz_test(id int primary key, ts timestamp, tsltz timestamp with local time zone, tstz timestamp with time zone, gid int);

insert into tz_test values(1, timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', timestamptz'1971-01-01 00:00:00 America/Denver', 1);

insert into tz_test values(3, timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', timestamptz'1993-12-31 23:00:00 America/Asuncion', 1);

insert into tz_test values(4, timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', timestamptz'2004-06-20 8:00:00 Australia/Lord_Howe', 2);

insert into tz_test values(6, timestamptz'2023-03-23 18:59:59 Asia/Taipei', timestamptz'2023-03-23 23:59:59 Asia/Taipei', timestamptz'2023-03-23 23:59:59 Asia/Taipei', 2);

insert into tz_test values(7, timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', timestamptz'2035-09-20 21:30:56 Africa/Casablanca', 1);

set time zone 'America/Los_Angeles';

--test: agrregate functions
select gid, cume_dist(timestamptz'2001-10-10 12:12:12') within group(order by tsltz) as cume from tz_test group by gid order by gid;

drop table tz_test;
create table tz_test(id int primary key, ts int, gid int);
 
insert into tz_test values(1, 10,  1);
insert into tz_test values(3, 70,  1);
insert into tz_test values(4, 100, 2);
insert into tz_test values(7, 50,  1);
insert into tz_test values(6, 50, 2);

select gid, cume_dist(50) within group(order by ts) as cume from tz_test group by gid order by gid;
drop table if exists tz_test;
set timezone 'Asia/Seoul';
