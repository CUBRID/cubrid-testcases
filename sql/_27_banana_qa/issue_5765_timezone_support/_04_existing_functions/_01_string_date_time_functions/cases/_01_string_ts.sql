--test string functions with TIMESTAMP(L)TZ columns as arguments


drop table if exists tz_test;

create table tz_test(id int, tsltz timestamp with local time zone, tstz timestamp with time zone);

set timezone 'Europe/Paris';
insert into tz_test values(1, '1979-10-11 23:46:44', '1979-10-11 23:46:44');
insert into tz_test values(2, '1979-10-11 23:46:44 -4:00', '1979-10-11 23:46:44 -4:00');
insert into tz_test values(3, '1979-10-11 23:46:44 CET', '1979-10-11 23:46:44 CET');
insert into tz_test values(4, '1979-10-11 23:46:44 Asia/Seoul', '1979-10-11 23:46:44 Asia/Seoul');

--test: concatenation operator
select id, tsltz+'1979-10-11 23:46:44' a, tstz+'1979-10-11 23:46:44' b from tz_test order by 1;
select id, tsltz||'1979-10-11 23:46:44' a, tstz||'1979-10-11 23:46:44' b from tz_test order by 1;

--test: string functions
select id, char_length(tsltz), char_length(tstz) from tz_test order by 1;
select id, length(tsltz), length(tstz) from tz_test order by 1;
select id, concat(tsltz, 2, tstz) from tz_test order by 1;
select id, lcase(tsltz), lower(tstz) from tz_test order by 1;
select id, upper(tsltz), ucase(tstz) from tz_test order by 1;
select id, trim(tsltz), trim(tstz) from tz_test order by 1;
select id, substr(tsltz, 24, 6), substr(tstz, 24, 6) from tz_test order by 1;
select id, position(':46:' in tsltz), position(':46:' in tstz) from tz_test order by 1;
select id, repeat(tsltz, 10), repeat(tstz, 5) from tz_test order by 1;


drop table tz_test;
set timezone 'Asia/Seoul';
