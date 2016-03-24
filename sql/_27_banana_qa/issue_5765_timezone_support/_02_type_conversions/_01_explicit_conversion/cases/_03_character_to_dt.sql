--cast character string columns to DATETIME(L)TZ types


drop table if exists tz_test;

create table tz_test(id int, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('12:00:01.999 PM 01/02/2019', '12:00:01.999 PM 01/02/2019 +08:00', '12:00:01.999 PM 01/02/2019 +09:00', '12:00:01.999 PM 01/02/2019 Asia/Tokyo'));
insert into tz_test values(1, 'aaa', 'bbb', 'ccc', 3, 2);
insert into tz_test values(2, '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', '2020-12-1 20:00:00.999', 3, 1);
insert into tz_test values(3, '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', '2020-12-1 20:00:00.999 +9:00', 2, 3);
insert into tz_test values(4, '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', '2020-12-1 20:00:00.999 Asia/Tokyo', 1, 4);

set timezone 'UTC';

--test: cast character string columns to DATETIME types
select cast(a as datetime) from tz_test;
select cast(a as datetime) from tz_test where id > 1 order by id;
select cast(b as datetime) from tz_test;
select cast(b as datetime) from tz_test where id > 1 order by id;
select cast(c as datetime) from tz_test;
select cast(c as datetime) from tz_test where id > 1 order by id;
select cast(d as datetime) from tz_test;
select cast(d as datetime) from tz_test where id > 1 order by id;
select cast(e as datetime) from tz_test;
select cast(e as datetime) from tz_test where id > 1 order by id;

--test: cast character string columns to DATETIMELTZ types
select cast(a as datetime with local time zone) from tz_test;
select cast(a as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(b as datetime with local time zone) from tz_test;
select cast(b as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(c as datetime with local time zone) from tz_test;
select cast(c as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(d as datetime with local time zone) from tz_test;
select cast(d as datetime with local time zone) from tz_test where id > 1 order by id;
select cast(e as datetime with local time zone) from tz_test;
select cast(e as datetime with local time zone) from tz_test where id > 1 order by id;

--test: cast character string columns to DATETIMETZ types
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
