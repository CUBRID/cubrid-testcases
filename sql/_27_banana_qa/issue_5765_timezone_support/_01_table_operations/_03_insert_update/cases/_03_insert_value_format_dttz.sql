--insert into DATETIMETZ columns, with different values


drop table if exists tz_test;

create table tz_test(id int auto_increment, col datetime with time zone);

--test: test different format of values, without time zone
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345');
insert into tz_test(col) values(datetimetz'08:22:50.22 AM 06/23/2014');
insert into tz_test(col) values(datetimetz'2/28/2015');
insert into tz_test(col) values(datetimetz'2/29/2015');
insert into tz_test(col) values(datetimetz'10/30/2014');
insert into tz_test(col) values(datetimetz'1989-10-21');
insert into tz_test(col) values(datetimetz'13:15:45.888 10/31/2008');
insert into tz_test(col) values(datetimetz'01:15:45.888 PM 2008-10-31');
insert into tz_test(col) values(datetimetz'13:15:45.888 2008-10-31');
insert into tz_test(col) values(datetimetz'10/31/2008 01:15:45.888 PM');
insert into tz_test(col) values(datetimetz'10/31/2008 13:15:45.888');
insert into tz_test(col) values(datetimetz'2008-10-31 01:15:45.888 PM');
insert into tz_test(col) values(datetimetz'2008-10-31 13:15:45.888');
insert into tz_test(col) values(datetimetz'13:15:45.888');

select * from tz_test order by 1;


--test: test different format of values, with time zone
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345 +03:00');
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345 -11:00');
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345 AM +3:00');
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345 PM +3:0');
insert into tz_test(col) values(datetimetz'2000-03-28 16:00:00.345 3');
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345 -11');
insert into tz_test(col) values(datetimetz'2000-03-28 08:00:00.345 PM Europe/Berlin');
insert into tz_test(col) values(datetimetz'13:15:45.888 10/31/2008 PM Asia/Seoul KST');
insert into tz_test(col) values(datetimetz'10/31/2008 01:15:45.888 AM Asia/Seoul KDT');

select * from tz_test order by 1;


--test: incomplete datetimetz format, with time zone
insert into tz_test(col) values(datetimetz'1989-10-21 +05:00');
insert into tz_test(col) values(datetimetz'10/31/2008 -10:00');
insert into tz_test(col) values(datetimetz'2/28 Antarctica/Mawson');
insert into tz_test(col) values(datetimetz'2/29 Africa/Luanda');

select * from tz_test order by 1;


drop table tz_test;



