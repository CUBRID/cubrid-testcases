--cast collection columns to TIMESTAMP(L)TZ types, in alter statement


drop table if exists tz_test;

create table tz_test(a set timestamp with time zone, b multiset timestamp, c sequence timestamp with local time zone);
insert into tz_test values({timestampltz'2000-01-01 12:13:14 +4:00'}, {timestampltz'2000-01-01 12:13:14 +4:00'}, {timestamptz'2000-01-01 12:13:14 +4:00'});

--test: [er] cast collection columns to TIMESTAMP types
alter table tz_test modify a timestamp;
alter table tz_test modify b timestamp;
alter table tz_test modify c timestamp;
select * from tz_test order by 1;

--test: [er] cast collection columns to TIMESTAMPLTZ types
alter table tz_test modify a timestamp with local time zone;
alter table tz_test modify b timestamp with local time zone;
alter table tz_test modify c timestamp with local time zone;
select * from tz_test order by 1;

--test: [er] cast collection columns to TIMESTAMPTZ types
alter table tz_test modify a timestamp with time zone;
alter table tz_test modify b timestamp with time zone;
alter table tz_test modify c timestamp with time zone;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';
