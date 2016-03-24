--cast collection columns to DATETIME(L)TZ types, in alter statement


drop table if exists tz_test;

create table tz_test(a set datetime with time zone, b multiset datetime, c sequence datetime with local time zone);
insert into tz_test values({datetimeltz'2000-01-01 12:13:14.999 +4:00'}, {datetimeltz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'});

--test: [er] cast collection columns to DATETIME types
alter table tz_test modify a datetime;
alter table tz_test modify b datetime;
alter table tz_test modify c datetime;
select * from tz_test order by 1;

--test: [er] cast collection columns to DATETIMELTZ types
alter table tz_test modify a datetime with local time zone;
alter table tz_test modify b datetime with local time zone;
alter table tz_test modify c datetime with local time zone;
select * from tz_test order by 1;

--test: [er] cast collection columns to DATETIMETZ types
alter table tz_test modify a datetime with time zone;
alter table tz_test modify b datetime with time zone;
alter table tz_test modify c datetime with time zone;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
