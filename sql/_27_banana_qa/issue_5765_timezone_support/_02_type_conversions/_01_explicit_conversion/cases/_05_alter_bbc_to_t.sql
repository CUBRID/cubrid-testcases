--cast bit/blob/clob columns to TIME(L)TZ types, in alter statement

autocommit off;

drop table if exists tz_test;

create table tz_test(a bit(8), b bit varying, c blob, d clob);
insert into tz_test values(B'10101111', X'abcdef', B'11001010', '03:45:56 Africa/Ouagadougou');
commit;

--test: [er] cast bit/blob/clob columns to TIME types
alter table tz_test modify a time;
alter table tz_test modify b time;
alter table tz_test modify c time;
alter table tz_test modify d time;

--test: [er] cast bit/blob/clob columns to TIMELTZ types
alter table tz_test modify a datetime with local time zone;
alter table tz_test modify b datetime with local time zone;
alter table tz_test modify c datetime with local time zone;
alter table tz_test modify d datetime with local time zone;

--test: [er] cast bit/blob/clob columns to TIMETZ types
alter table tz_test modify a datetime with time zone;
alter table tz_test modify b datetime with time zone;
alter table tz_test modify c datetime with time zone;
alter table tz_test modify d datetime with time zone;

delete from tz_test;
drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
