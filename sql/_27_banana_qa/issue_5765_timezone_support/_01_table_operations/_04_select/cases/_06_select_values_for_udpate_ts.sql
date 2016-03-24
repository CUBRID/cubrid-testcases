--test TIMESTAMP(L)TZ columns, with values clause and for update clause
set system parameters 'tz_leap_second_support=yes';


drop table if exists tz_test;

set timezone 'Asia/Seoul';
create table tz_test(id int primary key auto_increment, col1 timestamp with local time zone default timestampltz'2014-09-01 2:00:20 Asia/Shanghai', col2 timestamp with time zone);

create index idx1 on tz_test(col1);
create index idx2 on tz_test(col2);
create index idx3 on tz_test(id, col1);


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


--test: values clause
set timezone 'America/New_York';
select * from tz_test t, (values (timestampltz'2011-05-12 9:12:56 AM America/Argentina/Buenos_Aires', timestamptz'1994-6-30 23:59:59 +00:00')) as test(a, b) where t.col1=test.a or t.col2=test.b order by 1, 2, 3;

--test: for update
select * from tz_test order by 1 for update;
select id, (select col1 from tz_test order by id desc limit 1) as col1 from tz_test order by 1 for update of tz_test;

--test: combination if values clause and for update clause
select * from tz_test t1 left outer join (values (timestampltz'2011-05-12 9:12:56 AM America/Argentina/Buenos_Aires', timestamptz'1994-6-30 23:59:59 +00:00'), (timestampltz'1994-7-1 2:59:59 AM Europe/Bucharest', timestamptz'1994-7-1 2:59:59 AM Europe/Bucharest')) as t2(a, b) on t1.col1=t2.a and t1.col2=t2.b order by 1, 2, 3 for update of t1, t2;


drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
