--insert into DATETIME(L)TZ columns, test with system params

set timezone '+00:00';

drop table if exists tz_test;

create table tz_test(
	id int,
	ts datetime,
	tsltz datetime with local time zone,
	tstz datetime with time zone
);


--test: timezone +00:00
insert into tz_test values (1, datetime'2003-03-30 02:30:00.268', datetimeltz'2003-03-30 02:30:00.268', datetimetz'2003-03-30 02:30:00.268 +03:00');
select * from tz_test order by 1;

--test: change session timezone and select
set timezone '+03:00';
select * from tz_test order by 1;

--test: change timezone and insert
set timezone '-10:30';
insert into tz_test values 
	(2, datetime'2013-03-30 02:30:00.268', datetimeltz'2013-03-30 02:30:00.268 AM', datetimetz'2013-03-30 02:30:00.268 AM'),
        (3, datetimetz'2003-03-30 02:30:00.268 +14:00', datetimeltz'2003-03-30 02:30:00.268 +14:00', datetimetz'2003-03-30 02:30:00.268 AM +14:00');
select * from tz_test order by 1;

--test: change again and select
set timezone '-00:00';
select * from tz_test order by 1;

--test: insert with timezone, DST in 'America/New_York'
insert into tz_test values(4, datetimetz'1975-2-23 3:30:00.268 -05:00', datetimeltz'1975-2-23 3:30:00.268 -05:00', datetimetz'1975-2-23 3:30:00.268 -05:00');
--test: insert not existing time in 'America/New_York'
insert into tz_test values(5, datetimetz'1975-2-23 2:30:00.268 -05:00', datetimeltz'1975-2-23 2:30:00.268 -05:00', datetimetz'1975-2-23 2:30:00.268 -05:00');
--test: other values
insert into tz_test values(6, datetimetz'1975-2-23 1:30:00.268 -05:00', datetimeltz'1975-2-23 1:30:00.268 -05:00', datetimetz'1975-2-23 1:30:00.268 -05:00');
insert into tz_test values(7, datetimetz'1975-2-22 21:30:00.268 -05:00', datetimeltz'1975-2-22 21:30:00.268 -05:00', datetimetz'1975-2-21 21:30:00.268 -05:00');

--test: change to geographic zone name and select, including 
set timezone 'America/New_York';
--BUG: CUBRIDSUS-16318, resolved
select * from tz_test order by 1;
--test: [er] invalid value
set timezone 'America/New_York EST';

--test: [er] insert under 'America/New_York' timezone, not existing time
insert into tz_test values(8, datetime'1975-2-23 2:30:00.268', datetimeltz'1975-2-23 2:30:00.268', datetimetz'1975-2-23 2:30:00.268');
select * from tz_test order by 1;

--test: change to another geographic timezone and select
set timezone 'Asia/Hong_Kong';
select * from tz_test order by 1;

--test: insert with another timezone under 'Asia/Hong_Kong'
insert into tz_test values(9, datetimeltz'1973-12-30 7:30:00.268 Pacific/Auckland', datetimetz'1973-12-30 7:30:00.268 Pacific/Auckland', datetimeltz'1973-12-30 7:30:00.268 Pacific/Auckland');
select * from tz_test order by 1;



drop table tz_test;

set timezone 'Asia/Seoul';
