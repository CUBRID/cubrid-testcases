--cast bit/blob/clob columns to TIMESTAMP(L)TZ types, in alter statement

autocommit off;

drop table if exists tz_test;

create table tz_test(a bit(8), b bit varying, c blob, d clob);
insert into tz_test values(B'10101111', X'abcdef', B'11001010', '2009-10-12 03:45:56 Africa/Ouagadougou');
commit;

--test: [er] cast bit/blob/clob columns to TIMESTAMP types
alter table tz_test modify a timestamp;
alter table tz_test modify b timestamp;
alter table tz_test modify c timestamp;
alter table tz_test modify d timestamp;

--test: [er] cast bit/blob/clob columns to TIMESTAMPLTZ types
alter table tz_test modify a timestamp with local time zone;
alter table tz_test modify b timestamp with local time zone;
alter table tz_test modify c timestamp with local time zone;
alter table tz_test modify d timestamp with local time zone;

--test: [er] cast bit/blob/clob columns to TIMESTAMPTZ types
alter table tz_test modify a timestamp with time zone;
alter table tz_test modify b timestamp with time zone;
alter table tz_test modify c timestamp with time zone;
alter table tz_test modify d timestamp with time zone;

delete from tz_test;
drop table tz_test;
commit;

set timezone 'Asia/Seoul';
autocommit on;
