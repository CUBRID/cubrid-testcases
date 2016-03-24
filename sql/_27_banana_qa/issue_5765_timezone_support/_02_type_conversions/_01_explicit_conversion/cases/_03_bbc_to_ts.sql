--cast bit/blob/clob columns to TIMESTAMP(L)TZ types


drop table if exists tz_test;

create table tz_test(a bit(8), b bit varying, c blob, d clob);
insert into tz_test values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56 Africa/Ouagadougou');

--test: cast bit/blob/clob columns to TIMESTAMP types
select cast(a as timestamp) from tz_test;
select cast(b as timestamp) from tz_test;
select cast(c as timestamp) from tz_test;
select cast(d as timestamp) from tz_test;

--test: cast bit/blob/clob columns to TIMESTAMPLTZ types
select cast(a as timestamp with local time zone) from tz_test;
select cast(b as timestamp with local time zone) from tz_test;
select cast(c as timestamp with local time zone) from tz_test;
select cast(d as timestamp with local time zone) from tz_test;

--test: cast bit/blob/clob columns to TIMESTAMPTZ types
select cast(a as timestamp with time zone) from tz_test;
select cast(b as timestamp with time zone) from tz_test;
select cast(c as timestamp with time zone) from tz_test;
select cast(d as timestamp with time zone) from tz_test;


drop table tz_test;

set timezone 'Asia/Seoul';
