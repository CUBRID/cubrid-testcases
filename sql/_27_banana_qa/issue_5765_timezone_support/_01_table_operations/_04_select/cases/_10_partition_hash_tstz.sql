--update TIMESTAMPTZ columns, with orderby and limit clause

autocommit off;

drop table if exists tz_test;
create table tz_test(id int auto_increment, col1 timestamp with time zone default timestamptz'2014-09-01 2:00:20 Asia/Shanghai', col2 timestamp with time zone unique) partition by hash(col2) partitions 5;

set timezone '+14:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 14:12:10', timestamptz'2011-05-12 00:12:57 Pacific/Niue');
set timezone '+12:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 12:12:12', timestamptz'2011-05-12 1:12:55 Pacific/Tahiti');
set timezone '+10:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 10:12:14', timestamptz'2011-05-12 4:12:53 America/Vancouver');
set timezone '+08:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 8:12:16', timestamptz'2011-05-12 5:12:51 Pacific/Galapagos');
set timezone '+06:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 6:12:18', timestamptz'2011-05-12 7:12:49 America/Port_of_Spain');
set timezone '+04:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 4:12:20', timestamptz'2011-05-12 9:12:47 America/Noronha -02');
set timezone '+02:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 2:12:22', timestamptz'2011-05-12 13:12:45 PM CET');
set timezone '-00:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-12 0:12:24', timestamptz'2011-05-12 2:12:43 PM Indian/Comoro');
set timezone '-1:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-11 23:12:26', timestamptz'2011-05-12 4:12:41 PM Asia/Aqtobe');
set timezone '-3:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-11 21:12:28', timestamptz'2011-05-12 6:12:39 PM Asia/Vientiane');
set timezone '-5:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-11 19:12:30', timestamptz'2011-05-12 8:12:37 PM Asia/Dili +09');
set timezone '-7:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-11 17:12:32', timestamptz'2011-05-12 10:12:35 PM Asia/Vladivostok');
set timezone '-9:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-11 15:12:34', timestamptz'2011-05-12 12:12:33 AM Pacific/Fakaofo -11');
set timezone '-11:00';
insert into tz_test(col1, col2) values(timestamp'2011-05-11 13:12:36', timestamptz'2011-05-13 1:12:31 AM Pacific/Kiritimati');

commit;

select * from tz_test order by 1;
select * from tz_test__p__p0 order by 1;
select * from tz_test__p__p1 order by 1;
select * from tz_test__p__p2 order by 1;
select * from tz_test__p__p3 order by 1;
select * from tz_test__p__p4 order by 1;

--test: update with default, pk violation
update tz_test set col1=default;
select id, col1 from tz_test order by col1, id;
--test: update with default
update tz_test set col2=default(col1) order by col1 limit 3;
select id, col2 from tz_test order by col2;
rollback;

--test: update without order by
update tz_test set col1=col1+2, col2=col2-2;
select * from tz_test order by 1;
rollback;

--test: update with order by
update tz_test set col1=col1+2 order by col1 desc;
select * from tz_test order by 1;
update tz_test set col2=col2-2 order by col2 asc;
select * from tz_test order by 1;
rollback;
--test: [er] update with order by, unique violation
update tz_test set col1=col1+2 order by col1 asc;
select * from tz_test order by 1;
update tz_test set col2=col2-2 order by col2 desc;
select * from tz_test order by 1;

--test: update with order by + limit
update tz_test set col1=col1+2 order by col1 desc limit 10;
select * from tz_test order by 1;
update tz_test set col1=col1+2, col2=col2-2 order by col1 desc, col2 desc limit 5;
select * from tz_test order by 1;
rollback;

--test: update 2 columns with order by
update tz_test set col1=col1+2, col2=col2-2 order by col1 desc, col2 asc;
select * from tz_test order by 1;


drop table tz_test;

commit;


set timezone 'Asia/Seoul';
autocommit on;

 
