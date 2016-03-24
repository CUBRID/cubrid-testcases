--cast numeric columns to DATETIME(L)TZ types


drop table if exists tz_test;

create table tz_test(a smallint, b integer, c bigint, d decimal(4, 2), e real, f double);
insert into tz_test values(1, 11, 111, 11.34, 99.999, 1234.5678);

--test: cast numeric columns to DATETIME types
select cast(a as datetime) from tz_test;
select cast(b as datetime) from tz_test;
select cast(c as datetime) from tz_test;
select cast(d as datetime) from tz_test;
select cast(e as datetime) from tz_test;
select cast(f as datetime) from tz_test;

set timezone 'America/New_York';
--test: cast numeric columns to DATETIMELTZ types
select cast(a as datetime with local time zone) from tz_test;
select cast(b as datetime with local time zone) from tz_test;
select cast(c as datetime with local time zone) from tz_test;
select cast(d as datetime with local time zone) from tz_test;
select cast(e as datetime with local time zone) from tz_test;
select cast(f as datetime with local time zone) from tz_test;

set timezone 'CET';
--test: cast numeric columns to DATETIMETZ types
select cast(a as datetime with time zone) from tz_test;
select cast(b as datetime with time zone) from tz_test;
select cast(c as datetime with time zone) from tz_test;
select cast(d as datetime with time zone) from tz_test;
select cast(e as datetime with time zone) from tz_test;
select cast(f as datetime with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
