--test string functions with DATETIME(L)TZ columns as arguments


drop table if exists tz_test;

create table tz_test(id int, dtltz datetime with local time zone, dttz datetime with time zone);

set timezone 'Europe/Paris';
insert into tz_test values(1, '1979-10-11 23:46:44.999', '1979-10-11 23:46:44.999');
insert into tz_test values(2, '1979-10-11 23:46:44.999 -4:00', '1979-10-11 23:46:44.999 -4:00');
insert into tz_test values(3, '1979-10-11 23:46:44.999 CET', '1979-10-11 23:46:44.999 CET');
insert into tz_test values(4, '1979-10-11 23:46:44.999 Asia/Seoul', '1979-10-11 23:46:44.999 Asia/Seoul');

--test: concatenation operator
select id, dtltz+'1979-10-11 23:46:44.999' a, dttz+'1979-10-11 23:46:44.999' b from tz_test order by 1;
select id, dtltz||'1979-10-11 23:46:44.999' a, dttz||'1979-10-11 23:46:44.999' b from tz_test order by 1;

--test: string functions
select id, char_length(dtltz), char_length(dttz) from tz_test order by 1;
select id, length(dtltz), length(dttz) from tz_test order by 1;
select id, concat(dtltz, 2, dttz) from tz_test order by 1;
select id, lcase(dtltz), lower(dttz) from tz_test order by 1;
select id, upper(dtltz), ucase(dttz) from tz_test order by 1;
select id, trim(dtltz), trim(dttz) from tz_test order by 1;
select id, substr(dtltz, 24, 6), substr(dttz, 24, 6) from tz_test order by 1;
select id, position(':46:' in dtltz), position(':46:' in dttz) from tz_test order by 1;
select id, repeat(dtltz, 10), repeat(dttz, 5) from tz_test order by 1;


drop table tz_test;
set timezone 'Asia/Seoul';
