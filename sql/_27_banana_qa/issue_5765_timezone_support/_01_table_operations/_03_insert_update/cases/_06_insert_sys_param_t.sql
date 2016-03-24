--insert into TIME(L)TZ columns, test with system params

set timezone '+00:00';

drop table if exists tz_test;

create table tz_test(
	id int,
	ts time,
	tltz datetime with local time zone,
	ttz datetime with time zone
);


--test: timezone +00:00
insert into tz_test values (1, time'02:30:00', datetimeltz'2015-9-17 02:30:00', datetimetz'2015-9-17 02:30:00 +03:00');
select * from tz_test order by 1;

--test: change session timezone and select
set timezone '+03:00';
select * from tz_test order by 1;

--test: change timezone and insert
set timezone '-10:30';
insert into tz_test values 
	(2, time'02:30:00', datetimeltz'2015-9-17 02:30:00 AM', datetimetz'2015-9-17 02:30:00 AM'),
        (3, datetimetz'2015-9-17 02:30:00 +14:00', datetimeltz'2015-9-17 02:30:00 +14:00', datetimetz'2015-9-17 02:30:00 AM +14:00');
select * from tz_test order by 1;

--test: change again and select
set timezone '-00:00';
select * from tz_test order by 1;

insert into tz_test values(4, datetimetz'2015-9-17 3:30:00 -05:00', datetimeltz'2015-9-17 3:30:00 -05:00', datetimetz'2015-9-17 3:30:00 -05:00');
insert into tz_test values(5, datetimetz'2015-9-17 2:30:00 -05:00', datetimeltz'2015-9-17 2:30:00 -05:00', datetimetz'2015-9-17 2:30:00 -05:00');
--test: other values
insert into tz_test values(6, datetimetz'2015-9-17 1:30:00 -05:00', datetimeltz'2015-9-17 1:30:00 -05:00', datetimetz'2015-9-17 1:30:00 -05:00');
insert into tz_test values(7, datetimetz'2015-9-17 21:30:00 -05:00', datetimeltz'2015-9-17 21:30:00 -05:00', datetimetz'2015-9-17 21:30:00 -05:00');

--test: change to geographic zone name and select, including 
set timezone 'Asia/Shanghai';
select * from tz_test order by 1;
--test: [er] invalid value
set timezone 'America/New_York EST';

insert into tz_test values(8, time'2:30:00', datetimeltz'2015-9-17 2:30:00', datetimetz'2015-9-17 2:30:00');
select * from tz_test order by 1;

--test: change to another geographic timezone and select
set timezone 'America/Cayman';
select * from tz_test order by 1;

--test: insert with another timezone under 'Asia/Hong_Kong'
insert into tz_test values(9, datetimeltz'2015-9-17 7:30:00 Pacific/Niue', datetimetz'2015-9-17 7:30:00 Pacific/Niue', datetimeltz'2015-9-17 7:30:00 Pacific/Niue');
select * from tz_test order by 1;



drop table tz_test;

set timezone 'default';
