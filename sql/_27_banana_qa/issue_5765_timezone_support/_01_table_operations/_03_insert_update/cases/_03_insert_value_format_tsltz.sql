--insert into TIMESTAMPLTZ columns, with different values


drop table if exists tz_test;
create table tz_test(id int auto_increment, col timestamp with local time zone);

--test: test different format of values, without time zone
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00');
insert into tz_test(col) values(timestampltz'08:22:50 AM 06/23/2014');
insert into tz_test(col) values(timestampltz'2/28/2015');
insert into tz_test(col) values(timestampltz'2/29/2015');
insert into tz_test(col) values(timestampltz'10/30/2014');
insert into tz_test(col) values(timestampltz'1989-10-21');
insert into tz_test(col) values(timestampltz'13:15:45 10/31/2008');
insert into tz_test(col) values(timestampltz'01:15:45 PM 2008-10-31');
insert into tz_test(col) values(timestampltz'13:15:45 2008-10-31');
insert into tz_test(col) values(timestampltz'10/31/2008 01:15:45 PM');
insert into tz_test(col) values(timestampltz'10/31/2008 13:15:45');
insert into tz_test(col) values(timestampltz'2008-10-31 01:15:45 PM');
insert into tz_test(col) values(timestampltz'2008-10-31 13:15:45');
insert into tz_test(col) values(timestampltz'13:15:45');

select * from tz_test order by 1;


--test: test different format of values, with time zone
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 +03:00');
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 -11:00');
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 AM +3:00');
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 PM +3:0');
insert into tz_test(col) values(timestampltz'2000-03-28 16:00:00 3');
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 -11');
insert into tz_test(col) values(timestampltz'2000-03-28 08:00:00 PM Europe/Berlin');
insert into tz_test(col) values(timestampltz'13:15:45 10/31/2008 PM Asia/Seoul KST');
insert into tz_test(col) values(timestampltz'10/31/2008 01:15:45 AM Asia/Seoul KDT');

select * from tz_test order by 1;


--test: incomplete timestampltz format, with time zone
insert into tz_test(col) values(timestampltz'1989-10-21 +05:00');
insert into tz_test(col) values(timestampltz'10/31/2008 -10:00');
insert into tz_test(col) values(timestampltz'2/28 Antarctica/Mawson');
insert into tz_test(col) values(timestampltz'2/29 Africa/Luanda');

select * from tz_test order by 1;


drop table tz_test;



