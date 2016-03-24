--test TIMESTAMPTZ column, with ODKU statement

drop table if exists tz_test;
create table tz_test(id int, tstz timestamp with time zone primary key, str varchar(10));

set timezone '+00:00';

insert into tz_test values(1, timestamptz'2014-07-01 10:00:00 PM', 'a');

--test: normal duplicate value, should be updated
insert into tz_test values(2, timestamptz'2014-07-01 22:00:00', 'b') on duplicate key update id=2, str='updated1';
select if(id=2 and str='updated1', 'ok', 'nok') from tz_test order by 1;

--test: insert with same timezone, should be updated
insert into tz_test values(3, timestamptz'2014-07-01 22:00:00 UTC', 'c') on duplicate key update id=2, str='updated2';
select if(id=2 and str='updated2', 'ok', 'nok') from tz_test order by 1;

--test: change session timezone and insert same value, a new row should be inserted
set timezone '-6:00';
insert into tz_test values(3, timestamptz'2014-07-01 22:00:00', 'c') on duplicate key update id=3, str='updated';
select if(count(*)=2, 'ok', 'nok') from tz_test order by 1;

--test: insert with time zone 'America/Indiana/Tell_City', whose GMT offset is '-6:00', but should be inserted because of value is DST
insert into tz_test values(4, timestamptz'2014-07-01 10:00:00 PM America/Indiana/Tell_City', 'd') on duplicate key update id=3, str='updated2', tstz=timestamptz'2014-07-01 10:00:00 PM America/Indiana/Tell_City';
select if(count(*)=3, 'ok', 'nok') from tz_test order by 1;
select * from tz_test order by 1;

--test: insert with time zone 'America/Indiana/Tell_City', whose GMT offset is '-6:00', should be updated
insert into tz_test values(5, timestamptz'2014-07-01 11:00:00 PM America/Indiana/Tell_City', 'e') on duplicate key update id=5, str='updated1', tstz=timestamptz'2014-07-01 11:00:00 PM America/Indiana/Tell_City';
select if(str='updated1', 'ok', 'nok') from tz_test where id=5 order by 1;
select * from tz_test order by 1;

--test: change session timezone and insert, with same UTC value, should be updated
set timezone 'Asia/Shanghai';
insert into tz_test values(6, timestamptz'2014-07-02 12:00:00 PM', 'f') on duplicate key update str='updated2';
select if(str='updated2', 'ok', 'nok') from tz_test where id=5 order by 1;
select * from tz_test order by 1;

--test: add unique constraint to another column and test
alter table tz_test modify id int unique;
insert into tz_test values(7, timestamptz'2014-07-02 13:00:00 Asia/Seoul', 'g') on duplicate key update id=5, str='updated3';
select * from tz_test order by 1;

--test: test with different geographic timezone, but same GMT offset
insert into tz_test values(8, timestamptz'2014-02-03 2:12:13 Asia/Hong_Kong', 'HongKong') on duplicate key update id=100, str='abcdefg';
insert into tz_test values(8, timestamptz'2014-02-03 2:12:13 Asia/Shanghai', 'HongKong') on duplicate key update str='Shanghai';
select if(str='Shanghai', 'ok', 'nok') from tz_test where id=8 order by 1;
select if(count(*)=4, 'ok', 'nok') from tz_test order by 1;
select * from tz_test order by 1;

--test: test with ambiguous values
set timezone 'Asia/Seoul';
insert into tz_test values(10, timestamptz'1987-10-11 2:11:12', 'default') on duplicate key update str='abc';
insert into tz_test values(11, timestamptz'1987-10-11 2:11:12 Asia/Seoul KST', 'KST') on duplicate key update str='KST';
insert into tz_test values(12, timestamptz'1987-10-11 2:11:12 Asia/Seoul KDT', 'KDT') on duplicate key update str='KDT';
select if(count(*)=6, 'ok', 'nok') from tz_test order by 1;
select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';

