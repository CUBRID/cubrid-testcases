--test: test list partition on DATETIMETZ column

drop table if exists tz_test;

set timezone 'Europe/Bucharest';

--test: [er] create table with duplicate partition values
create table tz_test (id int, dttz datetime with time zone, str char(20))
partition by list (dttz) (
	partition p1 values in (datetimetz'2000-07-10 3:00:00.999'),
	partition p2 values in (datetimetz'2000-07-10 12:00:00.999 AM UTC')
);

--test: [er] create list partition table, with unexisted value datetimetz'2000-3-26 2:30:00.999 Europe/Moscow'
create table tz_test (id int, dttz datetime with time zone, str char(20))
partition by list (dttz) (
        partition p1 values in (datetimetz'2000-07-10 2:00:00.999', datetimetz'2000-3-26 2:30:00.999 Europe/Moscow')
);

--test: create list partition table
create table tz_test (id int, dttz datetime with time zone, str char(20))
partition by list (dttz) (
        partition p1 values in (datetimetz'2000-07-10 2:00:00.999', datetimetz'2000-3-26 3:30:00.999 Europe/Moscow'),
        partition p2 values in (datetimetz'2010-10-10 15:00:00.999 Asia/Seoul'),
	partition p3 values in (datetimetz'1997-07-01 3:00:00.999 +3:00', datetimetz'2025-12-31 23:59:59.999 CET') 
);

show create table tz_test;

--test: [er] insert out-of-range value
insert into tz_test(id, dttz) values(1, datetimetz'1997-07-01 3:00:00.999 Asia/Seoul');

--test: insert p1
insert into tz_test values(1, datetimetz'2000-07-10 2:00:00.999', 'p1');
insert into tz_test values(2, datetimetz'2000-3-26 2:30:00.999 +3:00', 'p1');
set timezone 'Europe/Moscow';
insert into tz_test values(3, datetimetz'2000-3-26 3:30:00.999', 'p1');
--insert into tz_test values(3, datetimetz'2000-3-26 2:30:00.999 Europe/Kiev', 'p1');
insert into tz_test values(99, null, 'p1');
select * from tz_test__p__p1 order by 1;

--test: insert p2
insert into tz_test values(4, datetimetz'2010-10-10 15:00:00.999 Asia/Seoul', 'p2');
insert into tz_test values(5, datetimetz'2010-10-10 14:00:00.999 Asia/Shanghai', 'p2');
select * from tz_test__p__p2 order by 1;

--test: insert p3
insert into tz_test values(6, datetimetz'1997-06-30 21:00:00.999 -3:00', 'p3');
insert into tz_test values(7, datetimetz'2025-12-31 23:59:59.999 +1:00', 'p3');
insert into tz_test values(8, datetimetz'2025-12-31 23:59:59.999 CET', 'p3');
select * from tz_test__p__p3 order by 1;

--test: update
update tz_test set dttz=datetimetz'1997-07-01 3:00:00.999 +3:00', str='move from p2 to p3' where str='p2';
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;

--test: update
update tz_test set dttz=datetimetz'2010-10-10 15:00:00.999 +9:00', str='back to p2' where id in (4, 5);
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;

--test: [er] update error
update tz_test set dttz=datetimetz'2000-3-26 2:30:00.999 +3:00' where id=2;

--test: [er] add pk constraint
alter table tz_test change dttz dttz datetime with time zone primary key;
alter table tz_test add constraint primary key(dttz);

--test: delete 
delete from tz_test where id in (1, 5, 7);
select * from tz_test__p__p1 order by 1;
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;

--test: delete again and add pk
delete from tz_test where id in (2, 6);
alter table tz_test add constraint primary key(dttz);

--test: udpate again
update tz_test set dttz=datetimetz'1997-07-01 3:00:00.999 +3:00', str='moved from p1 to p3' where str='p1';
select * from tz_test__p__p1 order by 1;
select * from tz_test__p__p3 order by 1;

select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';


