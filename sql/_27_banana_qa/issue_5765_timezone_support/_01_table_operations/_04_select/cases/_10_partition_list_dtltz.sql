--test: test list partition on DATETIMELTZ column

drop table if exists tz_test;

set timezone 'Europe/Bucharest';

--test: [er] create table with duplicate partition values
create table tz_test (id int, dtltz datetime with local time zone, str char(20))
partition by list (dtltz) (
	partition p1 values in (datetimeltz'2000-07-10 3:00:00.999'),
	partition p2 values in (datetimeltz'2000-07-10 12:00:00.999 AM UTC')
);

--test: [er] create list partition table, with unexisted value datetimeltz'2000-3-26 2:30:00.999 Europe/Moscow'
create table tz_test (id int, dtltz datetime with local time zone, str char(20))
partition by list (dtltz) (
        partition p1 values in (datetimeltz'2000-07-10 2:00:00.999', datetimeltz'2000-3-26 2:30:00.999 Europe/Moscow')
);

--test: create list partition table
create table tz_test (id int, dtltz datetime with local time zone, str char(20))
partition by list (dtltz) (
        partition p1 values in (datetimeltz'2000-07-10 2:00:00.999', datetimeltz'2000-3-26 3:30:00.999 Europe/Moscow'),
        partition p2 values in (datetimeltz'2010-10-10 15:00:00.999 Asia/Seoul'),
	partition p3 values in (datetimeltz'1997-07-01 3:00:00.999 +3:00', datetimeltz'2025-12-31 23:59:59.999 CET') 
);

show create table tz_test;

--test: [er] insert out-of-range value
insert into tz_test(id, dtltz) values(1, datetimeltz'1997-07-01 2:00:00.999');

--test: insert p1
insert into tz_test values(1, datetimeltz'2000-07-10 2:00:00.999', 'p1');
insert into tz_test values(2, datetimeltz'2000-3-26 2:30:00.999 +3:00', 'p1');
set timezone 'Europe/Moscow';
insert into tz_test values(3, datetimeltz'2000-3-26 3:30:00.999', 'p1');
--test: insert null
insert into tz_test values(99, null, 'p1');
select * from tz_test__p__p1 order by 1;

--test: insert p2
insert into tz_test values(4, datetimeltz'2010-10-10 15:00:00.999 Asia/Seoul', 'p2');
insert into tz_test values(5, datetimeltz'2010-10-10 14:00:00.999 Asia/Shanghai', 'p2');
select * from tz_test__p__p2 order by 1;

--test: insert p3
insert into tz_test values(6, datetimeltz'1997-06-30 21:00:00.999 -3:00', 'p3');
insert into tz_test values(7, datetimeltz'2025-12-31 23:59:59.999 +1:00', 'p3');
insert into tz_test values(8, datetimeltz'2025-12-31 23:59:59.999 CET', 'p3');
select * from tz_test__p__p3 order by 1;

--test: update
update tz_test set dtltz=datetimeltz'1997-07-01 3:00:00.999 +3:00', str='move from p2 to p3' where str='p2';
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;

--test: update
update tz_test set dtltz=datetimeltz'2010-10-10 15:00:00.999 +9:00', str='back to p2' where id in (4, 5);
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;

--test: update success, result should be '03:30:00.999 AM 03/26/2000 Europe/Moscow MSD'
update tz_test set dtltz=datetimeltz'2000-3-26 2:30:00.999 +3:00' where id=2;

--test: [er] add pk constraint
alter table tz_test change dtltz dtltz datetime with local time zone primary key;
alter table tz_test add constraint primary key (dtltz);

--test: delete 
delete from tz_test where id in (1, 5, 7);
select * from tz_test__p__p1 order by 1;
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;

--test: delete again and add pk
delete from tz_test where id in (2, 6);
alter table tz_test add primary key (dtltz);

--test: udpate again
update tz_test set dtltz=datetimeltz'1997-07-01 3:00:00.999 +3:00', str='moved from p1 to p3' where str='p1';
select * from tz_test__p__p1 order by 1;
select * from tz_test__p__p3 order by 1;

select * from tz_test order by 1;


drop table tz_test;

set timezone 'Asia/Seoul';



