--cast collection columns to TIMESTAMP(L)TZ types


drop table if exists tz_test;

create table tz_test(a set timestamp with time zone, b multiset timestamp, c sequence timestamp with local time zone);
insert into tz_test values({timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'});

--test: cast collection columns to TIMESTAMP types
select cast(a as timestamp) from tz_test;
select cast(b as timestamp) from tz_test;
select cast(c as timestamp) from tz_test;

--test: cast collection columns to TIMESTAMPLTZ types
select cast(a as timestamp with local time zone) from tz_test;
select cast(b as timestamp with local time zone) from tz_test;
select cast(c as timestamp with local time zone) from tz_test;

--test: cast collection columns to TIMESTAMPTZ types
select cast(a as timestamp with time zone) from tz_test;
select cast(b as timestamp with time zone) from tz_test;
select cast(c as timestamp with time zone) from tz_test;

drop table tz_test;

set timezone 'Asia/Seoul';
