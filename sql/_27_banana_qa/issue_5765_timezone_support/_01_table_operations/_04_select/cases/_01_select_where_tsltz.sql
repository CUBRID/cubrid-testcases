--test TIMESTAMPLTZ column, with where clause
set system parameters 'tz_leap_second_support=yes';

drop table if exists tz_test;

create table tz_test(id int primary key auto_increment, col1 timestamp with local time zone not null default timestampltz'2014-09-01 2:00:20 Asia/Shanghai', col2 timestamp with local time zone);

set timezone 'Asia/Seoul';

--normal value without time zone
insert into tz_test(col1, col2) values(timestampltz'2013-12-10 15:30:00', timestampltz'2013-12-10 15:30:00');
insert into tz_test(col1, col2) values(timestampltz'2011-05-12 9:12:56 PM', timestampltz'2011-05-12 9:12:56 PM');
--normal value with offset time zone
insert into tz_test(col1, col2) values(timestampltz'2013-12-10 3:00:00 AM -03:30', timestampltz'2013-12-10 3:00:00 -3:30');
insert into tz_test(col1, col2) values(timestampltz'2011-05-12 5:12:56 PM +5:00', timestampltz'2011-05-12 17:12:56 +05:00');
--normal value with geographic time zone
insert into tz_test(col1, col2) values(timestampltz'2013-12-10 8:30:00 Europe/Bucharest', timestampltz'2013-12-10 8:30:00 Europe/Riga');
insert into tz_test(col1, col2) values(timestampltz'2011-05-12 9:12:56 AM America/Argentina/Buenos_Aires', timestampltz'2011-05-12 10:12:56 America/Noronha');

--DST related
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 2:00:00', timestampltz'1992-07-10 2:00:00');
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 3:00:00 Europe/Bucharest', timestampltz'1992-07-10 3:00:00 Europe/Bucharest');
set timezone '+2:00';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 2:00:00', timestampltz'1992-07-10 2:00:00');

--leap second
set timezone 'UTC';
insert into tz_test(col1, col2) values(timestampltz'1994-6-30 23:59:59', timestampltz'1994-6-30 23:59:59');
insert into tz_test(col1, col2) values(timestampltz'1994-6-30 23:59:59'+1, timestampltz'1994-6-30 23:59:59'+1);
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 1:59:59 AM', timestampltz'1994-7-1 1:59:59');
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 1:59:59 AM'+1, timestampltz'1994-7-1 1:59:59'+1);
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 2:59:59 AM', timestampltz'1994-7-1 2:59:59');
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 2:59:59 AM'+1, timestampltz'1994-7-1 2:59:59'+1);


--test: select all
set timezone 'Asia/Seoul';
--BUG: CUBRIDSUS-15041, resolved
select * from tz_test order by 1;
select all * from tz_test order by id;
select all * from tz_test order by col2, id desc limit 3;

set timezone 'Europe/Bucharest';
select distinct col1 from tz_test order by 1;
select unique col1, col2 from tz_test order by 1;

--test: where clause, normal value, col=constant value, 3 rows should be selected
select * from tz_test where col1=timestampltz'2013-12-10 15:30:00 +9:00' order by 1;
set timezone 'Asia/Seoul';
select * from tz_test where col2=timestampltz'2013-12-10 15:30:00' order by col1, id;
select col2, id from tz_test where col1=timestampltz'2013-12-10 8:30:00 Europe/Riga' order by 1, id desc;
set timezone 'America/Argentina/Buenos_Aires';
select col1, col2, id from tz_test where col1=timestampltz'2011-05-12 9:12:56 AM' order by 1, 2, id asc;
set timezone '+4:00';
select * from tz_test where col2=timestampltz'2011-05-12 17:12:56 +05:00' order by 1;
select * from tz_test where col2=timestampltz'2011-05-12 16:12:56' order by 1;
select col2, col1, id from tz_test where col2=timestampltz'2011-05-12 9:12:56 AM America/Argentina/Buenos_Aires' order by 1, 2, id desc;

--test: where clause, normal value, col<constant value, 3 rows should be selected
set timezone '-04:30';
select * from tz_test where col1>timestampltz'2013-12-10 1:00:00' order by 1;
set timezone 'Australia/Perth';
select * from tz_test where col1<timestampltz'2013-12-10 15:30:00 +9:00' and col2>timestampltz'2011-05-12 8:12:55 PM' order by 1;

--test: where clause, with hour() function
set timezone 'Asia/Seoul';
select * from tz_test where hour(col1)=9 order by 3, 2, 1;
set timezone 'Europe/Bucharest';
select * from tz_test where hour(col2)=8 order by 3, 2, 1;

--test: where clause, col1=col2, col1<col2
select * from tz_test where col1=col2 order by id;
set timezone 'Asia/Shanghai';
select unique col1, col2 from tz_test where col1=col2 order by col1;
select unique col1, col2 from tz_test where col1<col2 order by col2;

--test: where clause, DST values, 1 row should be select
set timezone 'Europe/Bucharest';
select * from tz_test where col1=timestampltz'1992-07-10 2:00:00' order by 1;
--test: where clause, DST values, 2 rows should be select
select * from tz_test where col2=timestampltz'1992-07-10 3:00:00' order by 1;
select col1, col2 from tz_test where col2=timestampltz'1992-07-10 10:00:00 +10:00' order by 1;

--test: where clause, leap second
select * from tz_test where col1=timestampltz'1994-6-30 23:59:59 UTC' and col2=timestampltz'1994-6-30 23:59:59 GMT' order by 1;
set timezone 'UTC';
select id, col1, col2 from tz_test where col1=(timestampltz'1994-6-30 23:59:59'+1) order by 1, col2;
select id, col1, col2 from tz_test where col2<timestampltz'1994-6-30 23:59:59'+1 order by 1, col2 desc, col1;
select id, col1, col2 from tz_test where col2=timestampltz'1994-7-01 00:00:00' order by 1, col2 desc, col1;
select id, col1, col2 from tz_test where col1<timestampltz'1994-7-01 00:00:00' order by 1, col1 desc, col2;
set timezone 'Europe/Bucharest';
select * from tz_test where col2=timestampltz'1994-7-1 2:59:59 AM' order by 1;
select * from tz_test where col2=(timestampltz'1994-7-1 2:59:59 AM'+1) order by 1;
select * from tz_test where col1=timestampltz'1994-7-1 1:59:59 AM Europe/Bucharest' order by 1;
select * from tz_test where col2=(timestampltz'1994-7-1 1:59:59 AM'+1) order by 1;
select col1, col2 from tz_test where col1=timestampltz'1994-7-1 7:59:59 Asia/Harbin' and col2=timestampltz'6/30/1994 21:59:59 -2:00';
select col1, col2 from tz_test where col1<timestampltz'1994-7-1 7:59:59 Asia/Harbin'+1 or col2<timestampltz'6/30/1994 21:59:59 -2:00'+1;

--test: update to null
update tz_test set col2=default where hour(col1)=hour(timestampltz'2013-12-10 3:00:00 AM -03:30');
select * from tz_test where col2 is not null order by 1;

update tz_test set col2=default(col1) where year(col1)>2011 order by id;
set timezone '-7:00';
select col1, col2 from tz_test where col2=default(col1) order by col1, col2;


drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
