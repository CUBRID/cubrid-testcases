--test TIMESTAMPLTZ column, with group by clause
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


--test: group by
set timezone 'Asia/Seoul';
select col1, sum(id) from tz_test group by col1 order by 1;
set timezone 'UTC';
select unique col2, max(col1) from tz_test group by col2 desc order by col2;
set timezone 'Asia/Seoul';
select col1, col2, avg(id) from tz_test group by col2, col1 asc order by 1, 2, 3;

--test: with rollup 
set timezone 'Europe/Bucharest';
select all col1, min(col2) from tz_test group by col1 with rollup order by 1, 2;
select col1, col2, sum(id) from tz_test group by col2, col1 with rollup order by 1, 2, 3;

--test: group by ... having
select col1, max(col2) from tz_test group by col1 having col1<timestampltz'2013-12-10 15:30:00 +9:00' order by 1, 2;
set timezone 'Asia/Shanghai';
select col2, max(col1) from tz_test group by col1 having max(col1)<timestampltz'2013-12-10 14:30:00' order by 1, 2 limit 3;


drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
