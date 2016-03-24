--cast collection columns to DATETIME(L)TZ types


drop table if exists tz_test;

create table tz_test(a set datetime with time zone, b multiset datetime, c sequence datetime with local time zone);
insert into tz_test values({datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'}, {datetimetz'2000-01-01 12:13:14.999 +4:00'});

--test: cast collection columns to DATETIME types
select cast(a as datetime) from tz_test;
select cast(b as datetime) from tz_test;
select cast(c as datetime) from tz_test;

--test: cast collection columns to DATETIMELTZ types
select cast(a as datetime with local time zone) from tz_test;
select cast(b as datetime with local time zone) from tz_test;
select cast(c as datetime with local time zone) from tz_test;

--test: cast collection columns to DATETIMETZ types
select cast(a as datetime with time zone) from tz_test;
select cast(b as datetime with time zone) from tz_test;
select cast(c as datetime with time zone) from tz_test;

drop table tz_test;

set timezone 'Asia/Seoul';
