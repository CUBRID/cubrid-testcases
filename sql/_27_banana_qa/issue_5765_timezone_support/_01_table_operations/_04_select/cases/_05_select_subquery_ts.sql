--test TIMESTAMP(L)TZ columns, with subqueries in combination with compare expressions
set system parameters 'tz_leap_second_support=yes';


drop table if exists tz_test;

create table tz_test(id int primary key auto_increment, col1 timestamp with local time zone default timestamptz'2014-09-01 2:00:20 Asia/Shanghai', col2 timestamp with time zone);

create index idx1 on tz_test(col1);
create index idx2 on tz_test(col2);
create index idx3 on tz_test(id, col1);

set timezone 'Asia/Seoul';

--normal value without time zone
insert into tz_test(col1, col2) values(timestampltz'2013-12-10 15:30:00', timestamptz'2013-12-10 15:30:00');
insert into tz_test(col1, col2) values(null, timestamptz'2011-05-12 9:12:56 PM');
--normal value with offset time zone
insert into tz_test(col1, col2) values(timestampltz'2013-12-10 3:00:00 AM -03:30', null);
insert into tz_test(col1, col2) values(timestampltz'2011-05-12 5:12:56 PM +5:00', timestamptz'2011-05-12 17:12:56 +05:00');
--normal value with geographic time zone
insert into tz_test(col1, col2) values(timestampltz'2013-12-10 8:30:00 Europe/Bucharest', timestamptz'2013-12-10 8:30:00 Europe/Riga');
insert into tz_test(col1, col2) values(timestampltz'2011-05-12 9:12:56 AM America/Argentina/Buenos_Aires', timestamptz'2011-05-12 10:12:56 America/Noronha');
insert into tz_test default;

--DST related
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 2:00:00', timestamptz'1992-07-10 2:00:00');
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 3:00:00 Europe/Bucharest', timestamptz'1992-07-10 3:00:00 Europe/Bucharest');
set timezone '+2:00';
insert into tz_test(col1, col2) values(timestampltz'1992-07-10 2:00:00', timestamptz'1992-07-10 2:00:00');

--leap second
set timezone 'UTC';
insert into tz_test(col1, col2) values(timestampltz'1994-6-30 23:59:59', timestamptz'1994-6-30 23:59:59');
insert into tz_test(col1, col2) values(timestampltz'1994-6-30 23:59:59'+1, timestamptz'1994-6-30 23:59:59'+1);
set timezone 'Europe/Bucharest';
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 1:59:59 AM', timestamptz'1994-7-1 1:59:59');
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 1:59:59 AM'+1, timestamptz'1994-7-1 1:59:59'+1);
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 2:59:59 AM', timestamptz'1994-7-1 2:59:59');
insert into tz_test(col1, col2) values(timestampltz'1994-7-1 2:59:59 AM'+1, timestamptz'1994-7-1 2:59:59'+1);


--test: subqueries
set timezone 'Asia/Seoul';
select id, (select col1 from tz_test order by id desc limit 1) as col1 from tz_test order by 1;
select (select unique col2 col1 from tz_test where id=5) from tz_test where col1 is not null order by 1;
select id, col1, col2 from (select * from tz_test) where col1 < timestampltz'2014-12-12' order by 1, 2;
select t1.id, t1.col1, (select unique col2 from tz_test t2 where t1.col1=t2.col1 and t2.col2=t2.col1) from tz_test t1 order by 1, 2;
select id, col2, list(select col1 from tz_test where col2 in (timestampltz'1992-07-10 3:00:00 Europe/Bucharest', timestamptz'1992-07-10 2:00:00 +2:00', timestampltz'1994-6-30 23:59:59 +0:00') order by col1) as abcd from tz_test order by 1;

--test: combination with comparison expressions 
set timezone 'Europe/Bucharest';
select * from tz_test where col1 = (select min(col2) from tz_test) order by 1, 2;
select id, col1, col2 from tz_test where col2 < (select max(abc) from (select min(col1) as abc from tz_test group by col2)) order by 1, 2;
--BUG: CUBRIDSUS-15071
select * from tz_test where col1 in (select col2 from tz_test order by 1 desc limit 5) and col2 = any(select col1 from tz_test where year(col1) >= 2000) order by 1, 2;
select * from tz_test t1 where exists (select * from tz_test t2 where t1.col1=t2.col2) order by 1, 2, 3;
select * from tz_test where col1 = all(select col2 from tz_test where col1 is null) order by 1, 2, 3;
select * from tz_test where col1 between (select min(col1) from tz_test) and (select max(col2) from tz_test) order by 1, 2, 3;
select * from tz_test where col2 like (select '%Europe/Bucharest%' from db_class limit 1) order by 1;
select id, col1, col2, case when col1=col2 then 'equal' else 'not equal' end from tz_test order by id;


drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
