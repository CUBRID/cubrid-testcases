--test TIME(L)TZ columns, with values clause and for update clause
set system parameters 'tz_leap_second_support=yes';


drop table if exists tz_test;

set timezone '+9:00';
create table tz_test(id int primary key auto_increment, col1 datetime with local time zone default datetimeltz'2015-9-17 2:00:20 +8:00', col2 datetime with time zone);

create index idx1 on tz_test(col1);
create index idx2 on tz_test(col2);
create index idx3 on tz_test(id, col1);


--normal value without time zone
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 15:30:00', datetimetz'2015-9-17 15:30:00');
insert into tz_test(col1, col2) values(null, datetimetz'2015-9-17 9:12:56 PM');
--normal value with offset time zone
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 3:00:00 AM -03:30', null);
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 5:12:56 PM +5:00', datetimetz'2015-9-17 17:12:56 +05:00');
--normal value with geographic time zone
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 8:30:00 America/Belem', datetimetz'2015-9-17 8:30:00 Asia/Gaza');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 9:12:56 AM America/La_Paz', datetimetz'2015-9-17 10:12:56 America/Noronha');
insert into tz_test default;

set timezone 'America/Belem';
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 3:00:00 America/Belem', datetimetz'2015-9-17 3:00:00 America/Belem');
set timezone '+2:00';
insert into tz_test(col1, col2) values(datetimeltz'2015-9-17 2:00:00', datetimetz'2015-9-17 2:00:00');

set timezone 'UTC';
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 23:59:59', datetimetz'2015-9-17 23:59:59');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 23:59:59'+1, datetimetz'2015-9-17 23:59:59'+1);
set timezone 'America/Belem';
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 1:59:59 AM', datetimetz'2015-9-17 1:59:59');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 1:59:59 AM'+1, datetimetz'2015-9-17 1:59:59'+1);
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 2:59:59 AM', datetimetz'2015-9-17 2:59:59');
insert into tz_test(col1, col2) values(datetimetz'2015-9-17 2:59:59 AM'+1, datetimetz'2015-9-17 2:59:59'+1);


--test: values clause
set timezone 'America/Regina';
select * from tz_test t, (values (datetimetz'2015-9-17 9:12:56 AM America/La_Paz', datetimetz'2015-9-17 23:59:59 +00:00')) as test(a, b) where t.col1=test.a or t.col2=test.b order by 1, 2, 3;

--test: for update
select * from tz_test order by 1 for update;
select id, (select col1 from tz_test order by id desc limit 1) as col1 from tz_test order by 1 for update of tz_test;

--test: combination if values clause and for update clause
select * from tz_test t1 left outer join (values (datetimetz'2015-9-17 9:12:56 AM America/La_Paz', datetimetz'2015-9-17 23:59:59 +00:00'), (datetimetz'2015-9-17 2:59:59 AM America/Belem', datetimetz'2015-9-17 2:59:59 AM America/Belem')) as t2(a, b) on t1.col1=t2.a and t1.col2=t2.b order by 1, 2, 3 for update of t1, t2;


drop table tz_test;


set timezone 'Asia/Seoul';

 
set system parameters 'tz_leap_second_support=no';
