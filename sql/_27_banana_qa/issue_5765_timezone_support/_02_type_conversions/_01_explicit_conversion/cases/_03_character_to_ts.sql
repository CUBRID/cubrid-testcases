--cast character string columns to TIMESTAMP(L)TZ types


drop table if exists tz_test;

create table tz_test(id int, a char(40), b varchar(40), c string, d enum('a', 'b', 'c'), e enum('12:00:01 PM 01/02/2019', '12:00:01 PM 01/02/2019 +08:00', '12:00:01 PM 01/02/2019 +09:00', '12:00:01 PM 01/02/2019 Asia/Tokyo'));
insert into tz_test values(1, 'aaa', 'bbb', 'ccc', 3, 2);
insert into tz_test values(2, '2020-12-1 20:00:00', '2020-12-1 20:00:00', '2020-12-1 20:00:00', 3, 1);
insert into tz_test values(3, '2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', '2020-12-1 20:00:00 +9:00', 2, 3);
insert into tz_test values(4, '2020-12-1 20:00:00 Asia/Tokyo', '2020-12-1 20:00:00 Asia/Tokyo', '2020-12-1 20:00:00 Asia/Tokyo', 1, 4);

set timezone 'UTC';

--test: cast character string columns to TIMESTAMP types
select cast(a as timestamp) from tz_test;
select cast(a as timestamp) from tz_test where id > 1 order by id;
select cast(b as timestamp) from tz_test;
select cast(b as timestamp) from tz_test where id > 1 order by id;
select cast(c as timestamp) from tz_test;
select cast(c as timestamp) from tz_test where id > 1 order by id;
select cast(d as timestamp) from tz_test;
select cast(d as timestamp) from tz_test where id > 1 order by id;
select cast(e as timestamp) from tz_test;
select cast(e as timestamp) from tz_test where id > 1 order by id;

--test: cast character string columns to TIMESTAMPLTZ types
select cast(a as timestamp with local time zone) from tz_test;
--BUG: CUBRIDSUS-15135, resolved
select cast(a as timestamp with local time zone) from tz_test where id > 1 order by id;
select cast(b as timestamp with local time zone) from tz_test;
select cast(b as timestamp with local time zone) from tz_test where id > 1 order by id;
select cast(c as timestamp with local time zone) from tz_test;
select cast(c as timestamp with local time zone) from tz_test where id > 1 order by id;
select cast(d as timestamp with local time zone) from tz_test;
select cast(d as timestamp with local time zone) from tz_test where id > 1 order by id;
select cast(e as timestamp with local time zone) from tz_test;
select cast(e as timestamp with local time zone) from tz_test where id > 1 order by id;

--test: cast character string columns to TIMESTAMPTZ types
select cast(a as timestamp with time zone) from tz_test;
select cast(a as timestamp with time zone) from tz_test where id > 1 order by id;
select cast(b as timestamp with time zone) from tz_test;
select cast(b as timestamp with time zone) from tz_test where id > 1 order by id;
select cast(c as timestamp with time zone) from tz_test;
select cast(c as timestamp with time zone) from tz_test where id > 1 order by id;
select cast(d as timestamp with time zone) from tz_test;
select cast(d as timestamp with time zone) from tz_test where id > 1 order by id;
select cast(e as timestamp with time zone) from tz_test;
select cast(e as timestamp with time zone) from tz_test where id > 1 order by id;


drop table tz_test;

set timezone 'Asia/Seoul';
