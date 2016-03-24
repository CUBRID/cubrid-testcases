--test range partition on TIMESTAMPTZ colum

drop table if exists tz_test;

set timezone '+00:00';
create table tz_test(id int, tstz timestamp with time zone, str varchar(50)) 
partition by range(tstz)
(	partition p1 values less than (timestamptz'1990-06-01 1:00:00'),
	partition p2 values less than (timestamptz'1990-06-01 1:00:00 -4:00'),
	partition p3 values less than (timestamptz'1990-06-01 8:00:00'),
	partition p4 values less than (timestamptz'1990-05-31 23:00:00 Pacific/Kwajalein')
);

--test: [er] create index on partition
create index idx on tz_test__p__p1(tstz);
--test: create index on partition
create index idx on tz_test(tstz);

show create table tz_test;

set timezone 'Pacific/Kiritimati';
show create table tz_test;

set timezone '-1:00';
show create table tz_test;

--test: [er] insert out-of-range value
insert into tz_test values(9, timestamptz'2000-01-01 00:00:00', 'out-of-range');

--test: insert into partition table, without timezone
insert into tz_test values(1, timestamptz'1990-05-31 23:59:59', 'p1');
insert into tz_test values(2, timestamptz'1990-06-01 1:00:00', 'p2');
insert into tz_test values(3, timestamptz'1990-06-01 4:00:00 AM', 'p3');
set timezone 'Pacific/Kwajalein';
insert into tz_test values(4, timestamptz'1990-05-31 22:59:59', 'p4');

select * from tz_test order by 1, 2, 3;
select * from tz_test__p__p1 order by 1, 2, 3;
select * from tz_test__p__p2 order by 1, 2, 3;
select * from tz_test__p__p3 order by 1, 2, 3;
select * from tz_test__p__p4 order by 1, 2, 3;

--test: insert into partition table, with timezone
insert into tz_test values(11, timestamptz'1990-05-31 23:59:59 +1:00', 'p1');
insert into tz_test values(11, timestamptz'1990-05-31 3:00:00 +2:00', 'p1');
insert into tz_test values(44, timestamptz'1990-05-31 22:59:59 -12:00', 'p4');
set timezone 'America/New_York';
show create table tz_test;
insert into tz_test values(22, timestamptz'1990-06-01 13:00:00 Asia/Seoul', 'p2');
insert into tz_test values(33, timestamptz'1990-06-01 17:00:00 Pacific/Kosrae', 'p3');

--test: insert null value
insert into tz_test values(11, null, 'p1');

select * from tz_test order by 1, 2, 3;
select * from tz_test__p__p1 order by 1, 2, 3;
select * from tz_test__p__p2 order by 1, 2, 3;
select * from tz_test__p__p3 order by 1, 2, 3;
select * from tz_test__p__p4 order by 1, 2, 3;

--test: insert DST values
set timezone 'Africa/Cairo';
insert into tz_test values(111, timestamptz'1990-06-01 3:00:00', 'p1');
insert into tz_test values(222, timestamptz'1990-06-01 7:00:00', 'p2');
insert into tz_test values(333, timestamptz'1990-06-01 8:00:00', 'p3');
--[er] out of range
insert into tz_test values(444, timestamptz'1990-06-01 14:00:01', 'p4');
insert into tz_test values(444, timestamptz'1990-06-01 13:59:59', 'p4');

select * from tz_test order by 1, 2, 3;
select * from tz_test__p__p1 order by 1, 2, 3;
select * from tz_test__p__p2 order by 1, 2, 3;
select * from tz_test__p__p3 order by 1, 2, 3;
select * from tz_test__p__p4 order by 1, 2, 3;

set timezone 'Europe/Riga';
--test: update partition
update tz_test set tstz=timestamptz'1990-06-01 10:30:21', str='moved from p2 to p3', id=333 where id=222;
select * from tz_test__p__p2 order by 1, 2, 3;
select * from tz_test__p__p3 order by 1, 2, 3;

update tz_test set id=44, tstz=timestamptz'1990-06-01 13:59:59 Europe/Riga', str='moved from p1 to p4' where tstz=timestamptz'1990-05-31 3:00:00 +2:00';
select * from tz_test__p__p1 order by 1, 2, 3;
select * from tz_test__p__p4 order by 1, 2, 3;

update tz_test set tstz=tstz-10801, str='moved from p2 to p1' where id in (2, 22);
select * from tz_test__p__p1 order by 1, 2, 3;
select * from tz_test__p__p2 order by 1, 2, 3;

update tz_test set tstz=tstz+1, str='added 1 sec' where str in ('p2', 'p3');
select * from tz_test order by 1, 2, 3;
select * from tz_test__p__p1 order by 1, 2, 3;
select * from tz_test__p__p2 order by 1, 2, 3;
select * from tz_test__p__p3 order by 1, 2, 3;
select * from tz_test__p__p4 order by 1, 2, 3;

update tz_test set tstz=tstz-1, str='substract 1 sec from p1' where id=11;
select * from tz_test__p__p1 order by 1, 2, 3;

--test: [er] add smaller partition
alter table tz_test add partition (partition p0 values less than (timestamptz'1990-06-01 4:00:00 +4:00'));

set timezone 'Asia/Shanghai';
--test: [er] reorganize partition, change 1 partition
alter table tz_test reorganize partition p2 into (partition p2 values less than (timestamptz'1990-06-01 9:00:00 UTC'));
--test: reorganize partition, change 1 partition with the same range
alter table tz_test reorganize partition p2 into (partition p2 values less than (timestamptz'1990-06-01 5:00:00 UTC'));
show create table tz_test;
select * from tz_test order by 1, 2, 3;
--test: reorganize partition, split into 2 partitions
alter table tz_test
reorganize partition p3 into (
	partition p31 values less than (timestamptz'1990-06-01 15:00:00'),
	partition p32 values less than (timestamptz'1990-06-01 17:00:00')
);
select * from tz_test__p__p31 order by 1, 2, 3;
select * from tz_test__p__p32 order by 1, 2, 3;

--test: remove partition
alter table tz_test remove partitioning;
show create table tz_test;
select * from tz_test order by 1, 2, 3;
--test: [er] select after partition is removed
select * from z_test__p__p21 order by 1, 2, 3;


drop table tz_test;

set timezone 'Asia/Seoul';
