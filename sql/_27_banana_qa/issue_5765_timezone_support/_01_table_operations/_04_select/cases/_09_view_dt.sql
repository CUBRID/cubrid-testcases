set system parameters 'create_table_reuseoid=no';
--test DATETIME(L)TZ columns, with view

autocommit off;
drop table if exists tz_test;

create table tz_test(id int primary key auto_increment, col1 datetime with time zone not null default datetimetz'2014-09-01 2:00:20.999 Asia/Shanghai', col2 datetime with local time zone);

set timezone 'Asia/Seoul';

insert into tz_test(col1, col2) values(datetimetz'1933-12-10 15:30:00.999', datetimeltz'1933-12-10 15:30:00.999');
insert into tz_test(col1, col2) values(datetimetz'1933-12-10 3:30:30.999 PM +9:00', datetimeltz'1933-12-10 15:30:00.999 +9:00');
insert into tz_test(col1, col2) values(datetimetz'1933-12-10 3:00:00.999 AM -03:30', datetimeltz'1933-12-10 3:00:00.999 -3:30');
insert into tz_test(col1, col2) values(datetimetz'1933-12-10 15:30:00.999 Asia/Tokyo', datetimeltz'1933-12-10 3:30:00.999 PM Asia/Tokyo');
insert into tz_test(col1, col2) values(datetimetz'1933-12-10 8:30:00.999 Europe/Bucharest', datetimeltz'1933-12-10 8:30:00.999 Europe/Riga');

commit;

--test: create normal view
create view v1 as select * from tz_test;
desc v1;
show create view v1;

set timezone 'Europe/Bucharest';
insert into v1(col1, col2) values(datetimetz'1891-07-10 2:00:00.999', datetimeltz'1891-07-10 2:00:00.999');
insert into v1(col1, col2) values(datetimetz'1891-07-10 3:00:00.999 Europe/Bucharest', datetimeltz'1891-07-10 3:00:00.999 Europe/Bucharest');
set timezone '+2:00';
insert into v1(col1, col2) values(datetimetz'1891-07-10 2:00:00.999', datetimeltz'1891-07-10 2:00:00.999 +2:00');


--test: select from view
set timezone 'Asia/Seoul';
select all * from v1 order by id;

set timezone 'Europe/Bucharest';
select distinct newt.col1 from (select id,col1 from v1 order by id) newt order by 1;
select unique newt.col1, newt.col2 from (select id,col1,col2 from tz_test order by id) newt  order by 1;

--test: alter view
alter view v1 as select * from tz_test where col1<datetimetz'1933-12-10 15:30:00.999 +8:59' and col2>datetimetz'1891-07-10 2:00:00.999';
update v1 set col1=col1+1000*3600, col2='1931-12-31 9:00:00.999 Asia/Tokyo';
select * from v1 order by 1, 2, 3;
update tz_test set col2=datetimetz'2014-10-31';
select * from v1 order by 1, 2, 3;

rollback;

--test: create view with check option
create view v2 as select * from tz_test where col1<datetimetz'1933-12-10 15:30:01.999 +9:00' and col2>datetimeltz'1933-12-10 15:30:00 +9:00' with check option;
--test: [er] violate the view condition
update v2 set col1=datetimetz'5678-01-01 12:12:12.999 -10:00';
select * from v2 order by 1, 2, 3;
--test: [er] violate the view condition
update v2 set col1=col1+1000;
--test: update the view with check option
update v2 set col1=col1-1, col2=col2+1;
select * from v2 order by 1, 2, 3;


drop view v2;
drop table tz_test;

set timezone 'Asia/Seoul';

commit;
autocommit on;

 
set system parameters 'create_table_reuseoid=yes';
