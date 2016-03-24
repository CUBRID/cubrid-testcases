--cast numeric columns to TIMESTAMP(L)TZ types


drop table if exists tz_test;

create table tz_test(a smallint, b integer, c bigint, d decimal(4, 2), e real, f double);
insert into tz_test values(1, 11, 111, 11.34, 99.999, 1234.5678);

--test: cast numeric columns to TIMESTAMP types
select cast(a as timestamp) from tz_test;
select cast(b as timestamp) from tz_test;
select cast(c as timestamp) from tz_test;
select cast(d as timestamp) from tz_test;
select cast(e as timestamp) from tz_test;
select cast(f as timestamp) from tz_test;

set timezone 'America/New_York';
--test: cast numeric columns to TIMESTAMPLTZ types
select cast(a as timestamp with local time zone) from tz_test;
select cast(b as timestamp with local time zone) from tz_test;
select cast(c as timestamp with local time zone) from tz_test;
select cast(d as timestamp with local time zone) from tz_test;
select cast(e as timestamp with local time zone) from tz_test;
select cast(f as timestamp with local time zone) from tz_test;

set timezone 'CET';
--test: cast numeric columns to TIMESTAMPTZ types
select cast(a as timestamp with time zone) from tz_test;
select cast(b as timestamp with time zone) from tz_test;
select cast(c as timestamp with time zone) from tz_test;
select cast(d as timestamp with time zone) from tz_test;
select cast(e as timestamp with time zone) from tz_test;
select cast(f as timestamp with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
