--cast character string columns to TIME(L)TZ types


drop table if exists tz_test;

create table tz_test(id int, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('12:00:01 PM', '12:00:01 PM +08:00', '12:00:01 PM +09:00', '12:00:01 PM +00:00'));
insert into tz_test values(1, 'aaa', 'bbb', 'ccc', 3, 2);
insert into tz_test values(2, '20:00:00', '20:00:00', '20:00:00', 3, 1);
insert into tz_test values(3, '20:00:00 +9:00', '20:00:00 +9:00', '20:00:00 +9:00', 2, 3);
insert into tz_test values(4, '20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', '20:00:00 Asia/Tokyo', 1, 4);

set timezone '+00:00';

--test: cast character string columns to TIME types
select cast(a as time) from tz_test;
select cast(a as time) from tz_test where id > 1 order by id;
select cast(b as time) from tz_test;
select cast(b as time) from tz_test where id > 1 order by id;
select cast(c as time) from tz_test;
select cast(c as time) from tz_test where id > 1 order by id;
select cast(d as time) from tz_test;
select cast(d as time) from tz_test where id > 1 order by id;
select cast(e as time) from tz_test;
select cast(e as time) from tz_test where id > 1 order by id;

--test: cast character string columns to TIMELTZ types
select cast(a as datetime with local time zone) from tz_test;
--BUG:
select cast(a as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(b as datetime with local time zone) from tz_test;
select cast(b as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(c as datetime with local time zone) from tz_test;
select cast(c as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(d as datetime with local time zone) from tz_test;
select cast(d as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(e as datetime with local time zone) from tz_test;
select cast(e as datetime with local time zone) from tz_test where id > 1 order by id;

--test: cast character string columns to TIMETZ types
select cast(a as datetime with time zone) from tz_test;
select cast(a as datetime with time zone) from tz_test where id > 1 order by id;
select cast(b as datetime with time zone) from tz_test;
select cast(b as datetime with time zone) from tz_test where id > 1 order by id;
select cast(c as datetime with time zone) from tz_test;
select cast(c as datetime with time zone) from tz_test where id > 1 order by id;
select cast(d as datetime with time zone) from tz_test;
select cast(d as datetime with time zone) from tz_test where id > 1 order by id;
select cast(e as datetime with time zone) from tz_test;
select cast(e as datetime with time zone) from tz_test where id > 1 order by id;


drop table tz_test;

set timezone 'Asia/Seoul';
