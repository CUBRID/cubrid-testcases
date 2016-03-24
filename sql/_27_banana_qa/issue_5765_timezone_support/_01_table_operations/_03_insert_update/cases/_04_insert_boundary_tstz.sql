--insert into TIMESTAMPLTZ columns, with boundary and out-of-range values

set time zone 'GMT';

drop table if exists tz_test;
create table tz_test(id int auto_increment, col timestamp with time zone);

--test: test with bounadary values
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:01');
insert into tz_test(col) values(timestamptz'2038-01-19 03:14:07');
insert into tz_test(col) values(timestamptz'0000-00-00 00:00:00');
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:01 +00:00');
insert into tz_test(col) values(timestamptz'1970-01-01 05:00:01 +05:00');
insert into tz_test(col) values(timestamptz'1970-01-01 14:00:01 +14:00');
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:01 -0:00');
insert into tz_test(col) values(timestamptz'2038-01-19 03:14:07 +0:00');
insert into tz_test(col) values(timestamptz'2038-01-19 01:14:07 -2:00');
insert into tz_test(col) values(timestamptz'2038-01-18 3:14:07 PM -12:00');
insert into tz_test(col) values(timestamptz'0000-00-00 00:00:00 +00:00');
insert into tz_test(col) values(timestamptz'2038-01-19 03:14:07 -00:00');
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:01 GMT');
insert into tz_test(col) values(timestamptz'2038-01-19 03:14:07 GMT');
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:01 GMT');
insert into tz_test(col) values(timestamptz'1970-01-01 09:00:01 AM Asia/Seoul KST');
insert into tz_test(col) values(timestamptz'1970-01-01 09:00:00 AM Asia/Seoul KST');
insert into tz_test(col) values(timestamptz'2038-01-19 12:14:07 PM Asia/Seoul KST');
insert into tz_test(col) values(timestamptz'2038-01-19 12:14:07 AM Antarctica/Palmer');

select * from tz_test where id in (3, 11, 17) order by id;
select * from tz_test where id not in (3, 11, 17) order by id;


--test: [er] test with out-of-value values
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:00');
insert into tz_test(col) values(timestamptz'1969-12-31 23:59:59');
insert into tz_test(col) values(timestamptz'1870-01-01 00:00:00');
insert into tz_test(col) values(timestamptz'2038-01-19 03:14:08');
insert into tz_test(col) values(timestamptz'2100-01-19 03:14:08');
insert into tz_test(col) values(timestamptz'1970-01-01 00:00:01 +01:00');
insert into tz_test(col) values(timestamptz'1966-01-01 00:00:01 +00:00');
insert into tz_test(col) values(timestamptz'2038-01-19 03:14:07 -00:30');
insert into tz_test(col) values(timestamptz'2038-01-19 5:14:07 -00:00');
insert into tz_test(col) values(timestamptz'1960-02-01 11:00:01 GMT');
insert into tz_test(col) values(timestamptz'2038-01-25 03:14:07 Antarctica/Palmer');
insert into tz_test(col) values(timestamptz'1990-10-10 1:23:22 +14:01');
insert into tz_test(col) values(timestamptz'1990-10-10 1:23:22 +15:00');
insert into tz_test(col) values(timestamptz'1990-10-10 1:23:22 -12:01');
insert into tz_test(col) values(timestamptz'1990-10-10 1:23:22 -13:00');

select * from tz_test order by 1;

set timezone 'America/New_York';
select * from tz_test where id not in (3, 11, 17, 20) order by 1;
set timezone 'Asia/Shanghai';
select * from tz_test where id not in (3, 11, 17, 20) order by 1;

drop table tz_test;

set time zone 'Asia/Seoul';

