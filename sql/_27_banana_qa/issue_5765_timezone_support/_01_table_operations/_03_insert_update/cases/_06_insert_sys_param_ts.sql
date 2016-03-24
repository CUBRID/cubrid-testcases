--insert into TIMESTAMP(L)TZ columns, test with system params

set timezone '+00:00';

drop table if exists tz_test;

create table tz_test(
	id int,
	ts timestamp,
	tsltz timestamp with local time zone,
	tstz timestamp with time zone
);


--test: timezone +00:00
insert into tz_test values (1, timestamp'2003-03-30 02:30:00', timestampltz'2003-03-30 02:30:00', timestamptz'2003-03-30 02:30:00 +03:00');
select * from tz_test order by 1;

--test: change session timezone and select
set timezone '+03:00';
select * from tz_test order by 1;

--test: change timezone and insert
set timezone '-10:30';
insert into tz_test values 
	(2, timestamp'2013-03-30 02:30:00', timestampltz'2013-03-30 02:30:00 AM', timestamptz'2013-03-30 02:30:00 AM'),
        (3, timestamptz'2003-03-30 02:30:00 +14:00', timestampltz'2003-03-30 02:30:00 +14:00', timestamptz'2003-03-30 02:30:00 AM +14:00');
select * from tz_test order by 1;

--test: change again and select
set timezone '-00:00';
select * from tz_test order by 1;

--test: insert with timezone, DST in 'America/New_York'
insert into tz_test values(4, timestamptz'1975-2-23 3:30:00 -05:00', timestampltz'1975-2-23 3:30:00 -05:00', timestamptz'1975-2-23 3:30:00 -05:00');
--test: insert not existing time in 'America/New_York'
insert into tz_test values(5, timestamptz'1975-2-23 2:30:00 -05:00', timestampltz'1975-2-23 2:30:00 -05:00', timestamptz'1975-2-23 2:30:00 -05:00');
--test: other values
insert into tz_test values(6, timestamptz'1975-2-23 1:30:00 -05:00', timestampltz'1975-2-23 1:30:00 -05:00', timestamptz'1975-2-23 1:30:00 -05:00');
insert into tz_test values(7, timestamptz'1975-2-22 21:30:00 -05:00', timestampltz'1975-2-22 21:30:00 -05:00', timestamptz'1975-2-21 21:30:00 -05:00');

--test: change to geographic zone name and select, including 
set timezone 'America/New_York';
--BUG: CUBRIDSUS-16318, resolved
select * from tz_test order by 1;
--test: [er] invalid value
set timezone 'America/New_York EST';

--test: [er] insert under 'America/New_York' timezone, not existing time
insert into tz_test values(8, timestamp'1975-2-23 2:30:00', timestampltz'1975-2-23 2:30:00', timestamptz'1975-2-23 2:30:00');
select * from tz_test order by 1;

set timezone 'Asia/Seoul';
insert into tz_test values(9, timestampltz'1987-05-10 00:30:00 GMT', timestampltz'1987-05-10 00:30:00 GMT', timestampltz'1987-05-10 00:30:00 GMT');
select * from tz_test order by 1;

--test: change to another geographic timezone and select
set timezone 'Asia/Hong_Kong';
select * from tz_test order by 1;

--test: insert with another timezone under 'Asia/Hong_Kong'
insert into tz_test values(10, timestampltz'1973-12-30 7:30:00 Pacific/Auckland', timestamptz'1973-12-30 7:30:00 Pacific/Auckland', timestampltz'1973-12-30 7:30:00 Pacific/Auckland');
select * from tz_test order by 1;



drop table tz_test;

set timezone 'Asia/Seoul';
