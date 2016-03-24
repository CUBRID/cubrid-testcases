--cast bit/blob/clob columns to DATETIME(L)TZ types, in alter statement

autocommit off;

drop table if exists tz_test;

create table tz_test(a bit(8), b bit varying, c blob, d clob);
insert into tz_test values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56.999 Africa/Ouagadougou');
commit;

--test: [er] cast bit/blob/clob columns to DATETIME types
alter table tz_test modify a datetime;
alter table tz_test modify b datetime;
alter table tz_test modify c datetime;
alter table tz_test modify d datetime;

--test: [er] cast bit/blob/clob columns to DATETIMELTZ types
alter table tz_test modify a datetime with local time zone;
alter table tz_test modify b datetime with local time zone;
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;

--test: [er] cast bit/blob/clob columns to DATETIMETZ types
alter table tz_test modify a datetime with time zone;
alter table tz_test modify b datetime with time zone;
alter table tz_test modify c datetime with time zone;
alter table tz_test modify d datetime with time zone;

delete from tz_test;
drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
